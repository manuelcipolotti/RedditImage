//
//  ImagePhotoDetailView.swift
//  RedditImage
//
//  Created by Manuel Cipolotti on 30/04/21.
//

import Foundation

struct ImagePhotoDetailView: Codable {
    var title: String
    var url: String
    var author: String
    var first: Bool = false
    var last: Bool = false
    var favorite: Bool = false
}


extension ImagePhotoDetailView {
    init(imagePhoto: ImagePhoto) {
        self.author = imagePhoto.author
        self.title = imagePhoto.title
        self.url = imagePhoto.url
    }
}
