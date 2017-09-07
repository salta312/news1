//
//  SourcesViewController.swift
//  news
//
//  Created by Saltanat Aimakhanova on 9/7/17.
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

class SourcesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   private var delegate: VCProtocol!
   private var tableView = UITableView();
   private var sources = [Source]()
    override func viewDidLoad() {
        super.viewDidLoad()
        sources = delegate.getArray()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.buildView()
        // Do any additional setup after loading the view.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return self.sources.count
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 30
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = sources[((indexPath as NSIndexPath).item)].name
        return cell
    }
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        self.dismiss(animated: true, completion: nil)
        delegate.callGetNews(id: sources[((indexPath as NSIndexPath).item)].id!)
        return indexPath
    }
    func setDelegate(del: VCProtocol){
        self.delegate = del
    }

    func buildView(){
        view.addSubview(tableView)
        constrain(view, tableView){
            view, tableView in
            tableView.top == view.top + 64
            tableView.bottom == view.bottom
            tableView.left == view.left
            tableView.right == view.right
        }
    }

}
