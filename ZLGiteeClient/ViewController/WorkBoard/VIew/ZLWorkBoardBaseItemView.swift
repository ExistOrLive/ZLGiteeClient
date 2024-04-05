//
//  ZLWorkBoardBaseItemView.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/3/25.
//

import Foundation
import UIKit
import ZLUIUtilities
import ZLUtilities

class ZLWorkBoardBaseItemView: UIView {
    
    var clickBlock: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        backgroundColor = .back(withName: "ZLCellBack")
        addSubview(avatarImageView)
        addSubview(titleLabel)
        addSubview(arrowImageView)
        addSubview(singleLineView)
        addSubview(button)
        
        avatarImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).offset(15)
            make.centerY.equalToSuperview()
        }
        
        singleLineView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.bottom.right.equalToSuperview()
            make.height.equalTo( 1.0 / UIScreen.main.scale )
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
            make.size.equalTo(CGSize(width: 15, height: 15))
            make.left.equalTo(titleLabel.snp.right).offset(10)
        }
        
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.circle = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .zlSemiBoldFont(withSize: 14)
        label.textColor = .label(withName: "ZLLabelColor1")
        label.textAlignment = .left
        return label
    }()
    
    lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.iconFontImage(withText: ZLIconFont.NextArrow.rawValue,
                                                fontSize: 12,
                                                color: UIColor.iconColor(withName: "ICON_Common"))
        return imageView
    }()
    
    lazy var singleLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .back(withName: "ZLSeperatorLineColor")
        return view
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(onItemViewClicked), for: .touchUpInside)
        return button
    }()
    
    @objc func onItemViewClicked() {
        clickBlock?()
    }
}
