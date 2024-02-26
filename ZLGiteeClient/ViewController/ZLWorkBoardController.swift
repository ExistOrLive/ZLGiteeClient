//
//  ZLWorkBoardController.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2022/5/20.
//

import UIKit
import ZLBaseUI

class ZLWorkBoardController: ZLBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "工作台"
        
        let button = UIButton(type: .custom)
        contentView.addSubview(button)
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        button.addTarget(self, action: #selector(onButtonClicked), for: .touchUpInside)
    }
    
    
    @objc func onButtonClicked() {
        let vc = ZLRepoInfoController(repoFullName: "existorlive/GithubClient")
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
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
