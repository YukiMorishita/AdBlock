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
        
        // インスタンス生成
        dataSource = OthersListDataSource()
        jsonManager = JSONManager()
        blockerManager = ContentBlockerManager()
        
        // リストを読み込む
        dataSource.loadList()
        
        // othersListを保持
        let othersLists = dataSource.getOthersList()
        // タップしたtableSwitchのsection番号を保持 (section0からスタート)
        var sectionIndex: Int = -1
        // タップしたtableSwitchの要素番号を保持
        var switchIndex: Int?
        
        // sectionとタップしたtableSwitchの番号を取得
        for list in othersLists! {
            // 要素がnilならば
            if switchIndex == nil {
                // リストからタップしたラベルの文字列を検索し、その要素番号を取得
                switchIndex = list.findIndex(includeElement: { $0.text == tableLabel.text } ).filter { $0 >= 0 }.first
                // リストを数えることで、section番号を取得
                sectionIndex += 1
            }
        }
        
        // tableSwitchの状態を変更し、保存
        dataSource.changeSwitchState(at: sectionIndex, at: switchIndex!)
        
        // 共有ファイルの生成
        
        // Content Blocker Extensionの更新
        //blockerManager.reloadContentBlocker()
    }
    
}
