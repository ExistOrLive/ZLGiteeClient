//
//  ZLMainViewController.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2022/5/20.
//

import UIKit
import ZLBaseExtension
import ZLUIUtilities
 

class ZLMainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAllChildViewController()
        setupTabBarItems()
    }
    
    func setupAllChildViewController() {
        self.addChild(ZMNavigationController(rootViewController: ZLWorkBoardController()))
        self.addChild(ZMNavigationController(rootViewController: ZLNotificationsController()))
        self.addChild(ZMNavigationController(rootViewController: ZLExploreController()))
        self.addChild(ZMNavigationController(rootViewController: ZLProfileController()))
    }
    
    func setupTabBarItems() {
        for (index,childController) in children.enumerated() {
           
            switch index {
            case 0:
                childController.tabBarItem.title = "工作台"
                childController.tabBarItem.image = UIImage(named: "tabBar_new_icon")
                childController.tabBarItem.selectedImage = UIImage(named: "tabBar_new_click_icon")
            case 1:
                childController.tabBarItem.title = "通知"
                childController.tabBarItem.image = UIImage(named: "tabBar_Notification")
                childController.tabBarItem.selectedImage = UIImage(named: "tabBar_Notification_click")
            case 2:
                childController.tabBarItem.title = "探索"
                childController.tabBarItem.image = UIImage(named: "tabBar_friendTrends_icon")
                childController.tabBarItem.selectedImage = UIImage(named: "tabBar_friendTrends_click_icon")
            case 3:
                childController.tabBarItem.title = "我"
                childController.tabBarItem.image = UIImage(named: "tabBar_essence_icon")
                childController.tabBarItem.selectedImage = UIImage(named: "tabBar_essence_click_icon")
            default:
                break
                
            }
        }
        
        UITabBar.appearance().isTranslucent = false
        tabBar.tintColor = UIColor(named: "ZLTabBarTintColor")
        let backImage = UIImage(color: UIColor.back(withName: "ZLTabBarBackColor"))
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.backgroundImage = backImage
            appearance.shadowImage = backImage
            tabBar.scrollEdgeAppearance = appearance
        } else {
            tabBar.backgroundImage = backImage
            tabBar.shadowImage = backImage
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
