//
//  MainViewController.swift
//  adblock
//
//  Created by admin on 2018/08/21.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var contentBlockerStateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // NotificationCenterに登録する
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(contentBlockerStateLabelDidChange(notification:)), name: .myNotificationName2, object: nil)
        
        // Labelに文字列を設定
        //contentBlockerStateLabelDidChange()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // ContentBlocker状態をラベルに設定
    @objc func contentBlockerStateLabelDidChange(notification: Notification) {
        // コンテンツブロッカーを更新
        ContentBlockerManager.reloadContentBlocker()
        ContentBlockerManager.stateContentBlocker()
        
        // コンテンツブロッカーの状態を設定
        let defaults = UserDefaults.standard
        let state = defaults.bool(forKey: "State")
        // 状態に応じて、テキストを設定
        self.contentBlockerStateLabel.text = (state == true) ? "Enable" : "Disable"
    }

}
