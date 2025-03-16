//
//  ZLNotificationsController.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2022/5/20.
//

import UIKit
import Moya
import ZLUIUtilities

class ZLNotificationsController: ZMTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.addSubview(button)
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    

    lazy var button: UIButton = {
       let button = UIButton()
        button.addTarget(self, action: #selector(logout), for: .touchUpInside)
        return button
    }()
    
    @objc func logout() {
        ZLGiteeOAuthUserServiceModel.sharedService.logout()
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
