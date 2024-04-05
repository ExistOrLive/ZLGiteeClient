//
//  ZLGiteeContributionsView.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/3/25.
//

import Foundation
import UIKit
import ZLBaseUI
import Kanna

class ZLGiteeContributionData: NSObject {
    var contributionsNumber = 0
    var contributionsDate = ""
    var contributionsLevel = 0               //  0～5 none less little some many much
    var contributionsWeekday = 0             //  1～7 周1～周日
}


class ZLGiteeContributionsView: ZLBaseView, UICollectionViewDataSource, UICollectionViewDelegate {

    // model
    private var loginName  = ""
    private var dataArray: [ZLGiteeContributionData] = []

    // view
    private lazy var collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.estimatedItemSize = CGSize(width: 10, height: 10)
        collectionViewLayout.minimumInteritemSpacing = 2
        collectionViewLayout.minimumLineSpacing = 2
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()

    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Font_PingFangSCSemiBold, size: 12)
        label.textColor = UIColor(named: "ZLLabelColor2")
        label.isUserInteractionEnabled = false
        label.textAlignment = .center
        return label
    }()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setUpUI()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpUI()
    }

    override func updateConstraints() {
        super.updateConstraints()
        collectionView.snp.updateConstraints { (make) in
            make.width.equalTo(collectionView.contentSize.width + 10).priority(.high)
        }
    }

    deinit {
        collectionView.removeObserver(self, forKeyPath: "contentSize")
    }

    private func setUpUI() {

        self.backgroundColor = UIColor(named: "ZLContributionBackColor")

        self.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.bottom.centerX.equalToSuperview()
            make.left.greaterThanOrEqualToSuperview()
            make.right.lessThanOrEqualToSuperview()
            make.width.equalTo(collectionView.contentSize.width + 10).priority(.high)
        }
        collectionView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)

        self.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    func update(loginName: String, force: Bool = false ) {

        if force ||
            loginName != self.loginName ||
            self.dataArray.isEmpty {

            self.startLoad(loginName: loginName)
        }
    }

    func startLoad(loginName: String) {

        self.loginName = loginName
        
        loadContributionData { [weak self] dataArray in
            guard let self else { return }
            
            self.dataArray = dataArray
            self.collectionView.reloadData()
            
            self.collectionView.performBatchUpdates { [weak self] in
                self?.collectionView.reloadData()
            } completion: { [weak self] _ in
                guard let self = self else {return}
                let count = self.dataArray.count
                if count > 0 && self.collectionView.contentOffset.x <= 0 {
                    let indexPath = IndexPath(row: count - 1, section: 0)
                    self.collectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.right, animated: false)
                }
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.label.text = self.dataArray.count == 0  ? "No Data" : nil
        return self.dataArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
        collectionViewCell.cornerRadius = 2.0
        let contributionData = self.dataArray[indexPath.row]
        switch contributionData.contributionsLevel {
        case 1:
            collectionViewCell.backgroundColor = UIColor(named: "ZLContributionColor1")
        case 2:
            collectionViewCell.backgroundColor = UIColor(named: "ZLContributionColor2")
        case 3:
            collectionViewCell.backgroundColor = UIColor(named: "ZLContributionColor3")
        case 4:
            collectionViewCell.backgroundColor = UIColor(named: "ZLContributionColor4")
        case 5:
            collectionViewCell.backgroundColor = UIColor(named: "ZLContributionColor5")
        default:
            collectionViewCell.backgroundColor = UIColor(named: "ZLContributionBackColor")
        }
        return collectionViewCell
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        self.setNeedsUpdateConstraints()
    }
}


extension ZLGiteeContributionsView {
    func loadContributionData(callBack: @escaping ([ZLGiteeContributionData]) -> Void) {
        ZLGiteeRequest.sharedProvider.requestRest(.userContributionData(login: loginName)) { [weak self] res, data, msg in
            guard let self , res,
                  let data = data as? Data,
                  let htmlDoc = try? HTML(html:data, encoding: .utf8 ) else { return }
            
            guard let contribution_box =  htmlDoc.at_xpath("//div[@class='contribution-box']"),
                  let container = contribution_box.at_xpath("/div[@class='right-side']") else { return }
            
            let boxArray = container.xpath("/div[contains(@class, 'box')]")
            
            var contributionDataArray: [ZLGiteeContributionData] = []
            var weekDay: Int = 0
            for box in boxArray {
                let data = ZLGiteeContributionData()
                if let classStr = box["class"] {
                    if classStr.contains("less") {
                        data.contributionsLevel = 1
                    } else if classStr.contains("little")  {
                        data.contributionsLevel = 2
                    } else if classStr.contains("some")  {
                        data.contributionsLevel = 3
                    } else if classStr.contains("many")  {
                        data.contributionsLevel = 4
                    } else if classStr.contains("much")  {
                        data.contributionsLevel = 5
                    }
                    
                    let data_content = (box["data-content"] ?? "").replacingOccurrences(of: " ", with: "个贡献：")
                    let dataArray = data_content.split(separator: " ")
                    data.contributionsDate = String(dataArray.last ?? "")
                    data.contributionsNumber = Int(dataArray.first ?? "0") ?? 0
                    data.contributionsWeekday = weekDay + 1
                    weekDay = (weekDay + 1) % 7
                    contributionDataArray.append(data)
                }
            
            }
            
            callBack(contributionDataArray)
        }
    }
}
