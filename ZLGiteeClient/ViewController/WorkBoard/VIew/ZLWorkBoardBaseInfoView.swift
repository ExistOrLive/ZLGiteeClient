//
//  ZLWorkBoardBaseInfoView.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/3/25.
//

import Foundation
import UIKit

class ZLWorkBoardBaseInfoView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupUI() {
        backgroundColor = UIColor(named: "ZLCellBack")
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(loginLabel)
        
        imageView.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.top.equalTo(15)
            make.bottom.equalTo(-15)
            make.size.equalTo(80)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView)
            make.left.equalTo(imageView.snp.right).offset(10)
        }
        loginLabel.snp.makeConstraints { make in
            make.bottom.equalTo(imageView)
            make.left.equalTo(imageView.snp.right).offset(10)
        }
    }
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.cornerRadius = 40
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .zlMediumFont(withSize: 20)
        label.textColor = UIColor(named: "ZLLabelColor1")
        return label
    }()
    
    lazy var loginLabel: UILabel = {
        let label = UILabel()
        label.font = .zlRegularFont(withSize: 16)
        label.textColor = UIColor(named: "ZLLabelColor2")
        return label
    }()
}
