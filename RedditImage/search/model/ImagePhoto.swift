//
//  Question.swift
//  Cardif - Ipertensione
//
//  Created by Assunta Della Valle on 12/10/2020.
//  Copyright © 2020 Assunta Della Valle. All rights reserved.
//

import Foundation

struct ImagePhoto: Codable {
    var title: String
    var url: String
    var author: String
}

extension ImagePhoto {
    init(imagePhotoDetail: ImagePhotoDetailView) {
        self.author = imagePhotoDetail.author
        self.title = imagePhotoDetail.title
        self.url = imagePhotoDetail.url
    }
}
