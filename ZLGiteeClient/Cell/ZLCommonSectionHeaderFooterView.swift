//
//  ZLCommonSectionHeaderFooterView.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2022/5/29.
//

import Foundation
import UIKit
import ZLUIUtilities


class ZLCommonSectionHeaderFooterViewData: ZLTableViewBaseSectionViewData,ZLCommonSectionHeaderViewDelegate {
    
    var backgroundColor: UIColor = .clear
    
    var title: String = ""
    
    var titleColor: UIColor = .clear
    
    var titleFont: UIFont = .systemFont(ofSize: 15)
    
    var titleEdge: UIEdgeInsets = .zero
    
    init(title: String = "",
         titleColor: UIColor = .clear,
         titleFont: UIFont = .systemFont(ofSize: 15),
         titleEdge: UIEdgeInsets = .zero,
         backgroundColor: UIColor = .clear,
         sectionViewHeight: CGFloat = UITableView.automaticDimension) {
        self.backgroundColor = backgroundColor
        self.title = title
        self.titleColor = titleColor
        self.titleFont = titleFont
        self.titleEdge = titleEdge
        super.init()
        self.sectionViewReuseIdentifier = ZLCommonSectionHeaderFooterView.reuseIdentifier
        self.sectionViewHeight = sectionViewHeight
    }
}

protocol ZLCommonSectionHeaderViewDelegate {
    
    var backgroundColor: UIColor { get }
    
    var title: String { get }
    
    var titleColor: UIColor { get }
    
    var titleFont: UIFont { get }
    
    var titleEdge: UIEdgeInsets { get }
}

class ZLCommonSectionHeaderFooterView: UITableViewHeaderFooterView {
    
    static let reuseIdentifier: String = "ZLCommonSectionHeaderFooterView"
    
    lazy var titleLabel: UILabel = {
       let label = UILabel()
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
}
extension ZLCommonSectionHeaderFooterView: ZLViewUpdatableWithViewData {
    
    func fillWithViewData(viewData data: ZLCommonSectionHeaderViewDelegate) {
        contentView.backgroundColor = data.backgroundColor
        titleLabel.text = data.title
        titleLabel.font = data.titleFont
        titleLabel.textColor = data.titleColor
        titleLabel.snp.updateConstraints { make in
            make.edges.equalTo(data.titleEdge)
        }
    }
    
    func justUpdateView() {
        
    }
}


