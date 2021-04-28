//
//  QuestionModel.swift
//  Cardif - Ipertensione
//
//  Created by Assunta Della Valle on 12/10/2020.
//  Copyright © 2020 Assunta Della Valle. All rights reserved.
//

import Foundation
import Combine

class ImageModel: NSObject {
    
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
    
}
