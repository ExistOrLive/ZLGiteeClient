//
//  AppDelegate.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2022/5/20.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    @objc dynamic var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor(named: "ZLVCBackColor")
        self.window?.makeKeyAndVisible()
        self.window?.rootViewController = ZLMainViewController()
        
        return true
    }
}

