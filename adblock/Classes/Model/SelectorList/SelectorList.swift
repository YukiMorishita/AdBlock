//
//  Selector.swift
//  adblock
//
//  Created by admin on 2018/10/15.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation

final class SelectorList {
    
    var selector: String
    var state : Bool
    
    init(selector: String, state: Bool) {
        self.selector = selector
        self.state = state
    }
    
}
