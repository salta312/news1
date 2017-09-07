//
//  MyTableViewCell.swift
//  news
//
//  Created by Saltanat Aimakhanova on 9/5/17.
//  Copyright © 2017 saltaim. All rights reserved.
//

import UIKit
import Cartography
import KFSwiftImageLoader

class MyTableViewCell: UITableViewCell {
  //  var img: UIImageView!
//    var txt: String!
//    var imgURL:URL?
   // var article:Article?
    var label = UILabel()
    var img = UIImageView()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        // Initialization code
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
       // var img = UIImageView()
//        guard let art = article else{
//            return
//        }
//        if let url = art.urlToImage{
//            img.loadImage(url: URL(string: url)!, placeholderImage: UIImage(named:"defaultImg"), completion: nil)
//        }else{
//            img.image = UIImage(named:"defaultImg")
//        }
//        var label = UILabel()
        label.backgroundColor = UIColor.black
  //      label.text = art.title
        label.textColor = UIColor.white
        label.numberOfLines = 2;
        label.adjustsFontSizeToFitWidth = true
        self.contentView.addSubview(img)
        self.contentView.addSubview(label)
        constrain(self.contentView, img, label){
            contentView, img, label in
            img.top == contentView.top
            img.bottom == contentView.bottom
            img.right == contentView.right
            img.left == contentView.left
            label.bottom == contentView.bottom
            label.height == 50
            label.right == contentView.right
            label.left == contentView.left
        }
        
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
