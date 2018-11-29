//
//  CustomCell.swift
//  ActionExtension
//
//  Created by admin on 2018/11/17.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import Foundation

class CustomCell: UITableViewCell {
    
    private var dataSource: AdDataSource!
    
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
        
        dataSource = AdDataSource()
        
        dataSource.load()
        // スイッチの状態を変更
        dataSource.changeSwitchState()
    }
    
}
