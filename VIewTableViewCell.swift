//
//  ViewTableViewCell.swift
//  NewsApp
//
//  Created by Олег on 13.09.2019.
//  Copyright © 2019 OlehTyzhai. All rights reserved.
//

import UIKit

class VIewTableViewCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var source: UILabel!
    @IBOutlet weak var img: UIImageView! = {
        var imageV = UIImageView()
        imageV.translatesAutoresizingMaskIntoConstraints = false
        imageV.frame = CGRect(x: 0,y: 0,width: 32,height: 16);
        return imageV
    }()
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var desc: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        accessibility()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func accessibility(){
        title.accessibilityLabel = "News Title"
        source.accessibilityLabel = "News Source"
        img.accessibilityLabel = "News"
        author.accessibilityLabel = "News Author"
        desc.accessibilityLabel = "News Description"
        title.font = UIFont.preferredFont(forTextStyle: .title3)
        title.adjustsFontForContentSizeCategory = true
        desc.font = UIFont.preferredFont(forTextStyle: .body)
        desc.adjustsFontForContentSizeCategory = true
        author.font = UIFont.preferredFont(forTextStyle: .caption1)
        author.adjustsFontForContentSizeCategory = true
        source.font = UIFont.preferredFont(forTextStyle: .caption1)
        source.adjustsFontForContentSizeCategory = true
    }
    
}
