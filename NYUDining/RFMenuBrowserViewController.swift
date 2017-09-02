//
//  RFMenuBrowserViewController.swift
//  NYUDining
//
//  Created by Ross Freeman on 6/10/16.
//  Copyright © 2016 Ross Freeman. All rights reserved.
//

import UIKit
import MBProgressHUD

class RFMenuBrowserViewController: UIViewController, UIWebViewDelegate {
    
    var location: RFDiningLocation!
    var pageTimeout: Timer!
    var progressTime: Timer!

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Menu"
        
        loadWebPage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
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
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        pageTimeout.invalidate()
        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
    }
    
    @objc func showAlert() {
        webView.stopLoading()
        
        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
        
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
