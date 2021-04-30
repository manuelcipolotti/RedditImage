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
    @Published public var imageSelected: ImagePhoto?

    @Published public var newAnswer: Bool?
    
    private var imageSelectedIndex: Int?

    private var subscribers = Set<AnyCancellable>()
    
    let model: ImageModel = ImageModel.init()
    
    func getImages(keyword: String) {
        
        model.getImagesFromURL(keyword: keyword)
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
                self.imagesList = list
            }).store(in: &subscribers)
    }
    
    
    func getImage(index: Int) {
        
        if let imagesList = self.imagesList,
           index >= 0 && index < imagesList.count {
            self.imageSelectedIndex = index
            let image = imagesList[index]
            self.imageSelected = image
        }
    }
    
    func getNext()  {
        if var index = self.imageSelectedIndex {
            index += 1
            if let imagesList = self.imagesList,
               index >= 0 && index < imagesList.count {
                self.imageSelectedIndex = index
                let image = imagesList[index]
                self.imageSelected = image
            }
        }
    }
    
    func getPrior()  {
        if var index = self.imageSelectedIndex {
            index -= 1
            if let imagesList = self.imagesList,
               index >= 0 && index < imagesList.count {
                self.imageSelectedIndex = index
                let image = imagesList[index]
                self.imageSelected = image
            }
        }
    }

}
