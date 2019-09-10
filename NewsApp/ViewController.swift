//
//  ViewController.swift
//  NewsApp
//
//  Created by Олег on 09.09.2019.
//  Copyright © 2019 OlehTyzhai. All rights reserved.
//

import UIKit
import SafariServices
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SFSafariViewControllerDelegate{
    @IBOutlet weak var tableView: UITableView!
    var tableContent: Array<New> = []
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VIewTableViewCell", for: indexPath) as! VIewTableViewCell
        cell.author?.text = tableContent[indexPath.row].author
        cell.source?.text = tableContent[indexPath.row].source
        cell.desc?.text = tableContent[indexPath.row].description
        let requeest = NSMutableURLRequest(url: tableContent[indexPath.row].urlToImage)
        let task = URLSession.shared.dataTask(with: requeest as URLRequest) { (data, response, err) in
            if err != nil{
                print("Error")
            }else{
                if let data = data {
                    if let image = UIImage(data: data){
                    cell.img.image = image
                    }
                    
                }
            }
        }
        task.resume()
        
        cell.title?.text = tableContent[indexPath.row].title
        
        return cell
            
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 500 //or whatever you need
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let safariVC = SFSafariViewController(url: tableContent[indexPath.row].url as URL)
        self.present(safariVC, animated: true, completion: nil)
        safariVC.delegate = self
    }
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerTableViewCells()
        print(1)
        let news = News()
        news.load { (result, error) in
            if error != nil{
                print("Error")
            }
            else{
                self.tableContent = result
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }

    
    }
    func registerTableViewCells(){
        let cell = UINib(nibName: "VIewTableViewCell", bundle: nil)
        self.tableView.register(cell, forCellReuseIdentifier: "VIewTableViewCell")
    }


}

