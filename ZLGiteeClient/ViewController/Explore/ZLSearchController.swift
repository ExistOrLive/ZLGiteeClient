//
//  ZLSearchController.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/2/26.
//

import UIKit
import ZLUtilities
import JXSegmentedView
import ZLUIUtilities
import ZMMVVM

enum SearchType: CaseIterable {
    case repo
    case user
    case issue
    
    var title: String {
        switch self {
        case .repo:
            return "仓库"
        case .user:
            return "用户"
        case .issue:
            return "issues"
        }
    }
}

class ZLSearchController: ZMViewController {
    
    lazy var searchTypes: [SearchType] = SearchType.allCases
    
    var preSearchKeyWord: String = ""
    
    lazy var vcDic: [SearchType: ZLSearchChildListController] = {
        var vcDic : [SearchType: ZLSearchChildListController] = [:]
        searchTypes.forEach {
            vcDic[$0] = ZLSearchChildListController(type: $0)
        }
        return vcDic
    }()


    // MARK: Lazy View
    override func setupUI() {
        super.setupUI()
        view.addSubview(topBackView)
        view.addSubview(segmentedView)
        view.addSubview(segmentedListContainerView)
                
        topBackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(60)
        }
        
        segmentedView.snp.makeConstraints { make in
            make.top.equalTo(topBackView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        
        segmentedListContainerView.snp.makeConstraints { make in
            make.top.equalTo(segmentedView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    func setEditStatus() {
        backButton.snp.updateConstraints { make in
            make.width.equalTo(0.0)
        }
        cancelButton.snp.updateConstraints { make in
            make.width.equalTo(60.0)
        }
    }
    
    func setUnEditStatus() {
        backButton.snp.updateConstraints { make in
            make.width.equalTo(30.0)
        }
        cancelButton.snp.updateConstraints { make in
            make.width.equalTo(0.0)
        }
    }
        
    // MARK: Lazy View
    lazy var topBackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named:"ZLCellBack")
        view.addSubview(topNavigationView)
        topNavigationView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(60)
        }
        return view
    }()
    
    lazy var topNavigationView: UIView = {
        let view = UIView()
        view.addSubview(backButton)
        view.addSubview(searchTextField)
        view.addSubview(cancelButton)
        view.backgroundColor = UIColor(named:"ZLCellBack")
        backButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(30)
            make.left.equalTo(10)
        }
        cancelButton.snp.makeConstraints { make in
            make.right.top.bottom.equalToSuperview()
            make.width.equalTo(0)
            make.right.equalTo(-10)
        }
        searchTextField.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.centerY.equalToSuperview()
            make.left.equalTo(backButton.snp.right).offset(10)
            make.right.equalTo(cancelButton.snp.left).offset(-10)
        }
        return view
    }()
    
    lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.font = .zlRegularFont(withSize: 14)
        textField.textColor = UIColor(named:"ZLLabelColor1")
        textField.backgroundColor = UIColor(named:"ZLExploreTextFieldBackColor")
        textField.borderStyle = .none
        textField.placeholder = "搜索"
        let leftView = UIView.init(frame: CGRect(x: 0, y: 0, width: 20, height: 40))
        leftView.backgroundColor = UIColor.clear
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.cornerRadius = 4.0
        textField.delegate = self
        return textField
    }()
    
    lazy var backButton: UIButton = {
       let button = UIButton()
        button.setTitle(ZLIconFont.BackArrow.rawValue, for: .normal)
        button.setTitleColor(UIColor.label(withName: "ZLLabelColor1"), for: .normal)
        button.titleLabel?.font = .iconFont(size: 24)
        button.addTarget(self, action: #selector(onBackButtonClicked(_ :)), for: .touchUpInside)
        return button
    }()
    
    lazy var cancelButton: UIButton = {
       let button = UIButton()
        button.setTitleColor(UIColor.label(withName: "ZLLabelColor1"), for: .normal)
        button.titleLabel?.font = .zlMediumFont(withSize: 14)
        button.setTitle("取消", for: .normal)
        button.addTarget(self, action: #selector(onCancelButtonClicked), for: .touchUpInside)
        return button
    }()
    
    lazy var segmentedListContainerView: JXSegmentedListContainerView = {
        JXSegmentedListContainerView(dataSource: self, type: .scrollView)
    }()
    

    lazy var segmentedView: JXSegmentedView = {
        let segmentedView = JXSegmentedView()
        //segmentedView.delegate = self
        segmentedView.dataSource = segmentedViewDatasource
        segmentedView.indicators = [indicator]
        segmentedView.listContainer = segmentedListContainerView
        return segmentedView
    }()
    
    lazy var indicator: JXSegmentedIndicatorLineView = {
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorColor =  UIColor.init(named: "ZLExploreUnderlineColor") ?? UIColor.black
        indicator.indicatorHeight = 1.0
        return indicator
    }()

    lazy var segmentedViewDatasource: JXSegmentedTitleDataSource = {
        let datasource = JXSegmentedTitleDataSource()
        datasource.titles = searchTypes.map({ $0.title })
        datasource.itemWidthIncrement = 10
        datasource.titleNormalColor = .label(withName: "ZLLabelColor2")
        datasource.titleSelectedColor = .label(withName: "ZLLabelColor1")
        datasource.titleNormalFont =  .zlRegularFont(withSize: 14)
        datasource.titleSelectedFont = .zlSemiBoldFont(withSize: 16)
        return datasource
    }()

}

// MARK: - JXSegmentedListContainerViewDataSource
extension ZLSearchController: JXSegmentedListContainerViewDataSource {
   
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        searchTypes.count
    }
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        vcDic[searchTypes[index]] ?? ZLSearchChildListController(type: .repo)
    }
}


// MARK: - Action
extension ZLSearchController {
    
    @objc func onCancelButtonClicked() {
        self.searchTextField.text = self.preSearchKeyWord
        self.searchTextField.resignFirstResponder()
        self.setUnEditStatus()
    }
    
}

// MARK: UITextFieldDelegate
extension ZLSearchController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.preSearchKeyWord  = self.searchTextField.text ?? ""
        self.setEditStatus()
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {

    }



    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.preSearchKeyWord  = self.searchTextField.text ?? ""
        self.setUnEditStatus()
        textField.resignFirstResponder()
        vcDic.values.forEach { vc in
            vc.setNewQuery(q: self.preSearchKeyWord)
        }
        return false
     }

}
