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
    
}
