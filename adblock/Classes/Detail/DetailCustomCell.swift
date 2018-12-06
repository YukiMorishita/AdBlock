//
//  DetailCustomCell.swift
//  adblock
//
//  Created by admin on 2018/12/05.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import Foundation

class DetailCustomCell: UITableViewCell {
    
    private var fileNameLabel: UILabel!
    private var ratingLabel: UILabel!
    private var downloadButton: UIButton!
    
    var detailData: Detail? {
        
        didSet {
            guard let detail = self.detailData else { return }
            
            self.fileNameLabel.text = detail.filename
            self.ratingLabel.text = String( detail.rating.reduce(0, { $0 + $1 }) )
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        fileNameLabel = UILabel()
        fileNameLabel.textColor = .black
        fileNameLabel.font = .systemFont(ofSize: 20)
        self.contentView.addSubview(fileNameLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
