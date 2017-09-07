//
//  ViewController.swift
//  news
//
//  Created by Saltanat Aimakhanova on 9/4/17.
//  Copyright © 2017 saltaim. All rights reserved.
//

import UIKit
import Alamofire
import Cartography
import SwiftyJSON
import KFSwiftImageLoader
//import Haneke
import CoreData
//import RSLoadingView
import SwiftSpinner
import SideMenu
protocol VCProtocol{
    func getNewsForId(id: String!)
    func showAlert()
    func getArray()->[Source]
    func callGetNews(id: String!)
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, VCProtocol {


    private var tableView: UITableView = UITableView()
    private var articles = [Article]()
    private var sources = [Source]()
    private var sourceNum = 0;
    private var imageCache = NSCache<NSString, UIImage>()
    private let refreshControl = UIRefreshControl()
    private let svc = SourcesViewController()


    override func viewDidLoad() {
        super.viewDidLoad()
        if (self.entityIsEmpty(entity: "Source")){
            self.loadSources()
        }else{
            readFromCoreData()
        }
        self.buildView()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MyTableViewCell.self, forCellReuseIdentifier: "cell")
   
    }

    func getArray() -> [Source] {
        return sources
    }
    func switchToAllNews(){
        tableView.reloadData()
    }
    func showAlert(){
        let alert = UIAlertController(title: "Alert", message: "test", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func swipe(){
        sourceNum = 0
        articles = []
        self.getNewsForId(id: sources[sourceNum].id!)
        refreshControl.endRefreshing()

    }
    private var shown = true;
    func addTapped(){
        if(shown){
            present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
            shown = true;

        }else{
            dismiss(animated: true, completion: nil)
            shown = false;

        }

    }
    func callGetNews(id: String!){
        articles = []
        getNewsForId(id: id)
    }
    func getNewsForId(id: String!){
        Alamofire.request("https://newsapi.org/v1/articles?source=\(id!)&apiKey=f70c88f0960d4b11bf656d9f36fd5333").responseJSON { response in
            SwiftSpinner.show("Connecting")
            let json = JSON(data: response.data!)
            
            for i in 0...json["articles"].count{
                if json["articles"][i] != JSON.null{
                    let a = Article()
                    a.description = String(describing: json["articles"][i]["description"])
                    a.publishedAt = String(describing:json["artciles"][i]["publishedAt"])
                    a.author = String(describing:json["artciles"][i]["author"])
                    a.title = String(describing: json["articles"][i]["title"])
                    a.url = String(describing:json["articles"][i]["url"])
                    a.urlToImage = String(describing:json["articles"][i]["urlToImage"])
                    self.articles.append(a)
                }
                
            }
            SwiftSpinner.hide()
            self.tableView.reloadData()
        }

    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        print(self.articles.count)
        
        return self.articles.count
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 200
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {

      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyTableViewCell
        if(articles.count <= indexPath.item){
            return cell
        }
        if(articles.count - 1 == (indexPath as NSIndexPath).item){
            self.sourceNum += 1
            self.getNewsForId(id: sources[self.sourceNum].id!)
        }
        cell.label.text = articles[(indexPath as NSIndexPath).item].title
        if let imgC = imageCache.object(forKey: NSString(string: articles[(indexPath as NSIndexPath).item].urlToImage!)){
            cell.img.image = imgC
        }else{
        URLSession.shared.dataTask(with: URL(string:articles[(indexPath as NSIndexPath).item].urlToImage!)!) { (data, response, error) in
            if error != nil{
                print (error)
                return
            }
            
            DispatchQueue.main.async() {
                cell.img.image = UIImage(data: data!)
                self.imageCache.setObject(UIImage(data: data!)!, forKey: NSString(string:self.articles[(indexPath as NSIndexPath).item].urlToImage!))
            }
        }.resume()
        }
        return cell
    }
    func loadImage(url: URL){

    }
    func loadMore(){
        
    }
    func loadSources(){
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
            var source: Source!
        
            Alamofire.request("https://newsapi.org/v1/sources?language=en").responseJSON { response in
                let json = JSON(data: response.data!)
                for i in 0...json["sources"].count{
                    if( json["sources"][i] != nil){
                        source = NSEntityDescription.insertNewObject(forEntityName: "Source", into: context) as! Source
                        source.id = String(describing:json["sources"][i]["id"])
                        source.name = String(describing:json["sources"][i]["name"])
                        source.url = String(describing:json["sources"][i]["url"])
                        source.num = i as! NSDecimalNumber
                        do{
                            try context.save()
                        }catch let err{
                            print(err)
                        }
                    }
                    
                    
                }
            self.readFromCoreData()
        }
        
    }
    func readFromCoreData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Source")
        do{
            sources = try context.fetch(request) as! [Source]
            self.getNewsForId(id: sources[0].id!)
        }catch let err{
            print(err)
        }
    }
    func entityIsEmpty(entity: String) -> Bool
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        do {
            let count = try context.count(for: request)
            if count == 0{
                return true
            }else{
                return false;
            }
            
        } catch {
            print("Error info: \(error)")
            
        }
    //    loadingView.hide()
        return false
        
    }
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let art1 = self.articles[(indexPath as NSIndexPath).item]
        let vc = ArticleViewController()
        vc.article = art1
        if let imgC = imageCache.object(forKey: NSString(string: articles[(indexPath as NSIndexPath).item].urlToImage!)){
            vc.img = imgC
        }else{
            URLSession.shared.dataTask(with: URL(string:articles[(indexPath as NSIndexPath).item].urlToImage!)!) { (data, response, error) in
                if error != nil{
                    print (error)
                    return
                }
                
                DispatchQueue.main.async() {
                    vc.img = UIImage(data: data!)
                    self.imageCache.setObject(UIImage(data: data!)!, forKey: NSString(string:self.articles[(indexPath as NSIndexPath).item].urlToImage!))
                }
                }.resume()
        }
        //vc.challange = ch
        self.navigationController?.pushViewController(vc, animated: true)
        return indexPath
    }
    func buildView(){
        svc.setDelegate(del: self)
        let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: svc)
        menuLeftNavigationController.leftSide = true
        SideMenuManager.menuLeftNavigationController = menuLeftNavigationController
        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        let button = UIBarButtonItem(image: UIImage(named:"menu"), style: .plain, target: self, action: #selector(addTapped))
        let allNews = UIBarButtonItem(title: "All", style: .plain, target: self, action: #selector(switchToAllNews))
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipe))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        self.navigationItem.leftBarButtonItem = button
        self.navigationItem.rightBarButtonItem = allNews
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(swipe), for: .valueChanged)
        self.view.backgroundColor = UIColor.blue
        self.view.addSubview(tableView)
        constrain(view, tableView){
            view, tableView in
            tableView.top == view.top ;
            tableView.bottom == view.bottom;
            tableView.left == view.left
            tableView.right == view.right
        }
    }

    


}

