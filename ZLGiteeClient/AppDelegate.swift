//
//  AppDelegate.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2022/5/20.
//

import UIKit
import IQKeyboardManager
import ZLBaseUI
import ZLUIUtilities
import ZLBaseExtension
import ZLUtilities

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    @objc dynamic var window: UIWindow?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        initUI()
        
        registerNotification() 
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor(named: "ZLVCBackColor")
        self.window?.makeKeyAndVisible()
        
        if ZLGiteeOAuthUserServiceModel.sharedService.isLogined {
            self.window?.rootViewController = ZLMainViewController()
        } else {
            self.window?.rootViewController = ZLGiteeLoginController()
        }
         
        return true
    }
    
    func initUI() {
        
        IQKeyboardManager.shared().isEnabled = false
        
        ZLBaseUIConfig.sharedInstance().navigationBarTitleColor = UIColor.label(withName: "ZLNavigationBarTitleColor")
        ZLBaseUIConfig.sharedInstance().navigationBarBackgoundColor = UIColor.back(withName: "ZLNavigationBarBackColor")
        ZLBaseUIConfig.sharedInstance().viewControllerBackgoundColor = UIColor.back(withName: "ZLVCBackColor")
        ZLBaseUIConfig.sharedInstance().buttonTitleColor = UIColor.label(withName: "ZLBaseButtonTitleColor")
        ZLBaseUIConfig.sharedInstance().buttonBackColor = UIColor.back(withName: "ZLBaseButtonBackColor")
        ZLBaseUIConfig.sharedInstance().buttonBorderColor = UIColor.back(withName: "ZLBaseButtonBorderColor")
        ZLBaseUIConfig.sharedInstance().buttonCornerRadius = 4.0
        ZLBaseUIConfig.sharedInstance().buttonBorderWidth = 1.0 / UIScreen.main.scale
        
        ZLViewStatusPresenter.set {
            UIImage.iconFontImage(withText: ZLIconFont.NoData.rawValue, fontSize: 45, imageSize: CGSize(width: 60, height: 70), color: ZLRGBValue_H(colorValue: 0x999999)) ?? UIImage(color: UIColor.clear)
        }
    }
    
    func switchWithLoginStatus(animated: Bool) {
        guard let window = self.window else { return }
        let block = {
            if ZLGiteeOAuthUserServiceModel.sharedService.isLogined {
                window.rootViewController = ZLMainViewController()
            } else {
                window.rootViewController = ZLGiteeLoginController()
            }
        }
        if animated {
            UIView.transition(with: window,
                              duration: 0.5,
                              options: .transitionFlipFromLeft,
                              animations: block)
        } else {
            block()
        }
        
    }
}

// MARK: - Notifiction
extension AppDelegate {
    
    func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(onLoginStatusChanged), name:OAuthSuccessNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onLoginStatusChanged), name:AccessAndRefreshTokenInvalidNotification, object: nil)
    }
    
    
    @objc func onLoginStatusChanged() {
        switchWithLoginStatus(animated: true)
    }
}

