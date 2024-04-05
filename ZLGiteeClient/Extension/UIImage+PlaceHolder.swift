//
//  UIImage+PlaceHolder.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/3/28.
//

import Foundation
import CoreGraphics
import UIKit
import ZLUIUtilities


extension UIImage {
    
    static func placeHolderImage(placeHolder: String = "") -> UIImage {
        let render =  UIGraphicsImageRenderer(size: CGSize(width: 50, height: 50))
        return  render.image { context in
            let path = UIBezierPath(arcCenter: CGPoint(x: 25, y: 25), radius: 25, startAngle: 0, endAngle:  2 * Double.pi, clockwise: true)
            UIColor(hexString: "#95A6A6")?.setFill()
            path.fill()
            
            let attributedStr = placeHolder.asMutableAttributedString().foregroundColor(.white).font(.zlMediumFont(withSize: 15))
            let size = attributedStr.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude,
                                                               height: CGFloat.greatestFiniteMagnitude),
                                                  options: .usesLineFragmentOrigin,
                                                  context: nil).size
            attributedStr.draw(in: CGRect(x:(50 - size.width)/2.0, y: (50 - size.height)/2.0,
                                          width: size.width, height: size.height))
        }
    }

}
