//
//  Domain.swift
//  adblock-test
//
//  Created by admin on 2018/11/26.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation

final class Domain {
    
    var domain: String
    var state: Bool
    
    init(domain: String, state: Bool) {
        
        self.domain = domain
        self.state = state
    }
}
