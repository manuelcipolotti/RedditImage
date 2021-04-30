//
//  QuestionPresenter.swift
//  Cardif - Ipertensione
//
//  Created by Assunta Della Valle on 12/10/2020.
//  Copyright © 2020 Assunta Della Valle. All rights reserved.
//

import Foundation
import UIKit
import Combine

class ImagesPresenter: NSObject {
    
    static let instance: ImagesPresenter = ImagesPresenter.init()
    
    @Published public var imagesList: [ImagePhoto]?
    @Published public var favoritesImagesList: [ImagePhoto]?
    @Published public var imageSelected: ImagePhotoDetailView?
    @Published public var favoriteImageSelected: ImagePhotoDetailView?

    @Published public var isLoading: Bool = false
    @Published public var isConnectionError: Bool = false

    private var imageSelectedIndex: Int?
    private var favoriteImageSelectedIndex: Int?

    private var subscribers = Set<AnyCancellable>()
    private var cancellable: AnyCancellable?

    let model: ImageModel = ImageModel.init()
    
    func getImages(keyword: String) {
        self.isLoading = true
        self.isConnectionError = false
        model.getImagesFromURL(keyword: keyword)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                switch completion {
                case .failure(let error):
                    if let serviceError = error as? ServiceError{
                        switch serviceError {
                        case .empty:
                            self.imagesList = []
                        default:
                            self.isConnectionError = true
                            print(error, "Failed")
                        }
                        print(serviceError)
                    } else {
                        self.isConnectionError = true
                        print(error, "Failed")
                    }
                case .finished:
                    print("Finished quest")
                }
                },
            receiveValue: {  list in
                self.imagesList = list
            }).store(in: &subscribers)
    }

    func getFavoritesImages() {
        
        model.loadImagesFavorite()
            .sink(receiveCompletion: {
                completion in
                switch completion {
                case .failure(let error):
                    if let serviceError = error as? ServiceError{
                        switch serviceError {
                        case .empty:
                            self.imagesList = []
                        default:
                            print(error, "Failed")
                        }
                        print(serviceError)
                    } else {
                        print(error, "Failed")
                    }
                case .finished:
                    print("Finished quest")
                }
                },
            receiveValue: {  list in
                self.favoritesImagesList = list
            }).store(in: &subscribers)
    }

    
    private func getImage(index: Int) -> ImagePhotoDetailView? {
        if let imagesList = self.imagesList,
           index >= 0 && index < imagesList.count {
            self.imageSelectedIndex = index
            let image = imagesList[index]
            var imageSelected = ImagePhotoDetailView.init(imagePhoto: image)
            if index == 0 {
                imageSelected.first = true
            }
            if index == (imagesList.count-1) {
                imageSelected.last = true
            }
            return imageSelected
        }
        return nil
    }

    func getImageSelected(index: Int) {
        self.imageSelected = getImage(index: index)
    }
    
    func getNext()  {
        if var index = self.imageSelectedIndex {
            index += 1
            self.imageSelected = getImage(index: index)
        }
    }
    
    func getPrior()  {
        if var index = self.imageSelectedIndex {
            index -= 1
            self.imageSelected = getImage(index: index)
        }
    }
    // MARK: - favorite
    private func getFavoriteImage(index: Int) -> ImagePhotoDetailView? {
        if let imagesList = self.favoritesImagesList,
           index >= 0 && index < imagesList.count {
            self.favoriteImageSelectedIndex = index
            let image = imagesList[index]
            var imageSelected = ImagePhotoDetailView.init(imagePhoto: image)
            if index == 0 {
                imageSelected.first = true
            }
            if index == (imagesList.count-1) {
                imageSelected.last = true
            }
            return imageSelected
        }
        return nil
    }

    func getFavoriteImageSelected(index: Int) {
        self.favoriteImageSelected = getFavoriteImage(index: index)
    }
    
    func getFavoriteNext()  {
        if var index = self.favoriteImageSelectedIndex {
            index += 1
            self.favoriteImageSelected = getFavoriteImage(index: index)
        }
    }
    
    func getFavoritePrior()  {
        if var index = self.favoriteImageSelectedIndex {
            index -= 1
            self.favoriteImageSelected = getFavoriteImage(index: index)
        }
    }

    func setFavorite(imagePhoto: ImagePhoto,
                     okAction: @escaping () -> Void,
                     koAction: @escaping () -> Void) {
        cancellable = model.setFavorite(imagePhoto: imagePhoto)
            .sink(receiveCompletion: { completion in
                    switch completion {
                        case .failure(let error):
                            print(error, "Failed for some reason.")
                        case .finished:
                            print("Finished.")
                    }
                }, receiveValue: { saved in
                    if saved {
                        okAction()
                    } else {
                        koAction()
                    }
                })
    }

    func removeFavorite(imagePhoto: ImagePhoto,
                        okAction: @escaping () -> Void,
                        koAction: @escaping () -> Void) {
        cancellable = model.removeFavorite(imagePhoto: imagePhoto)
            .sink(receiveCompletion: { completion in
                    switch completion {
                        case .failure(let error):
                            print(error, "Failed for some reason.")
                        case .finished:
                            print("Finished.")
                    }
                }, receiveValue: { removed in
                    if removed {
                        okAction()
                    } else {
                        koAction()
                    }
                })
    }

    func isFavorite(imagePhoto: ImagePhoto,
                    okAction: @escaping (_ favorite: Bool) -> Void) {
        cancellable = model.isFavorite(imagePhoto: imagePhoto)
            .sink(receiveCompletion: { completion in
                    switch completion {
                        case .failure(let error):
                            print(error, "Failed for some reason.")
                        case .finished:
                            print("Finished.")
                    }
                }, receiveValue: { favorite in
                    okAction(favorite)
                })
    }


    func isFavorites(okAction: @escaping (_ favorite: Bool) -> Void) {
        cancellable = model.loadImagesFavorite()
            .sink(receiveCompletion: { completion in
                    switch completion {
                        case .failure(let error):
                            print(error, "Failed for some reason.")
                        case .finished:
                            print("Finished.")
                    }
                }, receiveValue: { listFavorites in
                    okAction(listFavorites.count > 0)
                })
    }


}
