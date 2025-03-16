//
//  ZLMyRepoListController.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/3/24.
//

import Foundation
import SnapKit
import Moya
import ZLUIUtilities
import ZMMVVM
import JXPagingView
import ZLBaseExtension
import ZLUtilities

class ZLMyRepoListController: ZMTableViewController {
     
    // data
    private var affiliationType: ZLGiteeMyRepoAffiliationType = .all
    private var visibilityType: ZLGiteeMyRepoVisibilityType = .all
    private var sortType: ZLGiteeMyRepoSortType = .full_name
    
    private var page: Int = 1
    private var per_page: Int = 20
        

    override func viewDidLoad() {
        super.viewDidLoad()
        viewStatus = .loading
        refreshLoadNewData()
    }
    
    override func setupUI() {
        super.setupUI()
        title = "我的仓库"
        setRefreshView(type: .header)
        setRefreshView(type: .footer)
        hiddenRefreshView(type: .footer)
        
        tableView.removeFromSuperview()
        tableView.register(ZLRepositoryTableViewCell.self, forCellReuseIdentifier: "ZLRepositoryTableViewCell")
        tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        
        contentView.addSubview(verticalStackView)
        verticalStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        updateHeaderButtons()
    }
    
    lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.addArrangedSubview(headerView)
        stackView.addArrangedSubview(tableView)
        headerView.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        return stackView
    }()
    
    lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "ZLNavigationBarBackColor")
        view.addSubview(headerScrollView)
        headerScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return view
    }()
    
    lazy var affiliationButton: UIButton = {
        let button = ZMButton(type: .custom)
        button.titleLabel?.font = UIFont.zlMediumFont(withSize: 11)
        button.addTarget(self, action: #selector(onAffiliationButtonClicked), for: .touchUpInside)
        button.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(25)
        }
        return button
    }()
    
    lazy var visibilityButton: UIButton = {
        let button = ZMButton(type: .custom)
        button.titleLabel?.font = UIFont.zlMediumFont(withSize: 11)
        button.addTarget(self, action: #selector(onVisibilityButtonClicked), for: .touchUpInside)
        button.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(25)
        }
        return button
    }()
    
    lazy var sortButton: UIButton = {
        let button = ZMButton(type: .custom)
        button.titleLabel?.font = UIFont.zlMediumFont(withSize: 11)
        button.addTarget(self, action: #selector(onSortButtonClicked), for: .touchUpInside)
        button.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(25)
        }
        return button
    }()
    
    lazy var headerScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.bounces = false
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
            make.height.equalTo(40)
        }
        return scrollView
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.addArrangedSubview(affiliationButton)
        stackView.addArrangedSubview(visibilityButton)
        stackView.addArrangedSubview(sortButton)
        return stackView
    }()
    
    lazy var affiliationPopView: ZMInputPopView = {
        let popView = generatePopView()
        return popView
    }()
    
    lazy var visibilityPopView: ZMInputPopView = {
        let popView = generatePopView()
        return popView
    }()
    
    lazy var sortPopView: ZMInputPopView = {
        let popView = generatePopView()
        return popView
    }()
    
    func dismisAllPopView() {
        affiliationPopView.dismissForce(animated: false)
        visibilityPopView.dismissForce(animated: false)
        sortPopView.dismissForce(animated: false)
    }
    
    func generatePopView() -> ZMInputPopView {
        let popView = ZMInputPopView()
        popView.contentWidth = ZLScreenWidth
        popView.collectionView.register(cellType: ZMInputCollectionViewSelectTickCell.self,
                                        forCellWithReuseIdentifier: "ZMInputCollectionViewSelectTickCell")
        popView.collectionView.itemSize = CGSize(width: ZLScreenWidth, height: 40)
        popView.collectionView.lineSpacing = .leastNonzeroMagnitude
        popView.frame = CGRect(x: 0, y: 40, width: ZLScreenWidth, height: contentView.frame.height - 40)
        return popView
    }
    
    override func refreshLoadNewData() {
        loadData(loadNewData: true)
    }
    
    override func refreshLoadMoreData() {
        loadData(loadNewData: false)
    }
}

// MARK: - Action
extension ZLMyRepoListController {
    /// 仓库所属筛选
    func updateHeaderButtons() {

          let affiliationStr = NSASCContainer(
            "仓库所属："
                .asMutableAttributedString()
                .font(.zlMediumFont(withSize: 10))
                .foregroundColor(UIColor.label(withName: "ZLLabelColor2")),
            affiliationType.title
                .asMutableAttributedString()
                .font(.zlMediumFont(withSize: 10))
                .foregroundColor(UIColor.label(withName: "ZLLabelColor1")),
            " "
                .asMutableAttributedString(),
            ZLIconFont.DownArrow.rawValue
                .asMutableAttributedString()
                .font(.iconFont(size: 10))
                .foregroundColor(UIColor.label(withName: "ZLLabelColor1"))).asAttributedString()
        
        let affiliationTitleWidth = affiliationStr
            .boundingRect(with: CGSize(width: CGFloat.infinity, height: CGFloat.infinity), options: .usesLineFragmentOrigin, context: nil)
            .width + 30
        affiliationButton.snp.updateConstraints { make in
            make.width.equalTo(max(affiliationTitleWidth,60))
        }
        affiliationButton.setAttributedTitle(affiliationStr, for: .normal)
        
        let visibilityStr = NSASCContainer(
          "可见性："
              .asMutableAttributedString()
              .font(.zlMediumFont(withSize: 10))
              .foregroundColor(UIColor.label(withName: "ZLLabelColor2")),
          visibilityType.title
              .asMutableAttributedString()
              .font(.zlMediumFont(withSize: 10))
              .foregroundColor(UIColor.label(withName: "ZLLabelColor1")),
          " "
              .asMutableAttributedString(),
          ZLIconFont.DownArrow.rawValue
              .asMutableAttributedString()
              .font(.iconFont(size: 10))
              .foregroundColor(UIColor.label(withName: "ZLLabelColor1"))).asAttributedString()
        
        let visibilityTitleWidth = visibilityStr
            .boundingRect(with: CGSize(width: CGFloat.infinity, height: CGFloat.infinity), options: .usesLineFragmentOrigin, context: nil)
            .width + 30
        visibilityButton.snp.updateConstraints { make in
            make.width.equalTo(max(visibilityTitleWidth,60))
        }
        visibilityButton.setAttributedTitle(visibilityStr, for: .normal)
          
        let sortStr = NSASCContainer(
          "排序："
              .asMutableAttributedString()
              .font(.zlMediumFont(withSize: 10))
              .foregroundColor(UIColor.label(withName: "ZLLabelColor2")),
          sortType.title
              .asMutableAttributedString()
              .font(.zlMediumFont(withSize: 10))
              .foregroundColor(UIColor.label(withName: "ZLLabelColor1")),
          " "
              .asMutableAttributedString(),
          ZLIconFont.DownArrow.rawValue
              .asMutableAttributedString()
              .font(.iconFont(size: 10))
              .foregroundColor(UIColor.label(withName: "ZLLabelColor1"))).asAttributedString()
        
        let sortTitleWidth = visibilityStr
            .boundingRect(with: CGSize(width: CGFloat.infinity, height: CGFloat.infinity), options: .usesLineFragmentOrigin, context: nil)
            .width + 30
        sortButton.snp.updateConstraints { make in
            make.width.equalTo(max(sortTitleWidth,60))
        }
        sortButton.setAttributedTitle(sortStr, for: .normal)
    }
}

// MARK: - Action
extension ZLMyRepoListController {
    /// 仓库所属筛选
    @objc func onAffiliationButtonClicked() {
        dismisAllPopView()
        let cellDatas = ZLGiteeMyRepoAffiliationType.allCases.map {
            let cellData = ZMSelectTitleBoxCellData()
            cellData.title = $0.title
            cellData.cellSelected = $0 == self.affiliationType
            cellData.cellIdentifier = "ZMInputCollectionViewSelectTickCell"
            return cellData
        }
        affiliationPopView.showSingleSelectBox(contentView,
                                               contentPoition: .top,
                                               animationDuration: 0.25, 
                                               cellDatas: cellDatas,
                                               singleSelectBlock: { [weak self] index in
            guard let self else { return }
            self.affiliationType = ZLGiteeMyRepoAffiliationType.allCases[index]
            self.updateHeaderButtons()
            self.contentView.showProgressHUD()
            self.loadData(loadNewData: true)
        })
    }
    
    /// 仓库可见性
    @objc func onVisibilityButtonClicked() {
        dismisAllPopView()
        let cellDatas = ZLGiteeMyRepoVisibilityType.allCases.map {
            let cellData = ZMSelectTitleBoxCellData()
            cellData.title = $0.title
            cellData.cellSelected = $0 == self.visibilityType
            cellData.cellIdentifier = "ZMInputCollectionViewSelectTickCell"
            return cellData
        }
        visibilityPopView.showSingleSelectBox(contentView,
                                               contentPoition: .top,
                                               animationDuration: 0.25,
                                               cellDatas: cellDatas,
                                               singleSelectBlock: { [weak self] index in
            guard let self else { return }
            self.visibilityType = ZLGiteeMyRepoVisibilityType.allCases[index]
            self.updateHeaderButtons()
            self.contentView.showProgressHUD()
            self.loadData(loadNewData: true)
        })
    }
    
    /// 排序筛选
    @objc func onSortButtonClicked() {
        dismisAllPopView()
        let cellDatas = ZLGiteeMyRepoSortType.allCases.map {
            let cellData = ZMSelectTitleBoxCellData()
            cellData.title = $0.title
            cellData.cellSelected = $0 == self.sortType
            cellData.cellIdentifier = "ZMInputCollectionViewSelectTickCell"
            return cellData
        }
        affiliationPopView.showSingleSelectBox(contentView,
                                               contentPoition: .top,
                                               animationDuration: 0.25,
                                               cellDatas: cellDatas,
                                               singleSelectBlock: { [weak self] index in
            guard let self else { return }
            self.sortType = ZLGiteeMyRepoSortType.allCases[index]
            self.updateHeaderButtons()
            self.contentView.showProgressHUD()
            self.loadData(loadNewData: true)
        })
    }
}

// MARK: - request
extension ZLMyRepoListController {
    func loadData(loadNewData: Bool) {
        
        if loadNewData == true {
            page = 1
        } else {
            page += 1
        }
        
        ZLGiteeRequest.sharedProvider.requestRest(.oauthUserRepoList(page: page,
                                                                     per_page: per_page,
                                                                     sort: sortType.value,
                                                                     visibility: visibilityType.value,
                                                                     affiliation: affiliationType.value),
                                                  completion: { [weak self] (result, model, msg) in
            guard let self else { return }
            self.viewStatus = .normal
            self.endRefreshView(type: .header)
            self.endRefreshView(type: .footer)
            if result, let array = model as? [ZLGiteeRepoModel] {
                let newCellDatas = array.map { ZLRepositoryTableViewCellData(model: $0) }
                self.zm_addSubViewModels(newCellDatas)
                if loadNewData {
                    for sectionData in self.sectionDataArray {
                        sectionData.zm_removeFromSuperViewModel()
                    }
                    let sectionData = ZMBaseTableViewSectionData(zm_sectionID: "", cellDatas: newCellDatas)
                    self.sectionDataArray = [sectionData]
                    self.tableViewProxy.reloadData()
                    self.viewStatus = newCellDatas.isEmpty ? .empty : .normal
                    self.page = 2
                } else {
                    self.sectionDataArray.first?.cellDatas.append(contentsOf: newCellDatas)
                    self.tableViewProxy.reloadData()
                    self.page = self.page + 1
                }
                
            } else {
                self.viewStatus = self.tableViewProxy.isEmpty ? .error : .normal
                self.endRefreshView(type: loadNewData ? .header : .footer)
            }
        })
    }
}


