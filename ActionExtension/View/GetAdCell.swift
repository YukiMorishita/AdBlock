//
//  GetAdCell.swift
//  ActionExtension
//
//  Created by admin on 2018/10/15.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
import UIKit

final class GetAdCell: UITableViewCell {
    
    fileprivate var dataSource: GetAdDataSource!
    
    // UI
    private var domainLabel: UILabel!
    private var tableSwitch: UISwitch!
    
    var getAd: GetAd? {
        
        didSet {
            
            guard let ad = getAd else { return }
            
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
        
        print( "tapped switch")
        
        // インスタンスの生成
        dataSource = GetAdDataSource()
        
        // リストを読み込み
        dataSource.load()
        
        // スイッチの状態を変更して保存
        dataSource.changeSwitchState(at: 0)
    }
    
}
