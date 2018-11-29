//
//  Sub2CustomCell.swift
//  adblock-test
//
//  Created by admin on 2018/11/18.
//  Copyright © 2018 admin. All rights reserved.
//


import UIKit
import Foundation

class Sub2CustomCell: UITableViewCell {
    
    private var dataSource: Sub2DataSource!
    private var jsonManager: JsonManager!
    private var contentBlockerManager: ContentBlockerManager!
    
    fileprivate var tableLabel: UILabel!
    fileprivate var tableSwitch: UISwitch!
    
    var forEachList: Domain? {
        
        didSet {
            guard let forEach = self.forEachList else { return }
            
            tableLabel.text = forEach.domain
            tableSwitch.isOn = forEach.state
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
        tableSwitch.addTarget(self, action: #selector(tapedSwitch(sender:)), for: .valueChanged)
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
    
    @objc private func tapedSwitch(sender: UISwitch) {
        
        print("taped Switch")
        
        dataSource = Sub2DataSource()
        jsonManager = JsonManager()
        contentBlockerManager = ContentBlockerManager()
        
        dataSource.load()
        
        // タップしたUISwitchの論理値を変更・保存
        let domain = tableLabel.text!
        let state = tableSwitch.isOn
        dataSource.changeSwitchState(domain: domain, state: state)
        dataSource.save()
        
        // JSONファイルを取得・共有ファイルを作成
        jsonManager.createAndWriteJsonFile()
        // Content Blocker Extension を更新
        contentBlockerManager.reloadContentBlocker()
        
        // UITableViewを更新 (通知を送る)
        let notiCenter = NotificationCenter.default
        notiCenter.post(name: .tableDataReload3, object: nil)
    }
}

