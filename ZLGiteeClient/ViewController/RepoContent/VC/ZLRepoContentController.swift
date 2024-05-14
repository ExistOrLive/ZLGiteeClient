//
//  ZLRepoContentController.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/5/14.
//

import UIKit
import ZLUIUtilities
import ZLBaseUI
import ZLBaseExtension
import ZLUtilities

class ZLRepoContentNode {
    var path: String = ""
    var name: String = ""
    var content: ZLGiteeFileContentModel?
    var subNodes: [ZLRepoContentNode]?
    var parentNode: ZLRepoContentNode?
}

class ZLRepoContentController: ZLBaseViewController {

    // model
    let loginName: String
    let repoName: String
    let path: String
    var ref: String?
    
    /// 根节点
    var rootContentNode: ZLRepoContentNode?
    /// 当前节点
    var currentContentNode: ZLRepoContentNode?
    
    lazy var tableContainerView: ZLTableContainerView = {
        let view = ZLTableContainerView()
        view.register(ZLRepoContentTableViewCell.self, forCellReuseIdentifier: "ZLRepoContentTableViewCell")
        view.delegate = self
        return view
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.iconFontImage(withText: ZLIconFont.Close.rawValue,
                                              fontSize: 24,
                                              color: .black), for: .normal)
        button.frame = CGRect.init(x: 0, y: 0, width: 60, height: 60)
        button.addTarget(self, action: #selector(onCloseButtonClicked(_button:)), for: .touchUpInside)
        return button
    }()
    
    init(loginName: String,
         repoName: String,
         path: String? = nil,
         ref: String? = nil) {
        self.loginName = loginName
        self.repoName = repoName
        self.path = path ?? "/"
        self.ref = ref
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {

        super.viewDidLoad()
        
        self.generateContentTree()
        
        self.setUpUI()

        self.reloadData()

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let navigationVC = navigationController as? ZLBaseNavigationController {
            navigationVC.forbidGestureBack = false
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let navigationVC = navigationController as? ZLBaseNavigationController {
            navigationVC.forbidGestureBack = true
        }
    }

    func generateContentTree() {

        self.rootContentNode = ZLRepoContentNode()
        self.currentContentNode = rootContentNode

        let nameArray: [Substring] =  path.split(separator: "/")

        var tmpPath = ""
        for name in nameArray {
            tmpPath.append(contentsOf: name)
            let node = ZLRepoContentNode()
            node.name = String(name)
            node.path = tmpPath
            node.parentNode = self.currentContentNode
            self.currentContentNode = node
            tmpPath.append("/")
        }
    }
    
    func setUpUI() {
    
        self.zlNavigationBar.backButton.isHidden = false
        self.zlNavigationBar.rightButton = closeButton

        self.contentView.addSubview(tableContainerView)
        tableContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func reloadData() {
        self.title = self.currentContentNode?.name == ""  ? "/" : self.currentContentNode?.name

        let cellDatas = self.subViewModels
        cellDatas.forEach { $0.removeFromSuperViewModel() }
        
        if let subNodes = currentContentNode?.subNodes {
            let newCellDatas = subNodes.map { ZLRepoContentTableViewCellData(model: $0)}
            self.addSubViewModels(newCellDatas)
            self.tableContainerView.resetCellDatas(cellDatas: newCellDatas, hasMoreData: false )
        } else {
            self.tableContainerView.clearListView()
            self.tableContainerView.startLoad()
        }
    }

   

}

// MARK: - Action
extension ZLRepoContentController  {
    
    override func onBackButtonClicked(_ button: UIButton!) {
        if self.currentContentNode?.parentNode != nil {
            self.currentContentNode = self.currentContentNode?.parentNode
            self.reloadData()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }

    @objc func onCloseButtonClicked(_button: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func enterDir(model: ZLRepoContentNode) {
        self.currentContentNode = model
        self.reloadData()
    }
}

// MARK: - ZLTableContainerViewDelegate
extension ZLRepoContentController: ZLTableContainerViewDelegate {
    func zlLoadNewData() {
        loadData()
    }
    
    func zlLoadMoreData() {
    }
}


// MARK: - Request
extension ZLRepoContentController {
    
    func loadData() {
        ZLGiteeRequest.sharedProvider.requestRest(.repoContentList(login: loginName, repoName: repoName, path: currentContentNode?.path ?? "", ref: ref),
                                                  completion: { [weak self] (result, model, msg) in
            guard let self else { return }
            if result, let array = model as? [ZLGiteeFileContentModel] {
                var dirArray: [ZLRepoContentNode] = []
                var fileArray: [ZLRepoContentNode] = []
                for tmpData in array {
                    let contentNode = ZLRepoContentNode()
                    contentNode.name = tmpData.name
                    contentNode.path = tmpData.path
                    contentNode.parentNode = self.currentContentNode
                    contentNode.content = tmpData
                    if tmpData.type == "dir" {
                        dirArray.append(contentNode)
                    } else {
                        fileArray.append(contentNode)
                    }
                }
                dirArray = dirArray.sorted { node1, node2 in
                    node1.name < node2.name
                }
                fileArray = fileArray.sorted { node1, node2 in
                    node1.name < node2.name
                }
                self.currentContentNode?.subNodes = dirArray + fileArray
                
                let dataArray = self.currentContentNode?.subNodes ?? []
                let cellDatas = self.subViewModels
                cellDatas.forEach { $0.removeFromSuperViewModel() }
                let newCellDatas = dataArray.map { ZLRepoContentTableViewCellData(model: $0)}
                self.addSubViewModels(newCellDatas)
                self.tableContainerView.resetCellDatas(cellDatas: newCellDatas, hasMoreData: false )
            
            } else {
                self.tableContainerView.endRefresh()
            }
        })
    }
}

