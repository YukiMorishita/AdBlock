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
    var state: Bool
    
    // イニシャライザメソッド
    init (domain: String, state: Bool) {
        self.domain = domain
        self.state = state
    }
    
    // 引数のdictionaryからAdListを生成するイニシャライザ
    // UserDefaultsで保存したdictionaryから生成
    init (from dictionary: [String: Any]) {
        self.domain = dictionary["domain"] as! String
        self.state = dictionary["state"] as! Bool
    }
    
}
