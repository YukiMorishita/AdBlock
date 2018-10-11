//
//  AdList.swift
//  adblock
//
//  Created by admin on 2018/10/03.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation

final class AdList {
    
    // プロパティ
    var domain: String
    var switchState: Bool
    
    // イニシャライザメソッド
    init (domain: String, switchState: Bool) {
        self.domain = domain
        self.switchState = switchState
    }
    
    // 引数のdictionaryからAdListを生成するイニシャライザ
    // UserDefaultsで保存したdictionaryから生成
    init (from dictionary: [String: Any]) {
        self.domain = dictionary["domain"] as! String
        self.switchState = dictionary["switchState"] as! Bool
    }
    
}
