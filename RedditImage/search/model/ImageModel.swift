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
                        images.append(ImagePhoto.init(title: "Prova 1", url: "https://b.thumbs.redditmedia.com/gRQqFu2Eaxpl8XF86dckWA2vp1nXRW1NjKjSB9fiMWw.jpg", author: "Manuel", first: true, last: false))
                        images.append(ImagePhoto.init(title: "Prova 2", url: "https://b.thumbs.redditmedia.com/sMSrTC_Xa8ZzTGyI-PrZUWdGMX_iSdFGs-aQIad4A3g.jpg", author: "Manuel", first: false, last: true))
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
                                                       author: author, first: true,
                                                       last: false)
                            } else {
                                return ImagePhoto.init(title: "", url: "", author: "", first: false, last: false)
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
    
}
