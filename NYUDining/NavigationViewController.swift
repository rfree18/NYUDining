//
//  NavigationViewController.swift
//  NYUDining
//
//  Created by Ross Freeman on 7/9/16.
//  Copyright © 2016 Ross Freeman. All rights reserved.
//

import UIKit

class NavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.barTintColor = UIColor.navColor()
        navigationBar.translucent = false
        navigationBar.tintColor = UIColor.whiteColor()
        
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
