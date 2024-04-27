//
//  a.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/4/11.
//

import Foundation

public func ZLMainThreadDispatch(_ block : @escaping ()->Void) {
    if Thread.isMainThread {
        block()
    } else {
        DispatchQueue.main.async(execute: block)
    }
}
