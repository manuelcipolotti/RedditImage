//
//  QuestionModel.swift
//  Cardif - Ipertensione
//
//  Created by Assunta Della Valle on 12/10/2020.
//  Copyright © 2020 Assunta Della Valle. All rights reserved.
//

import Foundation
import Combine

enum ServiceError: Error {
    case url(URLError?)
    case decode
    case urlMissing
    case empty
    case userMissing
    case unknown(Error)
}

class ImageModel: NSObject {
    
    let urlReddit: String = "https://www.reddit.com/r/{KEYWORD}/top.json"
    
    func getImages(keyword: String) -> AnyPublisher<[ImagePhoto]?, Never> {
        
        return Deferred {
            Future<[ImagePhoto]?, Never> { promise in
                
                if !keyword.isEmpty {
                    if keyword == "batman" {
                        var images: [ImagePhoto] = []
                        images.append(ImagePhoto.init(title: "Prova 1", url: "https://b.thumbs.redditmedia.com/gRQqFu2Eaxpl8XF86dckWA2vp1nXRW1NjKjSB9fiMWw.jpg", author: "Manuel"))
                        images.append(ImagePhoto.init(title: "Prova 2", url: "https://b.thumbs.redditmedia.com/sMSrTC_Xa8ZzTGyI-PrZUWdGMX_iSdFGs-aQIad4A3g.jpg", author: "Manuel"))
                        promise(.success(images))
                    } else {
                        promise(.success([]))
                    }
                } else {
                    promise(.success(nil))
                }
            }
          }.eraseToAnyPublisher()

    }
    
    func getImagesFromURL(keyword: String) -> AnyPublisher<[ImagePhoto]?, Error> {
        
        enum HTTPError: LocalizedError {
            case statusCode
        }
        
        if keyword.isEmpty {
            return Just<[ImagePhoto]?>(nil).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        

        if let url = URL.init(string: self.urlReddit.replacingOccurrences(of: "{KEYWORD}", with: keyword)) {
            return URLSession.shared.dataTaskPublisher(for: url)
                .tryMap { element -> Data in
                    
                    if let httpResponse = element.response as? HTTPURLResponse,
                       httpResponse.statusCode == 200 || httpResponse.statusCode == 302 || httpResponse.statusCode == 404{
                        if httpResponse.statusCode == 200 {
                            return element.data
                        } else {
                            throw ServiceError.empty
                        }
                    } else {
                        throw URLError(.badServerResponse)
                    }
                    
                }
                .decode(type: RedditResponse.self, decoder: JSONDecoder())
                .map({ redditImage in
                    if let childrens = redditImage.data?.children {
                        
                        let redditChilds: [RedditImage.Child] = childrens.filter({
                            let children = $0
                            if let thumbnail = children.data?.thumbnail,
                               let _ = children.data?.title,
                               let _ = children.data?.author,
                               !thumbnail.isEmpty {
                                return true
                            } else {
                                return false
                            }
                        })
                        let listImagePhoto: [ImagePhoto] = redditChilds.map({
                            let children = $0
                            if let imageUrl = children.data?.thumbnail,
                               let title = children.data?.title,
                               let author = children.data?.author {
                                return ImagePhoto.init(title: title,
                                                       url: imageUrl,
                                                       author: author)
                            } else {
                                return ImagePhoto.init(title: "", url: "", author: "")
                            }
                        })
                        return listImagePhoto
                    } else {
                        let listImagePhoto: [ImagePhoto] = []
                        return listImagePhoto
                    }
                    
                    
            })
            .eraseToAnyPublisher()
        } else {
            return Fail(error: ServiceError.urlMissing).eraseToAnyPublisher()
        }
        
    }
    
    func setFavorite(imagePhoto: ImagePhoto) -> AnyPublisher<Bool, Never> {
      
        let future = Future<Bool, Never> { promise in
            let defaults = UserDefaults.standard
            var imagesPhotoToSave: [ImagePhoto] = [imagePhoto]
            if let imagesPhotoData = defaults.object(forKey: "imagesFovorite") as? Data {
                let decoder = JSONDecoder()
                if let imagesPhoto = try? decoder.decode([ImagePhoto].self, from: imagesPhotoData) {
                    imagesPhotoToSave.append(contentsOf: imagesPhoto)
                }
            }

            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(imagesPhotoToSave) {
                UserDefaults.standard.setValue(encoded, forKey: "imagesFovorite")
                promise(.success(true))
            } else {
                promise(.success(false))
            }
        }
        return future.eraseToAnyPublisher()
    }

    func isFavorite(imagePhoto: ImagePhoto) -> AnyPublisher<Bool, Never> {
      
        let future = Future<Bool, Never> { promise in
            let defaults = UserDefaults.standard
            if let imagesPhotoData = defaults.object(forKey: "imagesFovorite") as? Data {
                let decoder = JSONDecoder()
                if let imagesPhoto = try? decoder.decode([ImagePhoto].self, from: imagesPhotoData) {
                    if let _ = imagesPhoto.first(where: {
                        return $0.author == imagePhoto.author
                            && $0.title == imagePhoto.title
                            && $0.url == imagePhoto.url
                    }) {
                        promise(.success(true))
                    }
                }
            }
            promise(.success(false))
        }
        return future.eraseToAnyPublisher()
    }

    func removeFavorite(imagePhoto: ImagePhoto) -> AnyPublisher<Bool, Never> {
        
        let future = Future<Bool, Never> { promise in
            let defaults = UserDefaults.standard
            if let imagesPhotoData = defaults.object(forKey: "imagesFovorite") as? Data {
                let decoder = JSONDecoder()
                if var imagesPhoto = try? decoder.decode([ImagePhoto].self, from: imagesPhotoData) {
                    imagesPhoto.removeAll(where: {
                        return $0.author == imagePhoto.author
                            && $0.title == imagePhoto.title
                            && $0.url == imagePhoto.url
                    })
                    let encoder = JSONEncoder()
                    if let encoded = try? encoder.encode(imagesPhoto) {
                        UserDefaults.standard.setValue(encoded, forKey: "imagesFovorite")
                        promise(.success(true))
                    }
                }
            }
            promise(.success(false))
        }
        return future.eraseToAnyPublisher()
    }

    
    func loadImagesFavorite() -> AnyPublisher<[ImagePhoto], Never> {
        
        let future = Future<[ImagePhoto], Never> { promise in
            
            let defaults = UserDefaults.standard
            if let imagesPhotoData = defaults.object(forKey: "imagesFovorite") as? Data {
                let decoder = JSONDecoder()
                if let imagesPhoto = try? decoder.decode([ImagePhoto].self, from: imagesPhotoData) {
                    promise(.success(imagesPhoto))
                }
            }
            promise(.success([]))
        }
        return future.eraseToAnyPublisher()
    }

    
}
