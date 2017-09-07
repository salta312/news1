//
//  ArticleViewController.swift
//  news
//
//  Created by Saltanat Aimakhanova on 9/6/17.
//  Copyright © 2017 saltaim. All rights reserved.
//

import UIKit
import Cartography

class ArticleViewController: UIViewController {
    var img: UIImage!
    var article: Article!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self.draw()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func draw(){
        var imgView = UIImageView(image: img)
       // imgView.contentMode = .
        var label1: UILabel = {
            let label1 = UILabel()
            if article.author != "null" {
                label1.text = article.author
            }else{
                label1.text = "Author: unknown"
            }
            label1.numberOfLines = 1;
            label1.adjustsFontSizeToFitWidth = true
            return label1
        }()
        var label2: UILabel = {
            let label2 = UILabel()
            if article.publishedAt != "null"{
                label2.text = article.publishedAt
            }else{
                label2.text = "Published at: unknown"
            }
            label2.numberOfLines = 1;
            label2.adjustsFontSizeToFitWidth = true
            
            return label2
        }()
        var label3: UILabel = {
            let label3 = UILabel()
           // label3.text = article.title
            if article.title != "null" {
                label3.text = article.title
            }else{
                label3.text = "Title: unknown"
            }
            label3.numberOfLines = 3;
            label3.adjustsFontSizeToFitWidth = true
            
            return label3
        }()
        var label4: UILabel = {
            let label4 = UILabel()
            if article.description != "null"{
                label4.text = article.description
            }else{
                label4.text = "Description: unknown"
            }
            label4.numberOfLines = 6;
            label4.adjustsFontSizeToFitWidth = true

            return label4
        }()
        var label5: UILabel = {
            let label5 = UILabel()
           // label5.text =
            if article.url != "null"{
                label5.text = article.url
            }else{
                label5.text = "URL: unknown"
            }
            label5.numberOfLines = 1;
            label5.adjustsFontSizeToFitWidth = true

            return label5
        }()
        view.addSubview(imgView)
        view.addSubview(label1)
           view.addSubview(label2)
          view.addSubview(label3)
          view.addSubview(label4)
          view.addSubview(label5)
        constrain(view, imgView,label1, label2, label5){
            view, imgView,label1, label2, label5 in
            imgView.top == view.top+64
            imgView.height == view.height/3
            imgView.left == view.left
            imgView.right == view.right
            label1.top == imgView.bottom + 10
            label1.height == 20
            //label1.width == 100
            label1.left == view.left
            label1.right == view.right
            label2.top == label1.bottom + 10
            label2.left == view.left
            label2.height == 20
            label2.right == label2.right
           // label2.width == 100
            label5.top == label2.bottom + 10
            label5.left == view.left
            label5.height == 20
            label5.right == view.right
            
        }
        constrain(view, label3, label4, label5){
            view, label3, label4, label5 in
            label3.centerX == view.centerX
            label3.top == label5.bottom + 10
            label3.height == 20
            label3.left == view.left
            label3.right == view.right
            label4.left == view.left
            label4.right == view.right
            label4.top == label3.bottom + 10
            label4.height == 50
        }
        

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
