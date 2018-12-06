//
//  Detail.swift
//  adblock
//
//  Created by admin on 2018/12/05.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation

final class Detail {
    
    var filename: String
    var rating = [Int]()
    var domains = [String]()
    var comments = [String]()
    
    init(filename: String, rating: [Int], domains: [String], comments: [String]) {
        
        self.filename = filename
        self.rating = rating
        self.domains = domains
        self.comments = comments
    }
    
}
