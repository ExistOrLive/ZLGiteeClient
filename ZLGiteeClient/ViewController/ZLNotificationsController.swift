//
//  ZLNotificationsController.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2022/5/20.
//

import UIKit
import Moya
import ZLBaseUI

class ZLNotificationsController: ZLBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let provider = MoyaProvider<ZLGiteeRequest>()
        provider.request(ZLGiteeRequest.user(login: "existorlive")) { result in
            switch result {
            case .success(let response):
                let data = response.data
                let dataStr = String(data: data, encoding:.utf8)
                let model = ZLGiteeUserModel.deserialize(from: dataStr, designatedPath: nil)
                print(model)
            case .failure(let error):
                print(error)
            }
        
        }
        
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
