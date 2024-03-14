//
//  ZLWorkBoardController.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2022/5/20.
//

import UIKit
import ZLBaseUI
import JXPagingView
import JXSegmentedView

class ZLWorkBoardController: ZLBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "工作台"
        setupUI()
    }
    
    func setupUI() {
        contentView.addSubview(pagingView)
        pagingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        if let userModel = ZLGiteeOAuthUserServiceModel.sharedService.currentUserModel {
            headerView.fillWithData(data: userModel)
        }
        pagingView.reloadData()
        
        /// 授权用户的issue
         https://gitee.com/api/v5/user/issues
        
        组织
    https://gitee.com/api/v5/user/orgs
        
        所有仓库
    https://gitee.com/api/v5/user/repos
    }
    

    lazy var headerView: ZLWorkBoardHeaderView = {
       let headerView = ZLWorkBoardHeaderView()
        return headerView
    }()
    
    lazy var pagingView: JXPagingView = {
        let pagingView = JXPagingView(delegate: self)
        return pagingView
    }()
    
    
    lazy var segmentedViewDataSource: JXSegmentedTitleDataSource = {
        let dataSource = JXSegmentedTitleDataSource()
        dataSource.titles = ["动态","仓库","星选集"]
        dataSource.titleSelectedFont = .zlMediumFont(withSize: 12)
        dataSource.titleNormalFont = .zlRegularFont(withSize: 12)
        dataSource.titleSelectedColor = .black
        dataSource.titleNormalColor = .gray
        dataSource.itemWidth = floor(UIScreen.main.bounds.size.width / 3.0)
        dataSource.itemSpacing = 0
        return dataSource
    }()

    lazy var segmentedView: JXSegmentedView  = {
        let view = JXSegmentedView()
        view.dataSource = segmentedViewDataSource
        view.listContainer = pagingView.listContainerView
        return view
    }()
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - JXPagingViewDelegate
extension ZLWorkBoardController: JXPagingViewDelegate {
    
    func pagingView(_ pagingView: JXPagingView, initListAtIndex index: Int) -> any JXPagingViewListViewDelegate {
        ZLWorkBoardEventController()
    }
    
    
    /// tableHeaderView的高度，因为内部需要比对判断，只能是整型数
    func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int {
        70
    }
    
    /// 返回tableHeaderView
    func tableHeaderView(in pagingView: JXPagingView) -> UIView {
        headerView
    }
    /// 返回悬浮HeaderView的高度，因为内部需要比对判断，只能是整型数
    func heightForPinSectionHeader(in pagingView: JXPagingView) -> Int {
        60
    }
    /// 返回悬浮HeaderView
    func viewForPinSectionHeader(in pagingView: JXPagingView) -> UIView {
        segmentedView
    }
    
    /// 返回列表的数量
    func numberOfLists(in pagingView: JXPagingView) -> Int {
        3
    }
}


extension JXPagingListContainerView: JXSegmentedViewListContainer {}
