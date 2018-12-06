//
//  Sub3CustomCell.swift
//  adblock-test
//
//  Created by admin on 2018/11/26.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import Foundation
import FirebaseDatabase

class Sub3CustomCell: UITableViewCell {
    
    private var dataSource: Sub3DataSource!
    private var jsonManager: JsonManager!
    
    private var tableLabel: UILabel!
    private var tableRateLabel: UILabel!
    
    private var starButton1: UIImage!
    private var starButton2: UIImage!
    private var starButton3: UIImage!
    private var starButton4: UIImage!
    private var starButton5: UIImage!
    
    private var button1: UIButton!
    private var button2: UIButton!
    private var button3: UIButton!
    private var button4: UIButton!
    private var button5: UIButton!
    
    private var moreLabel: UILabel!
    private var downloadButton: UIButton!
    
    var shareList: DataSnapshot? {
        
        didSet {
            guard let share = self.shareList else { return }
            
            tableLabel.text = share.childSnapshot(forPath: "name").value as? String
            tableRateLabel.text = share.childSnapshot(forPath: "rates").value as? String
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // UILabel
        tableLabel = UILabel()
        tableLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        tableLabel.font = .systemFont(ofSize: 20)
        self.contentView.addSubview(tableLabel)
        
        // UILabel
        tableRateLabel = UILabel()
        tableRateLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        tableRateLabel.font = .systemFont(ofSize: 14)
        self.contentView.addSubview(tableRateLabel)
        
        // UILabel
        moreLabel = UILabel()
        moreLabel.text = "more"
        moreLabel.textColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        moreLabel.font = .systemFont(ofSize: 10)
        self.contentView.addSubview(moreLabel)
        
        
        // ダウンロードボタン
        downloadButton = UIButton()
        downloadButton.setTitle("Download", for: .normal)
        downloadButton.setTitleColor(.white, for: .normal)
        downloadButton.backgroundColor = #colorLiteral(red: 0.2697268039, green: 0.7297354355, blue: 0.8500519453, alpha: 1)
        downloadButton.layer.cornerRadius = 10.0
        downloadButton.layer.shadowRadius = 20.0
        downloadButton.addTarget(self, action: #selector(downloadButtonTaped), for: .touchUpInside)
        downloadButton.setTitle("押されました", for: UIControl.State.highlighted)
        self.contentView.addSubview(downloadButton)
        
        // 評価ボタン
        let image0 = UIImage(named: "star-off-icon")
        //let image1 = UIImage(named: "star-on-icon")
        
        // 初期はオフ
        starButton1 = image0
        starButton2 = image0
        starButton3 = image0
        starButton4 = image0
        starButton5 = image0
        
        button1 = UIButton()
        button2 = UIButton()
        button3 = UIButton()
        button4 = UIButton()
        button5 = UIButton()
        
        button1.setImage(starButton1, for: .normal)
        button2.setImage(starButton2, for: .normal)
        button3.setImage(starButton3, for: .normal)
        button4.setImage(starButton4, for: .normal)
        button5.setImage(starButton5, for: .normal)
        
        button1.imageView?.contentMode = .scaleAspectFit
        button2.imageView?.contentMode = .scaleAspectFit
        button3.imageView?.contentMode = .scaleAspectFit
        button4.imageView?.contentMode = .scaleAspectFit
        button5.imageView?.contentMode = .scaleAspectFit
        
        button1.tag = 1
        button2.tag = 2
        button3.tag = 3
        button4.tag = 4
        button5.tag = 5
        
        button1.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        button2.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        button3.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        button4.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        button5.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        
        self.contentView.addSubview(button1)
        self.contentView.addSubview(button2)
        self.contentView.addSubview(button3)
        self.contentView.addSubview(button4)
        self.contentView.addSubview(button5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tableLabel.frame = CGRect(x: 33, y: 21, width: 220, height: 21)
        tableRateLabel.frame = CGRect(x: 30, y: 12, width: 220, height: 21)
        
        button1.frame = CGRect(x: 20, y: 50, width: 30, height: 30)
        button2.frame = CGRect(x: 50, y: 50, width: 30, height: 30)
        button3.frame = CGRect(x: 80, y: 50, width: 30, height: 30)
        button4.frame = CGRect(x: 110, y: 50, width: 30, height: 30)
        button5.frame = CGRect(x: 140, y: 50, width: 30, height: 30)
        
        moreLabel.frame = CGRect(x: 340, y: 75, width: 42, height: 21)
        downloadButton.frame = CGRect(x: 230, y: 30, width: 120, height: 40)
    }
    
    func ratingAverage() {
        
//        let rate = [Int]()
//
//
//        
//        let rateStr = ""
//        let rateData = [starButton1, starButton2, starButton3, starButton4, starButton5]
//
//        print(rateData.map { $0 == UIImage(named: "star-on-icon")}.last! )
        
        //return rateStr
    }
    
    @objc func buttonTapped(sender : UIButton) {
        
        let image0 = UIImage(named: "star-off-icon")
        let image1 = UIImage(named: "star-on-icon")?.tint(color: #colorLiteral(red: 1, green: 0.9827856562, blue: 0.6425816047, alpha: 1))
        
        if sender.tag == 5 {
            
            if sender.currentImage == image0 {
                
                button1.setImage(image1, for: .normal)
                button2.setImage(image1, for: .normal)
                button3.setImage(image1, for: .normal)
                button4.setImage(image1, for: .normal)
                button5.setImage(image1, for: .normal)
            }
        }
        
        if sender.tag == 4 {
            
            if sender.currentImage == image0 {
                
                button1.setImage(image1, for: .normal)
                button2.setImage(image1, for: .normal)
                button3.setImage(image1, for: .normal)
                button4.setImage(image1, for: .normal)
            } else {
                
                button5.setImage(image0, for: .normal)
            }
        }
        
        if sender.tag == 3 {
            
            if sender.currentImage == image0 {
                
                button1.setImage(image1, for: .normal)
                button2.setImage(image1, for: .normal)
                button3.setImage(image1, for: .normal)
            } else {
                
                button4.setImage(image0, for: .normal)
                button5.setImage(image0, for: .normal)
            }
        }
        
        if sender.tag == 2 {
            
            if sender.currentImage == image0 {
                
                button1.setImage(image1, for: .normal)
                button2.setImage(image1, for: .normal)
            } else {
                
                button3.setImage(image0, for: .normal)
                button4.setImage(image0, for: .normal)
                button5.setImage(image0, for: .normal)
            }
        }
        
        if sender.tag == 1 {
            
            if sender.currentImage == image0 {
                
                button1.setImage(image1, for: .normal)
            } else {
                
                button2.setImage(image0, for: .normal)
                button3.setImage(image0, for: .normal)
                button4.setImage(image0, for: .normal)
                button5.setImage(image0, for: .normal)
            }
        }
        
        // UITableViewを更新 (通知を送る)
        let notiCenter = NotificationCenter.default
        notiCenter.post(name: .starButtonTapedAlert, object: nil)
    }
    
    @objc func downloadButtonTaped() {
    
        print("downloadButton taped")
    }
    
    @objc private func tapedSwitch(sender: UISwitch) {
        
        print("taped Switch")
        
        dataSource = Sub3DataSource()
        jsonManager = JsonManager()
        
        
        
        // UITableViewを更新 (通知を送る)
        let notiCenter = NotificationCenter.default
        notiCenter.post(name: .tableDataReload4, object: nil)
    }
}

extension UIImage {
    func tint(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        let drawRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIRectFill(drawRect)
        draw(in: drawRect, blendMode: .destinationIn, alpha: 1)
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tintedImage!
    }
}
