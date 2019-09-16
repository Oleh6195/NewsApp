//
//  New.swift
//  NewsApp
//
//  Created by Олег on 09.09.2019.
//  Copyright © 2019 OlehTyzhai. All rights reserved.
//

import Foundation
import UIKit

struct Article {
    // Structure that represent one article
    var source, author, title, description: String;
    var urlToImage, url: URL;
    var publishedAt:Date;
    var image:UIImage
    init(source:String, author:String, title:String, description:String, urlToImage:String, url:String, dateStr:String) {
        self.source = source
        self.author = author
        self.title = title
        self.description = description
        self.urlToImage = URL(string: urlToImage) ?? URL(string: "https://user-images.githubusercontent.com/24848110/33519396-7e56363c-d79d-11e7-969b-09782f5ccbab.png")!
        self.url = URL(string: url)!
        self.image = UIImage(named: "imgnotfound")!
        // Converting date in string format to date format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        self.publishedAt = dateFormatter.date(from:dateStr)!

    }

}
