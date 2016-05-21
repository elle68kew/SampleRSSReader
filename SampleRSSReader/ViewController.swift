//
//  ViewController.swift
//  SampleRSSReader
//
//  Created by Tomo_N on 2016/04/24.
//  Copyright © 2016年 Tomo_N. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var myTable: UITableView!
    var feedListArray =  [[String : String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // test
        // test
        self.title = "RSS一覧"
        
        let filePath = NSBundle.mainBundle().pathForResource("feedlist.plist", ofType: nil)
        
        if let filePath = filePath {
            feedListArray = NSArray(contentsOfFile: filePath) as! [[String: String]]
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    // MARK: - TableViewDelegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedListArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "Cell")
        let feedTitle = feedListArray[indexPath.row]["title"]
        cell.textLabel?.text = feedTitle
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        myTable.deselectRowAtIndexPath(indexPath, animated: true)
        let midashiVC = MidashiViewController(nibName:"MidashiViewController", bundle: nil)
        let selectedFeedUrl = feedListArray[indexPath.row]["url"]!
        midashiVC.feedUrl = selectedFeedUrl
        self.navigationController?.pushViewController(midashiVC, animated: true)
    }
}