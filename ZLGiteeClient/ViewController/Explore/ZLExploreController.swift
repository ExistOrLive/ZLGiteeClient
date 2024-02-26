//
//  ZLExploreController.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2022/5/20.
//

import UIKit
import ZLBaseUI
import ZLUtilities
import JXSegmentedView

enum ExploreType: CaseIterable {
    case recommend
    case hot
    case latest
    
    var title: String {
        switch self {
        case .recommend:
            return "推荐"
        case .hot:
            return "热门"
        case .latest:
            return "最近更新"
        }
    }
}

class ZLExploreController: ZLBaseViewController {
    
    lazy var exploreTypes: [ExploreType] = ExploreType.allCases
    
    lazy var vcDic: [ExploreType: ZLExploreChildListController] = {
        var vcDic : [ExploreType: ZLExploreChildListController] = [:]
        exploreTypes.forEach {
            vcDic[$0] = ZLExploreChildListController(type: $0)
        }
        return vcDic
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @objc dynamic func setupUI() {
        setZLNavigationBarHidden(true)
        contentView.addSubview(headerView)
        contentView.addSubview(segmentedListContainerView)
        
        headerView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(60)
        }
        
        segmentedListContainerView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(self.headerView.snp.bottom)
        }
    }
    

    // MARK: Lazy View
    lazy var headerView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(named:"ZLNavigationBarBackColor")
        view.addSubview(trendingLabel)
        view.addSubview(segmentedView)
        view.addSubview(searchButton)
        segmentedView.snp.makeConstraints { make in
            make.width.equalTo(210)
            make.height.equalTo(35)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-10)
        }
        
        trendingLabel.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.left.equalTo(20)
            make.centerY.equalToSuperview()
        }
        
        searchButton.snp.makeConstraints { make in
            make.right.equalTo(-20)
            make.size.equalTo(30)
            make.centerY.equalToSuperview()
        }
        return view
    }()
    
    lazy var trendingLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.zlIconFont(withSize: 25)
        label.text = ZLIconFont.Trending.rawValue
        label.textColor = UIColor(named:"ZLLabelColor1")
        return label
    }()
    
    lazy var searchButton: UIButton = {
       let button = UIButton()
        button.setTitle(ZLIconFont.Search.rawValue, for: .normal)
        button.titleLabel?.font = UIFont.zlIconFont(withSize: 25)
        button.setTitleColor(UIColor(named:"ZLLabelColor1"), for: .normal)
        button.addTarget(self, action: #selector(onSearchButtonClicked(_ :)), for: .touchUpInside)
        return button
    }()
    
    lazy var segmentedListContainerView: JXSegmentedListContainerView = {
        JXSegmentedListContainerView(dataSource: self, type: .scrollView)
    }()
    
    lazy var segmentedViewDatasource: JXSegmentedTitleDataSource = {
    
        let dataSource = JXSegmentedTitleDataSource()
        
        dataSource.titles = exploreTypes.map({ $0.title })
        dataSource.titleNormalColor = UIColor.label(withName: "ZLLabelColor2")
        dataSource.titleSelectedColor = UIColor.label(withName: "ZLLabelColor1")
        dataSource.titleNormalFont = UIFont.zlRegularFont(withSize: 12.0)
        dataSource.titleSelectedFont = UIFont.zlSemiBoldFont(withSize: 14.0)
        dataSource.itemWidth = 60
        dataSource.itemSpacing = 0
        
        return dataSource
    }()
    
    lazy var indicator: JXSegmentedIndicatorBackgroundView = {
        let indicator = JXSegmentedIndicatorBackgroundView()
        indicator.indicatorColor = UIColor.init(named: "SegmentedViewBackIndicator") ?? UIColor.gray
        indicator.indicatorHeight = 31.0
        indicator.indicatorWidthIncrement = 0
        indicator.indicatorWidth = 70.0
        indicator.indicatorCornerRadius = 8.0
        return indicator
    }()
    
    lazy var segmentedView: JXSegmentedView = {
        let segmentedView = JXSegmentedView()
        segmentedView.dataSource = segmentedViewDatasource
        segmentedView.listContainer = segmentedListContainerView
        segmentedView.indicators = [indicator]
        segmentedView.backgroundColor = UIColor(named:"SegmentedViewBack")
        segmentedView.cornerRadius = 8.0
        return segmentedView
    }()

}

// MARK: - Action
extension ZLExploreController {
    @objc func onSearchButtonClicked(_ button: UIButton) {
        let vc = ZLSearchController()
        vc.hidesBottomBarWhenPushed = true 
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - JXSegmentedListContainerViewDataSource
extension ZLExploreController: JXSegmentedListContainerViewDataSource {
   
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        exploreTypes.count
    }
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        vcDic[exploreTypes[index]] ?? ZLExploreChildListController(type: .recommend)
    }
}
