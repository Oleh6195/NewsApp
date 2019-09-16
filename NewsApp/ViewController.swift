//
//  ViewController.swift
//  NewsApp
//
//  Created by Олег on 09.09.2019.
//  Copyright © 2019 OlehTyzhai. All rights reserved.
//

import UIKit
import SafariServices
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SFSafariViewControllerDelegate, UISearchBarDelegate, UIPickerViewDelegate, UIPickerViewDataSource
{
    // VARIABLE DECLARATION START
    var source = "", country = "", type = ""
    var indicator = UIActivityIndicatorView()
    let sources = ["", "CNN", "Google News"]
    let countries = ["", "us", "ua", "ru"]
    let types = ["", "bussines", "technology"]
    var toolBar: UIToolbar!
    var pickerCountry, pickerSource, pickerType: UIPickerView!
    var limit = 5
    var index = 0
    var lastNews = "headlines"
    var tableContent: Array<Article> = []
    var totalContent: Array<Article> = []
    var refresher: UIRefreshControl!
    var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    // VARIABLE DECLARATION STOP

    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerTableViewCells()
        self.reloadData()
        self.makeRefresher()
        self.makeSearchBar()
        UINavigationBar.appearance().tintColor = UIColor(named: "blue")

    }

    func makeSearchBar() {
        // adding the search bar to the top of table view
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        searchBar.barStyle = .blackOpaque
        searchBar.placeholder = "Search"
        searchBar.tintColor = .white
        searchBar.delegate = self
        searchBar.showsBookmarkButton = true
        searchBar.setImage(UIImage(named: "Sort"), for: .bookmark, state: .normal)
        tableView.tableHeaderView = searchBar
    }

    func makeRefresher() {
        // adding refresher to application
        refresher = UIRefreshControl()
        self.tableView.addSubview(refresher)
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.tintColor = UIColor(red: 1.0, green: 0.21, blue: 0.55, alpha: 1.0)
        refresher.addTarget(self, action: #selector(completeArray), for: .valueChanged)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        // the number of components in the picker view
        return 3
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // the number of rows in the picker view component
        switch component {
        case 0:
            return sources.count
        case 1:
            return types.count
        case 2:
            return countries.count

        default:
            return 0
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // return choosing item for every component of picker view
        switch component {
        case 0:
            source = sources[row]
        case 1:
            type = types[row]
        case 2:
            country = countries[row]
        default:
            break
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return sources[row]
        case 1:
            return types[row]
        case 2:
            return countries[row]


        default:
            return nil
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableContent.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VIewTableViewCell", for: indexPath) as! VIewTableViewCell
        cell.author?.text = tableContent[indexPath.row].author
        cell.source?.text = tableContent[indexPath.row].source
        cell.desc?.text = tableContent[indexPath.row].description
        do {
            cell.img.image = try UIImage(data: NSData(contentsOf: tableContent[indexPath.row].urlToImage) as Data, scale: 0.5)
        } catch {
            cell.img.image = tableContent[indexPath.row].image
        }
        cell.title?.text = tableContent[indexPath.row].title

        return cell

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let safariVC = SFSafariViewController(url: tableContent[indexPath.row].url as URL)
        self.present(safariVC, animated: true, completion: nil)
        safariVC.delegate = self
    }

//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if indexPath.row == intTotalrow - 1 {
//            print(tableContent.count, indexPath.row, tableContent.count)
//            if indexPath.row == tableContent.count - 1 {
//                if tableContent.count < totalContent.count {
//                    self.index = tableContent.count
//                    self.limit = self.index + self.limit
//                    while self.index < self.limit && self.index < totalContent.count - 1 {
//                        self.tableContent.append(self.totalContent[self.index])
//                        self.index += 1
//                    }
//                    self.perform(#selector(loadTable), with: nil, afterDelay: 1.0)
//
//                }
//            }
//        }
//    }

    @objc func loadTable() {
        self.tableView.reloadData()
    }

    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }

    func createPicker() -> UIPickerView {
        let picker = UIPickerView.init()
        picker.delegate = self
        picker.backgroundColor = UIColor.white
        picker.setValue(UIColor.black, forKey: "textColor")
        picker.autoresizingMask = .flexibleWidth
        picker.contentMode = .center
        picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        return picker
    }

    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        pickerCountry = createPicker()
        pickerSource = createPicker()
        pickerType = createPicker()
        self.view.addSubview(pickerCountry)
        self.view.addSubview(pickerSource)
        self.view.addSubview(pickerType)

        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.barStyle = .blackTranslucent
        toolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(donePicker))]
        self.view.addSubview(toolBar)
    }

    func registerTableViewCells() {
        let cell = UINib(nibName: "VIewTableViewCell", bundle: nil)
        self.tableView.register(cell, forCellReuseIdentifier: "VIewTableViewCell")
    }

    @objc func completeArray() {
        print(lastNews)
        print(type)
        switch lastNews {
        case "headlines":
            reloadData()
        case "search":
            reloadData(q: searchBar.text!)
        case "filter":
            reloadData(source: source, type: type, country: country)
        default:
            reloadData()
        }
        self.refresher.endRefreshing()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        reloadData(q: searchBar.text!)
        lastNews = "search"
    }

    @objc func donePicker() {
        pickerCountry.isHidden = true
        pickerType.isHidden = true
        pickerSource.isHidden = true
        toolBar.isHidden = true
        print("zby")
        reloadData(source: source, type: type, country: country)
        lastNews = "filter"

    }

    func reloadData(q: String) {
        self.tableContent = []
        self.tableView.reloadData()
        startIndicator()
        let news = News()
        news.load(q: searchBar.text!, userCompletionHandler: { (result, error) in
            self.tableContent = result
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.stopIndicator()
            }
        })
    }

    func reloadData(source: String, type: String, country: String) {
        self.tableContent = []
        self.tableView.reloadData()
        startIndicator()
        let news = News()
        news.load(source: source, type: type, country: country, userCompletionHandler: { (result, error) in
            self.tableContent = result
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.stopIndicator()
            }
        })
    }

    func reloadData() -> Void {
        self.tableContent = []
        self.tableView.reloadData()
        startIndicator()
        let news = News()
        news.loadHeadlines { (result, error) in
            self.totalContent = result
            while self.index < self.limit {
                self.tableContent.append(self.totalContent[self.index])
                self.index = self.index + 1
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.stopIndicator()
            }
        }
    }

    func startIndicator() {
        indicator.center = self.view.center
        indicator.hidesWhenStopped = true
        indicator.style = UIActivityIndicatorView.Style.gray
        view.addSubview(indicator)
        indicator.startAnimating()
    }

    func stopIndicator() {
        indicator.stopAnimating()
    }


}

