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
    
    private var domainLabel: UILabel!
    private var tableSwitch: UISwitch!
    
    var domainText: String = "" // adList内を検索する再の引数を保持
    var switchButton: Bool = false // Switchの状態を保持
    
    var adList: AdList? {
        
        didSet {
            guard let ad = adList else { return }
            
            domainText = ad.domain
            switchButton = ad.switchState
            
            domainLabel.text = ad.domain
            tableSwitch.isOn = ad.switchState
        }
    }
    
    var searchResults: AdList? {
        
        didSet {
            guard let ad = searchResults else { return }
            
            domainText = ad.domain
            switchButton = ad.switchState
            
            domainLabel.text = ad.domain
            tableSwitch.isOn = ad.switchState
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
        tableSwitch.addTarget(self, action: #selector(trriger(sender:)), for: .valueChanged)
        
        // スイッチの状態を設定
        if switchButton == true {
            tableSwitch.isOn = true
        }
        
        if switchButton == false {
            tableSwitch.isOn = false
        }
        contentView.addSubview(tableSwitch)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        domainLabel.frame = CGRect(x: 15, y: 11, width: contentView.frame.size.width, height: 21)
        tableSwitch.frame = CGRect(x: contentView.frame.size.width - 60, y: 6, width: 49, height: 31)
    }
    
    @objc private func trriger(sender: UISwitch) {
        
        dataSource = AdListDataSource()
        // AdListから引数であるドメインを検索、その後、要素番号を取得し、保存
        dataSource.switchStateDidChangeAdList(domain: domainText)
    }
    
}
