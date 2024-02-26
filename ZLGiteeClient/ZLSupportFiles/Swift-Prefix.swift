//
//  Swift-Prefix.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/2/26.
//

import Foundation
import UIKit

// MARK: 界面常用参数

var ZLStatusBarHeight : CGFloat {
    UIApplication.shared.statusBarFrame.size.height
}

var ZLKeyWindowHeight : CGFloat {
    if let window = UIApplication.shared.delegate?.window {
        return window?.frame.size.height ?? 0
    }
    return 0
}

var ZLKeyWindowWidth : CGFloat {
    if let window = UIApplication.shared.delegate?.window {
        return window?.frame.size.width ?? 0
    }
    return 0
}

var ZLSCreenHeight : CGFloat {
    UIScreen.main.bounds.size.height
}
var ZLScreenWidth : CGFloat {
    UIScreen.main.bounds.size.width;
}
var ZLScreenBounds : CGRect {
    UIScreen.main.bounds
}

var ZLMainWindow: UIWindow? {
    return UIApplication.shared.delegate?.window ?? UIWindow()
}

var ZLSafeAreaBottomHeight: CGFloat {
    if let window = UIApplication.shared.delegate?.window {
        return window?.safeAreaInsets.bottom ?? 0
    }
    return 0
}

var ZLSafeAreaTopHeight: CGFloat {
    if let window = UIApplication.shared.delegate?.window {
        return window?.safeAreaInsets.top ?? 0
    }
    return 0
}

var ZLSeperateLineHeight: CGFloat = 1.0 / UIScreen.main.scale
