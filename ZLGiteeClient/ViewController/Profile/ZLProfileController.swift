//
//  ZLProfileController.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2022/5/20.
//

import UIKit
import ZLUIUtilities

class ZLProfileController: ZMViewController {

    // MARK: View
    override func setupUI() {
        super.setupUI()
        title = "我"
        contentView.addSubview(buttonStackView)
        
        buttonStackView.addArrangedSubview(starButton)
        buttonStackView.addArrangedSubview(followerButton)
        buttonStackView.addArrangedSubview(followingButton)
        buttonStackView.addArrangedSubview(repoListButton)
        
        buttonStackView.snp.makeConstraints { make in
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.height.equalTo(50)
        }
    }
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = UIColor.lightGray
        stackView.cornerRadius = 10
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 35
        return stackView
    }()
    
    private lazy var starButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("标星", for: .normal)
        button.addTarget(self, action: #selector(starButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private lazy var followerButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("粉丝", for: .normal)
        button.addTarget(self, action: #selector(followerButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private lazy var followingButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("关注", for: .normal)
        button.addTarget(self, action: #selector(followingButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private lazy var repoListButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("登出", for: .normal)
        button.addTarget(self, action: #selector(repoListButtonClicked), for: .touchUpInside)
        return button
    }()
    
    @objc func starButtonClicked() {
        let vc = ZLUserStarsListController()
        vc.login = "ZXHubs"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func followerButtonClicked() {
        let vc = ZLUserFollowerListController()
        vc.login = "ZXHubs"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func repoListButtonClicked() {

    }
    
    @objc func followingButtonClicked() {
        let vc = ZLUserFollowingListController()
        vc.login = "ZXHubs"
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
