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

    @Published public var newAnswer: Bool?

    private var subscribers = Set<AnyCancellable>()
    
    let model: ImageModel = ImageModel.init()
    
    func getImages(keyword: String) {
        
        model.getImages(keyword: keyword)
            .sink(receiveCompletion: {
                completion in
                switch completion {
                case .failure(let error):
                    print(error, "Failed")
                case .finished:
                    print("Finished quest")
                }
                },
            receiveValue: {  list in
                self.imagesList = list
            }).store(in: &subscribers)
    }
}
