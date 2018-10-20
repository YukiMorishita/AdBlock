//
//  OthersListCell.swift
//  adblock
//
//  Created by admin on 2018/10/14.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
import UIKit

final class OthersListCell: UITableViewCell {
    
    fileprivate var dataSource: OthersListDataSource!
    fileprivate var jsonManager: JSONManager!
    fileprivate var blockerManager: ContentBlockerManager!
    
    private var tableLabel: UILabel!
    private var tableSwitch: UISwitch!
    
    var othersList: OthersList? {
        
        didSet {
            
            guard let other = othersList else { return }
            
            // UILabelの文字列を設定
            tableLabel.text = other.text
            // UISwitchの状態を設定
            tableSwitch.isOn = other.state
        }
    }
    
    override init (style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // UILabel
        tableLabel = UILabel()
        tableLabel.textColor = UIColor.black
        tableLabel.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(tableLabel)
        
        // UISwitch
        tableSwitch = UISwitch()
        tableSwitch.onTintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        tableSwitch.addTarget(self, action: #selector(trigger(sender:)), for: .valueChanged)
        
        contentView.addSubview(tableSwitch)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // SunViewのレイアウトを設定
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tableLabel.frame = CGRect(x: 15, y: 11, width: contentView.frame.size.width, height: 21)
        tableSwitch.frame = CGRect(x: contentView.frame.size.width - 60, y: 6, width: 49, height: 31)
    }
    
    @objc private func trigger(sender: UISwitch) {
        
        print("Taped Switch")
        print(tableLabel.text!)
        print(tableSwitch.isOn)
        
        // インスタンス生成
        dataSource = OthersListDataSource()
        jsonManager = JSONManager()
        blockerManager = ContentBlockerManager()
        
//        // adListSrcを読み込み
//        dataSource.defaultsLoadAdList()
//
//        // ドメインリスト生成
//        let domainList = dataSource.getList().map { $0.domain }
//        // domainList内から検索ドメインの要素番号を取得
//        let index = domainList.findIndex(includeElement: { $0 == domainLabel.text })
//        // スイッチの状態を変更して保存
//        dataSource.changeSwitchState(at: index[0])
//
//        // 共有ファイルを生成
//        jsonManager.createJsonFile(adList: dataSource.getAdList())
//
//        // Content Blockerを更新
//        blockerManager.reloadContentBlocker()
    }
    
}
