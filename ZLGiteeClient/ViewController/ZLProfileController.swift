//
//  ZLProfileController.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2022/5/20.
//

import UIKit
import ZLBaseUI

class ZLProfileController: ZLBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我"

        // MARK: view
        lazy var profileHeaderView: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor.lightGray
            view.cornerRadius = 10
            return view
        }()
        
        contentView.addSubview(profileHeaderView)
        
        profileHeaderView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(60)
        }
        
        let followerButton = UIButton(type: .custom)
        followerButton.setTitle("粉丝", for: .normal)
        profileHeaderView.addSubview(followerButton)
        
        followerButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 50, height: 60))
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
        }
        followerButton.addTarget(self, action: #selector(followerButtonClicked), for: .touchUpInside)
        
        let repoListButton = UIButton(type: .custom)
        repoListButton.setTitle("仓库", for: .normal)
        profileHeaderView.addSubview(repoListButton)
        
        repoListButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.size.equalTo(CGSize(width: 50, height: 60))
            make.left.equalTo(followerButton.snp.left).offset(60)
        }
        repoListButton.addTarget(self, action: #selector(repoListButtonClicked), for: .touchUpInside)
        
        let followingButton = UIButton(type: .custom)
        followingButton.setTitle("关注", for: .normal)
        profileHeaderView.addSubview(followingButton)
        
        followingButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.size.equalTo(CGSize(width: 50, height: 60))
            make.left.equalTo(repoListButton.snp.left).offset(60)
        }
        followingButton.addTarget(self, action: #selector(followingButtonClicked), for: .touchUpInside)
        
//        func addComponseButtons() {
//            let buttonStackView = UIStackView(arrangedSubviews: [followerButton, repoListButton, followingButton])
//            buttonStackView.translatesAutoresizingMaskIntoConstraints = false
//            buttonStackView.distribution = .fillEqually
//            contentView.addSubview(buttonStackView)
//
//            NSLayoutConstraint.activate([
//                buttonStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
//                buttonStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
//                buttonStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//                buttonStackView.heightAnchor.constraint(equalToConstant: 50)
//            ])
//
//            buttonStackView.snp.makeConstraints { make in
//                make.left.equalTo(contentView.snp.left)
//                make.right.equalTo(contentView.snp.right)
//                make.bottom.equalTo(contentView.snp.bottom)
//                make.height.equalTo(50)
//            }
//        }
        
    }
    
    @objc func followerButtonClicked() {
        let vc = ZLUserFollowerListController()
        vc.login = "ZXHubs"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func repoListButtonClicked() {
        let vc = ZLUserReposListController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func followingButtonClicked() {
        let vc = ZLUserFollowingListController()
        vc.login = "ZXHubs"
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
