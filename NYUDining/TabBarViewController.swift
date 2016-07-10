//
//  TabBarViewController.swift
//  NYUDining
//
//  Created by Ross Freeman on 7/9/16.
//  Copyright © 2016 Ross Freeman. All rights reserved.
//

import UIKit

enum Tab: Int {
    case Locations, Profile, Requests
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
        
        locationsNav.tabBarItem = UITabBarItem(title: "Locations", image: nil, selectedImage: nil)
        profileNav.tabBarItem = UITabBarItem(title: "Profile", image: nil, selectedImage: nil)
        requestsNav.tabBarItem = UITabBarItem(title: "Requests", image: nil, selectedImage: nil)
        
        let controllers = [locationsNav, profileNav, requestsNav]
        viewControllers = controllers
    }
    
    func setTab(tab: Tab) {
        selectedIndex = tab.rawValue
    }

}
