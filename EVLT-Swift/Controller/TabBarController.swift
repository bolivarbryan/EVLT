//
//  TabBarController.swift
//  EVLT-Swift
//
//  Created by Bryan on 10/02/17.
//  Copyright © 2017 Wiredelta. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.tabBarItem.image = UIImage(named: "briefcase")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBar(_ tabBar: UITabBar, willBeginCustomizing items: [UITabBarItem]) {
        items[1].image = UIImage(named: "briefcase")
    }
    

}
