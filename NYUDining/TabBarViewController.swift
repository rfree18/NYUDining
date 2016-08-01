//
//  TabBarViewController.swift
//  NYUDining
//
//  Created by Ross Freeman on 7/9/16.
//  Copyright © 2016 Ross Freeman. All rights reserved.
//

import UIKit

enum Tab: Int {
    case Locations, Profile, Requests, Messages
}

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.barTintColor = UIColor.tabColor()
        tabBar.translucent = false

        delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let locationsController = RFLocationsViewController()
        let locationsNav = NavigationViewController(rootViewController: locationsController)
        
        let profileController = ProfileViewController()
        let profileNav = NavigationViewController(rootViewController: profileController)
        
        let requestsController = RequestsViewController()
        let requestsNav = NavigationViewController(rootViewController: requestsController)
        
        let messageController = MessageViewController()
        let messageNav = NavigationViewController(rootViewController: messageController)
        
        locationsNav.tabBarItem = UITabBarItem(title: "Locations", image: UIImage(named: "homeButton22"), selectedImage: UIImage(named: "homeButton_selected"))
        profileNav.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "profileButton_22"), selectedImage: UIImage(named: "profileButton_selected"))
        requestsNav.tabBarItem = UITabBarItem(title: "Requests", image: UIImage(named: "requestButton_22"), selectedImage: UIImage(named: "requestButton_selected"))
        messageNav.tabBarItem = UITabBarItem(title: "Messages", image: UIImage(named: "messageButton2_22"), selectedImage: UIImage(named: "messageButton_selected"))
        
        let controllers = [locationsNav, profileNav, requestsNav, messageNav]
        viewControllers = controllers
    }
    
    func setTab(tab: Tab) {
        selectedIndex = tab.rawValue
    }

}
