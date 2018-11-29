//
//  Sub1CustomCell.swift
//  adblock-test
//
//  Created by admin on 2018/11/17.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import Foundation

class Sub1CustomCell: UITableViewCell {
    
    private var dataSource: Sub1DataSource!
    private var jsonManager: JsonManager!
    private var contentBlockerManager: ContentBlockerManager!
    
    private var tableLabel: UILabel!
    private var tableSwitch: UISwitch!
    
    var advanceList: Advance? {
        
        didSet {
            guard let advance = self.advanceList else { return }
            
            tableLabel.text = advance.label
            tableSwitch.isOn = advance.state
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
        
        dataSource = Sub1DataSource()
        jsonManager = JsonManager()
        contentBlockerManager = ContentBlockerManager()
        
        // テーブルデータを取得
        dataSource.load()
        
        let label = tableLabel.text!
        let state = tableSwitch.isOn
        // UISwitchの状態を変更
        dataSource.changeSwitchState(label: label, state: state)
        dataSource.save()
        
        // 共有ファイル作成
        jsonManager.createAndWriteJsonFile()
        // Content Blocker Extension を更新
        contentBlockerManager.reloadContentBlocker()
        
        // UITableViewを更新 (通知を送る)
        let notiCenter = NotificationCenter.default
        notiCenter.post(name: .tableDataReload2, object: nil)
    }
}
