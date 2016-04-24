//
//  MidashiViewController.swift
//  SampleRSSReader
//
//  Created by Tomo_N on 2016/04/24.
//  Copyright © 2016年 Tomo_N. All rights reserved.
//

import UIKit
import MWFeedParser
import SVProgressHUD

class MidashiViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MWFeedParserDelegate {

    @IBOutlet weak var midashiTable: UITableView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var feedUrl = ""
    var parser: MWFeedParser!
    var feedItems = [MWFeedItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = NSURL(string: feedUrl)
        parser = MWFeedParser(feedURL: url)
        parser.delegate = self
        
        let q_global: dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        let q_main: dispatch_queue_t = dispatch_get_main_queue()
        
        SVProgressHUD.show()
        dispatch_async(q_global) { () -> Void in
            self.parser.parse()
            
            dispatch_async(q_main, { () -> Void in
                if SVProgressHUD.isVisible() {
                    SVProgressHUD.dismiss()
                }
                self.midashiTable.reloadData()
            })
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
        return feedItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "Cell")
        let midashiTitle = feedItems[indexPath.row].title
        cell.textLabel?.text = midashiTitle
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.midashiTable.deselectRowAtIndexPath(indexPath, animated: true)
        let selectedUrlString = feedItems[indexPath.row].link
        let selectedUrl = NSURL(string: selectedUrlString)
        let webVC = WebViewController(nibName: "WebViewController", bundle: nil)
        webVC.selectedItemUrl = selectedUrl
        self.navigationController?.pushViewController(webVC, animated: true)
    }
    
    
    // MARK: - MWFeedParserDelegate
    func feedParserDidStart(parser: MWFeedParser!) {
        print("パース開始")
    }
    
    func feedParserDidFinish(parser: MWFeedParser!) {
        print("パース終了")
    }
    
    func feedParser(parser: MWFeedParser!, didParseFeedItem item: MWFeedItem!) {
        feedItems.append(item)
    }

    func feedParser(parser: MWFeedParser!, didParseFeedInfo info: MWFeedInfo!) {
        self.title = info.title
    }
}
