//
//  News.swift
//  NewsApp
//
//  Created by Олег on 09.09.2019.
//  Copyright © 2019 OlehTyzhai. All rights reserved.
//

import Foundation
class News{
    var news:Array<New>;
    init() {
        self.news = []
    }
    func load(userCompletionHandler: @escaping (Array<New>, Error?) -> Void) {
        var result:Array<New> = []
        guard let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=9ab9b4b3b5d5439a957de9b308285c5b") else {return}
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil{
                print(error!)

            } else {
                guard let data = data else {return}
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
//                    print(json)
                    if let recipe = json as? [String: Any] {
                        if let articles = recipe["articles"] as? NSArray {
                            
                            print(result)
                            for article in (articles as NSArray as! [NSDictionary]){
                                guard let source = article["source"] as? NSDictionary else {continue}
                                guard let sourcename = source["name"] as? String else {continue}
                                guard let author = article["author"] as? String else {continue}
                                guard let title = article["title"] as? String else {continue}
                                guard let description = article["description"] as? String else {continue}
                                guard let urlToImage = article["urlToImage"] as? String else {continue}
                                guard let url = article["url"] as? String else {continue}
                                print(url)
                                result.append(New(source: sourcename, author: author, title: title, description: description, urlToImage: urlToImage, url: url))
//
                        }
                            userCompletionHandler(result, nil)
                    }
                    }
                }catch{
                    print("Json Loading Failed")
                }
                }
            }
        task.resume()
        }
    
    }
    

