//
//  RFMenuBrowserViewController.swift
//  NYUDining
//
//  Created by Ross Freeman on 6/10/16.
//  Copyright © 2016 Ross Freeman. All rights reserved.
//

import UIKit

class RFMenuBrowserViewController: UIViewController, UIWebViewDelegate {
    
    var location: RFDiningLocation!
    var pageTimeout: Timer!
    var progressTime: Timer!
    var didLoad = false
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Menu"
        
        loadWebPage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadWebPage() {
        let url = URL(string: location.menuURL!)
        let urlRequest = URLRequest(url: url!)
        
        webView.loadRequest(urlRequest)
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        pageTimeout = Timer(timeInterval: 12.0, target: self, selector: #selector(showAlert), userInfo: nil, repeats: false)
        
        progressView.progress = 0
        didLoad = false
        progressTime = Timer(timeInterval: 0.01667, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        didLoad = true
        pageTimeout.invalidate()
    }
    
    func timerCallback() {
        if didLoad {
            if progressView.progress >= 1 {
                progressView.isHidden = true
                progressTime.invalidate()
            }
            
            else {
                progressView.progress += 0.1
            }
        }
        
        else {
            progressView.progress += 0.05
            if progressView.progress >= 0.95 {
                progressView.progress = 0.95
            }
        }
    }
    
    func showAlert() {
        webView.stopLoading()
        
        let alert = UIAlertController(title: "Connection Error", message: "It looks like you're not connected to the internet 😢", preferredStyle: UIAlertControllerStyle.alert)
        let retry = UIAlertAction(title: "Retry", style: UIAlertActionStyle.default) { (action) in
            self.loadWebPage()
        }
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (action) in
            if let navigationController = self.navigationController {
                navigationController.popViewController(animated: true)
            }
        }
        
        alert.addAction(retry)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }

}
