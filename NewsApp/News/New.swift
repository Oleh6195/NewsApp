//
//  New.swift
//  NewsApp
//
//  Created by Олег on 09.09.2019.
//  Copyright © 2019 OlehTyzhai. All rights reserved.
//

import Foundation
struct New {
    var source: String;
    var author: String;
    var title: String;
    var description: String;
    var urlToImage: URL;
    var url: URL;
    init(source:String, author:String, title:String, description:String, urlToImage:String, url:String) {
        self.source = source
        self.author = author
        self.title = title
        self.description = description
        self.urlToImage = URL(string: urlToImage)!
        self.url = URL(string: url)!
    }
}

//struct New: Codable {
//
//    let source: String;
//    let author: String;
//    let title: String;
//    let description: String;
//    let urlToImage: String;
//
//    private enum CodingKeys: String, CodingKey {
//        case source
//        case author
//        case title
//        case description
//        case urlToImage
//
//    }
//}

