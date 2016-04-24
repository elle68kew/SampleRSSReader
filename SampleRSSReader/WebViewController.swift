//
//  WebViewController.swift
//  SampleRSSReader
//
//  Created by Tomo_N on 2016/04/24.
//  Copyright © 2016年 Tomo_N. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    var selectedItemUrl: NSURL?
    var wkWebView: WKWebView!
    
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var stopButton: UIBarButtonItem!
    @IBOutlet weak var reloadButton: UIBarButtonItem!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    
    // MARK: - IBActions
    @IBAction func stopButtonTapped(sender: AnyObject) {
        if wkWebView.loading {
            wkWebView.stopLoading()
            stopButton.enabled = false
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
    
    @IBAction func reloadButtonTapped(sender: AnyObject) {
        wkWebView.reload()
        stopButton.enabled = true
    }
    
    @IBAction func backButtonTapped(sender: AnyObject) {
        if backButton.enabled {
            wkWebView.goBack()
        }
    }
    
    
    @IBAction func forwardButtonTapped(sender: AnyObject) {
        if forwardButton.enabled {
            wkWebView.goForward()
        }
    }
    
    // MARK: - AppLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.p_setupWKWebView()
        self.view.addSubview(wkWebView)
        if let selectedItemUrl = selectedItemUrl {
            let request = NSURLRequest(URL: selectedItemUrl)
            self.wkWebView.loadRequest(request)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        wkWebView.stopLoading()
        if UIApplication.sharedApplication().networkActivityIndicatorVisible {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
    
    // MARK: - WKNavigationDelegate
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.p_updateButtonStatus()
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        self.p_updateButtonStatus()
    }
    
    // MARK: - PrivateMethod
    private func p_setupWKWebView() {
        let deviceBound: CGRect = UIScreen.mainScreen().bounds
        let heightNavigationBar = self.navigationController?.navigationBar.frame.size.height
        let heightStatusBar = UIApplication.sharedApplication().statusBarFrame.height
        if let heightNavigationBar = heightNavigationBar {
            self.wkWebView = WKWebView(frame: CGRect(
                x: 0,
                y: heightNavigationBar + heightStatusBar,
                width: deviceBound.size.width,
                height: deviceBound.size.height - (self.toolBar.frame.size.height + heightStatusBar + heightNavigationBar)))
        }
        self.wkWebView.navigationDelegate = self
    }
    
    private func p_updateButtonStatus() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = wkWebView.loading
        backButton.enabled      = wkWebView.canGoBack
        forwardButton.enabled   = wkWebView.canGoForward
        stopButton.enabled      = wkWebView.loading
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
