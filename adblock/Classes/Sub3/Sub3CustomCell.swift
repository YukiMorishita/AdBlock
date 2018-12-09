//
//  Sub3CustomCell.swift
//  adblock-test
//
//  Created by admin on 2018/11/26.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FirebaseDatabase

class Sub3CustomCell: UITableViewCell {
    
    private let groupID = "group.jp.ac.osakac.cs.hisalab.adblock"
    private let key = "ratingAvg"
    
    private var dataSource: RootDataSource!
    private var jsonManager: JsonManager!
    
    private var ratingsAvgList = [(avg: Int, name: String)]()
    private var ratingsAvgStrList = [String]()
    
    private var tableLabel: UILabel!
    private var tableRateLabel: UILabel!
    private var downloadCountLabel: UILabel!
    
    private var moreLabel: UILabel!
    private var downloadButton: UIButton!
    
    var shareList: DataSnapshot? {
        
        didSet {
            guard let share = self.shareList else { return }
            
            tableLabel.text = share.childSnapshot(forPath: "name").value as? String
            tableRateLabel.text = setRatingAvgStr(text: tableLabel.text!) //"3.0 ★★★☆☆"
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // UILabel
        tableLabel = UILabel()
        tableLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        tableLabel.font = .boldSystemFont(ofSize: 20)
        self.contentView.addSubview(tableLabel)
        
        // UILabel
        tableRateLabel = UILabel()
        tableRateLabel.textColor = #colorLiteral(red: 0.506384835, green: 0.506384835, blue: 0.506384835, alpha: 1)
        tableRateLabel.font = .systemFont(ofSize: 12)
        self.contentView.addSubview(tableRateLabel)
        
        // UILabel
        moreLabel = UILabel()
        moreLabel.text = "more"
        moreLabel.textColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        moreLabel.font = .systemFont(ofSize: 10)
        self.contentView.addSubview(moreLabel)
        
        // ダウンロードボタン
        downloadButton = UIButton()
        downloadButton.setTitle("Download", for: .normal)
        downloadButton.setTitleColor(.white, for: .normal)
        downloadButton.titleLabel?.font = .systemFont(ofSize: 14)
        downloadButton.backgroundColor = #colorLiteral(red: 0.2697268039, green: 0.7297354355, blue: 0.8500519453, alpha: 1)
        downloadButton.layer.cornerRadius = 10.0
        downloadButton.layer.shadowRadius = 20.0
        downloadButton.addTarget(self, action: #selector(downloadButtonTaped), for: .touchUpInside)
        self.contentView.addSubview(downloadButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tableLabel.frame = CGRect(x: 25, y: 25, width: 220, height: 21)
        tableRateLabel.frame = CGRect(x: 25, y: 45, width: 220, height: 21)
        moreLabel.frame = CGRect(x: 325, y: 55, width: 42, height: 21)
        downloadButton.frame = CGRect(x: 275, y: 25, width: 80, height: 30)
    }
    
    // rate の平均データを取得
    func loadRatingAvgData() {
    
        let defaults = UserDefaults(suiteName: groupID)
        let ratingAvgDic = defaults?.object(forKey: key) as? [[String: Any]]
        guard let ratings = ratingAvgDic else { return }
        
        self.ratingsAvgList = ratings.map { (avg: $0["avg"] as! Int, name: $0["name"] as! String) }
    }
    
    func setRatingAvgStr(text: String) -> String {
        
        // rateの平均データを読み込み
        loadRatingAvgData()
        
        let ratingAvgList = self.ratingsAvgList
        
        let nameList = ratingAvgList.map { $0.name }
        let index = nameList.findIndex(includeElement: { $0 == text }).first!

        let rateAvg = ratingAvgList.map { $0.avg }[index]
        let rateAvgStr = "\(rateAvg)" + ".0" + " \(createStarStr(rate: rateAvg))"
        
        return rateAvgStr
    }
    
    func createStarStr(rate: Int) -> String {
        
        var num = 0
        var star = ""
        
        while num < rate {
            
            star += "★"
            num += 1
        }
        
        return star
    }
    
    func getGroup() -> [String]? {
        
        let group = [String]()
        
        let dbRootRef = Database.database().reference()
        let dbThisRef = dbRootRef.child("group").child("-LSswgLbGSb6PkNDkBEn").child("documents")
        
        dbThisRef.observe(.value, with: { (snapshot) in
            
        })
        
        return group
    }
    
    func download() {
        
        dataSource = RootDataSource()
        
        var domains = [String]()
        
        let tableData = self.shareList
        let domainList = tableData?.childSnapshot(forPath: "domains")
        let domainListCount = tableData?.childSnapshot(forPath: "domains").childrenCount
        
        // database から domains を取得
        for i in 0..<domainListCount! {
            
            domains.append(domainList?.childSnapshot(forPath: "\(i)").value as! String)
        }
        
        dataSource.downloadToUpdateAdList(domains: domains)
        dataSource.save()
    }
    
    @objc func downloadButtonTaped() {
    
        print("downloadButton taped")
        download()
        
        let notiCenter = NotificationCenter.default
        notiCenter.post(name: .downloadAlert, object: nil)
    }
    
}
