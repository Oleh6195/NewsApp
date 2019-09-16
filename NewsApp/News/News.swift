//
//  News.swift
//  NewsApp
//
//  Created by Олег on 09.09.2019.
//  Copyright © 2019 OlehTyzhai. All rights reserved.
//

import Foundation

class News{
    // class that represents News
    let apiKey = "9ab9b4b3b5d5439a957de9b308285c5b"
    var news:Array<Article>;
    init() {
        self.news = []
    }
    func loadHeadlines(userCompletionHandler: @escaping (Array<Article>, Error?) -> Void) {
        // loading the headlines from News API
        load(url: URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=\(apiKey)".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)!, userCompletionHandler: userCompletionHandler)
    }
    
    func load(q: String,userCompletionHandler: @escaping (Array<Article>, Error?) -> Void) {
        // loading news by key word
        let keys = q.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        load(url: URL(string: "https://newsapi.org/v2/everything?q=\(keys)&apiKey=\(apiKey)".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)! as URL, userCompletionHandler: userCompletionHandler)
    }
    
    func load(source: String, type:String, country:String, userCompletionHandler: @escaping (Array<Article>, Error?) -> Void) {
        // loading news by filter
        let source = source.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        let type = type.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        let country = country.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)

        load(url: URL(string: "https://newsapi.org/v2/top-headlines?source=\(source)&category=\(type)&country=\(country)&apiKey=\(apiKey)".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)! as URL, userCompletionHandler: userCompletionHandler)
    }
    
    func load( url: URL, userCompletionHandler: @escaping (Array<Article>, Error?) -> Void) {
        // procesing API requests and loading the news
        var result:Array<Article> = []
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil{
                print(error!)
            } else {
                guard let data = data else {return}
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let recipe = json as? [String: Any] {
                        if let articles = recipe["articles"] as? NSArray {
                        
                            for article in (articles as NSArray as! [NSDictionary]){
                                guard let source = article["source"] as? NSDictionary else {continue}
                                guard let sourcename = source["name"] as? String else {continue}
                                guard let author = article["author"] as? String else {continue}
                                guard let title = article["title"] as? String else {continue}
                                guard let description = article["description"] as? String else {continue}
                                guard let urlToImage = article["urlToImage"] as? String else {continue}
                                guard let url = article["url"] as? String else {continue}
                                guard let publishedAt = article["publishedAt"] as? String else {continue}
                                result.append(Article(source: sourcename, author: author, title: title, description: description, urlToImage: urlToImage, url: url, dateStr: publishedAt))
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

    

