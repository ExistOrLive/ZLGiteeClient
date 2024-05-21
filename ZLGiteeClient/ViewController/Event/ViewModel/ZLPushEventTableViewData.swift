//
//  ZLPushEventTableViewData.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/5/21.
//

import ZLUIUtilities
import ZLBaseExtension
import HandyJSON
import ZLUtilities

class ZLPushEventTableViewCellData: ZLEventTableViewCellData {
    
    override init(model: ZLGiteeEventModel) {
        super.init(model: model)
        cellReuseIdentifier = "ZLPushEventTableViewCell"
    }
    
    lazy var pushPayload: ZLGiteePushEventPayloadModel? = {
        ZLGiteePushEventPayloadModel.deserialize(from: model.payload)
    }()
    
    private var _commitInfoAttributedStr: NSAttributedString?

    
    override func eventDescription() -> NSAttributedString {
        guard let pushPayload else {
            return super.eventDescription()
        }
        
        return NSASCContainer(
            "向 ",
            (pushPayload.ref ?? "")
                .asMutableAttributedString()
                .foregroundColor(.linkColor(withName: "ZLLinkLabelColor1")),
            " 分支推送了 \(pushPayload.size) 次提交\n\n",
            "在 ",
            (model.repo?.human_name ?? "")
                .asMutableAttributedString()
                .foregroundColor(.linkColor(withName: "ZLLinkLabelColor1"))
        ).foregroundColor(.label(withName: "ZLLabelColor3"))
         .font(.zlMediumFont(withSize: 15))
         .asMutableAttributedString()
    }
    
    func commitInfoAttributedStr() -> NSAttributedString {

        guard let pushPayload else { return NSAttributedString() }
        
        if let commitInfoAttributedStr = _commitInfoAttributedStr {
            return commitInfoAttributedStr
        }

        let str: NSMutableAttributedString  = NSMutableAttributedString()
        let paraghStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paraghStyle.lineSpacing = 5
        paraghStyle.lineBreakMode = .byClipping

        pushPayload.commits.enumerated().forEach({ (index, model) in
            if index > 3 { return }
            if index == 3 {
                let atr = "查看更多提交 >>"
                    .asMutableAttributedString()
                    .font(.zlRegularFont(withSize: 15))
                    .foregroundColor(.label(withName: "ZLLabelColor3"))
                str.append(atr)
            } else {
               let atr = NSASCContainer(
                String((model.sha ?? "").prefix(7))
                    .asMutableAttributedString()
                    .foregroundColor(.label(withName: "ZLLinkLabelColor2")),
                " ",
                model.message ?? "",
                "\n"
               ).font(.zlRegularFont(withSize: 14))
                .foregroundColor(.label(withName: "ZLLabelColor2"))
                .asAttributedString()
                str.append(atr)
            }
        })
        self._commitInfoAttributedStr = str.paraghStyle(paraghStyle)
        return str
    }
    
}

