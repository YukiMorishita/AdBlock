//
//  AdListCell.swift
//  adblock
//
//  Created by admin on 2018/10/03.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
import UIKit

final class AdListCell: UITableViewCell {
    
    fileprivate var dataSource: AdListDataSource!
    fileprivate var jsonManager: JSONManager!
    fileprivate var blockerManager: ContentBlockerManager!
    
    private var domainLabel: UILabel!
    private var tableSwitch: UISwitch!
    
    var adList: AdList? {
        
        didSet {
            
            guard let ad = adList else { return }
            
            // UILabelの文字列を設定
            domainLabel.text = ad.domain
            // UISwitchの状態を設定
            tableSwitch.isOn = ad.state
        }
    }
    
    override init (style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // UILabel
        domainLabel = UILabel()
        domainLabel.textColor = UIColor.black
        domainLabel.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(domainLabel)
        
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
        
        domainLabel.frame = CGRect(x: 15, y: 11, width: contentView.frame.size.width, height: 21)
        tableSwitch.frame = CGRect(x: contentView.frame.size.width - 60, y: 6, width: 49, height: 31)
    }
    
    @objc private func trigger(sender: UISwitch) {
        
        // インスタンス生成
        dataSource = AdListDataSource()
        jsonManager = JSONManager()
        blockerManager = ContentBlockerManager()
        
        let notificationCenter = NotificationCenter.default
        
        // adListSrcを読み込み
        dataSource.defaultsLoadAdList()
        
        // ドメインリスト生成
        let domainList = dataSource.getList().map { $0.domain }
        // domainList内から検索ドメインの要素番号を設定
        let index = domainList.findIndex(includeElement: { $0 == domainLabel.text })
        // スイッチの状態を変更して保存
        dataSource.changeSwitchState(at: index[0])
        
        // テーブルビューを更新
        notificationCenter.post(name: .tableViewReload, object: nil)
        
        // 共有ファイルを生成
        jsonManager.createJsonFile(adList: dataSource.getAdList())
        
        // Content Blockerを更新
        blockerManager.reloadContentBlocker()
    }
    
}

extension Array {
    
    // 配列内の要素番号を取得するメソッド
    func findIndex(includeElement: (Element) -> Bool) -> [Int] {
        
        // 要素番号を格納する配列
        var indexArray = [Int]()
        for (index, element) in enumerated() {
            if includeElement(element) {
                indexArray.append(index)
            }
        }
        return indexArray
    }
}

extension Notification.Name {
    
    static let tableViewReload = Notification.Name("TableViewReload")
}
