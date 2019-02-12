//
//  CustomTabBarViewController.swift
//  Baluchon
//
//  Created by Jerome Krakus on 12/02/2019.
//  Copyright © 2019 Jerome Krakus. All rights reserved.
//

import UIKit

class CustomTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the tab bar style
        UITabBar.appearance().barTintColor = #colorLiteral(red: 0.09803921569, green: 0.5137254902, blue: 1, alpha: 1)
        UITabBar.appearance().tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        UITabBar.appearance().unselectedItemTintColor = #colorLiteral(red: 0.5019607843, green: 0.7333333333, blue: 1, alpha: 1)
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
    }
}
