//
//  CustomCell.swift
//  adblock-test
//
//  Created by admin on 2018/11/17.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import Foundation

class RootCustomCell: UITableViewCell {
    
    private var dataSource: RootDataSource!
    private var jsonManager: JsonManager!
    private var contentBlockerManager: ContentBlockerManager!
    
    private var tableLabel: UILabel!
    private var tableSwitch: UISwitch!
    
    var adList: Ad? {
        
        didSet {
            guard let ad = self.adList else { return }
            
            tableLabel.text = ad.domain
            tableSwitch.isOn = ad.state
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // UILabel
        tableLabel = UILabel()
        tableLabel.textColor = .black
        tableLabel.font = .systemFont(ofSize: 14)
        self.contentView.addSubview(tableLabel)
        
        // UISwitch
        tableSwitch = UISwitch()
        tableSwitch.onTintColor = .blue
        tableSwitch.addTarget(self, action: #selector(switchButtonTaped(sender:)), for: .valueChanged)
        self.contentView.addSubview(tableSwitch)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tableLabel.frame = CGRect(x: 15, y: 12, width: 288, height: 21)
        tableSwitch.frame = CGRect(x: 311, y: 6, width: 49, height: 31)
    }
    
    @objc private func switchButtonTaped(sender: UISwitch) {
        
        print("taped Switch")
        
        dataSource = RootDataSource()
        jsonManager = JsonManager()
        contentBlockerManager = ContentBlockerManager()
        
        // テーブルデータを取得
        dataSource.load()
        
        // タップしたUISwitchの論理値を変更・保存
        let domain = tableLabel.text!
        let state = tableSwitch.isOn
        dataSource.changeSwitchState(domain: domain, state: state)
        dataSource.save()
        
        // 共有ファイルの作成・更新
        jsonManager.createAndWriteJsonFile()
        
        // Content Blocker Extension を更新
        contentBlockerManager.reloadContentBlocker()
        
        // UITableViewを更新 (通知を送る)
        let notiCenter = NotificationCenter.default
        notiCenter.post(name: .tableDataReload, object: nil)
    }
    
}

extension Notification.Name {
    
    static let tableDataReload = Notification.Name("RootTableDataReload")
    static let tableDataReload2 = Notification.Name("Sub1TableDataReload")
    static let tableDataReload3 = Notification.Name("Sub2TableDataReload")
    static let tableDataReload4 = Notification.Name("Sub3TableDataReload")
}
