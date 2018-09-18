//
//  PageMenuViewController.swift
//  adblock
//
//  Created by admin on 2018/08/22.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class PageMenuViewControlle: UIViewController, CAPSPageMenuDelegate {
    
    var pageMenu: CAPSPageMenu?
    
    // UiNavigationBarItem
    @IBOutlet weak var navigationBarItem: UINavigationItem!
    
    /* Action */
    // ナビゲーションバーの左側のボタンがタップされた時
    @IBAction func menuButton(_ sender: UIBarButtonItem) {
        // 左画のメニューを開く
        self.slideMenuController()?.openLeft()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        /* スイッチ操作ボタンの設定 */
        let switchsStateButton = UIBarButtonItem()
        // イメージの設定
        let swichsStateButtonImage = UIImage(named: "switch-icon")
        switchsStateButton.image = swichsStateButtonImage
        // カラーの設定
        switchsStateButton.tintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        // タップ時の処理設定
        switchsStateButton.action = #selector(switchsStateButtonTriggerd)
        
        // ナビゲーションバーの右側に設定
        self.navigationBarItem.rightBarButtonItem = switchsStateButton
        rightBarButtonItemDisable()
        
        
        /* PageMenu */
        let vc1 =  storyboard?.instantiateViewController(withIdentifier: "Main")//UIViewController() // 初期のビュー
        vc1?.title = "Home"
        let vc2 = storyboard?.instantiateViewController(withIdentifier: "Ads")
        vc2?.title = "Ads Block"
        let vc3 = storyboard?.instantiateViewController(withIdentifier: "Advance")
        vc3?.title = "Advanced Block"
        
        // パラーメーターの設定
        let parameters: [CAPSPageMenuOption] = [
            .scrollMenuBackgroundColor(UIColor.black),
            .selectionIndicatorColor(UIColor.orange),
            .bottomMenuHairlineColor(UIColor.black),
            .menuHeight(30.0),
            .menuItemSeparatorWidth(0.0),
            .useMenuLikeSegmentedControl(true),
            .menuItemSeparatorPercentageHeight(0.1)
        ]
        
        // 表示位置
        let rect = CGRect(x: 0, y: 60, width: self.view.bounds.width, height: self.view.bounds.height)
        // 表示
        pageMenu = CAPSPageMenu(viewControllers: [vc1!, vc2!, vc3!], frame: rect, pageMenuOptions: parameters)
        self.view.addSubview(pageMenu!.view)
        
        // デリゲートの設定
        pageMenu?.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // ビューを移動後に呼ばれるメソッド
    func didMoveToPage(_ controller: UIViewController, index: Int) {
        switch index {
        case 0:
            rightBarButtonItemDisable()
        case 1:
            rightBarButtonItemEnable()
        case 2:
            rightBarButtonItemEnable()
        default:
            rightBarButtonItemDisable()
        }
    }
    
    // ボタンの有効化
    func rightBarButtonItemEnable() {
        // ボタン無効化
        self.navigationBarItem.rightBarButtonItem?.isEnabled = true
        // ボタン非表示
        self.navigationBarItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
    }
    
    // ボタンの無効化
    func rightBarButtonItemDisable() {
        // ボタン無効化
        self.navigationBarItem.rightBarButtonItem?.isEnabled = false
        // ボタン非表示
        self.navigationBarItem.rightBarButtonItem?.tintColor = UIColor(white: 0, alpha: 0)
    }
    
    // スイッチの状態変更ボタンをタップした時のコールバック
    @objc func switchsStateButtonTriggerd(sender: UIBarButtonItem) {
        var adList = [(text: String, switchs: Bool)]()
        // ユーザデフォルトのキー
        let defaultsKey = "adList"
        
        // 保存されたデータし取得処理
        if let loadData = AppGroupsManager.loadData(key: defaultsKey) {
            adList = loadData.map { (text: $0["text"], switchs: $0["switchs"]) } as! [(text: String, switchs: Bool)]
        } else {
            print("not data")
        }
        
        /* アラートシートの設定 */
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        // アラートシートのボタンを設定
        let Enable = UIAlertAction(title: "Enable All", style: .default)
        {
            (action: UIAlertAction) in
            // 以下Enableボタンがタップされた時の処理
            
            // adListのテキストを保存
            let textData = adList.map { $0.text }
            // リセット
            adList.removeAll()
            // データの書き換え
            for text in textData {
                adList.append( (text: text, switchs: true) )
            }
            
            // データの保存
            let saveData: [[String: Any]] = adList.map { ["text": $0.text, "switchs": $0.switchs] }
            AppGroupsManager.saveData(data: saveData, key: "adList")
            
            /* JSON */
            // 共有ファイルにJSON文字列を書き込む
            JSONManager.createJSONFile(adList: adList)
            
            
            // テーブルビューを更新
            let notificationCenter = NotificationCenter.default
            notificationCenter.post(name: .myNotificationName, object: nil)
            
            // コンテンツブロッカーを更新
            ContentBlockerManager.reloadContentBlocker()
        }
        
        let Disable = UIAlertAction(title: "Disable All", style: .default)
        {
            (action: UIAlertAction) in
            // 以下Enableボタンがタップされた時の処理
            
            // adListのテキストを保存
            let textData = adList.map { $0.text }
            // リセット
            adList.removeAll()
            // データの書き換え
            for text in textData {
                adList.append( (text: text, switchs: false) )
            }
            
            // データの保存
            let saveData: [[String: Any]] = adList.map { ["text": $0.text, "switchs": $0.switchs] }
            AppGroupsManager.saveData(data: saveData, key: "adList")
            
            /* JSON */
            // 共有ファイルにJSON文字列を書き込む
            JSONManager.createJSONFile(adList: adList)
            
            // テーブルビューを更新
            let notificationCenter = NotificationCenter.default
            notificationCenter.post(name: .myNotificationName, object: nil)
            
            // コンテンツブロッカーを更新
            ContentBlockerManager.reloadContentBlocker()
        }
        
        let Cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // ボタンの追加
        alert.addAction(Enable)
        alert.addAction(Disable)
        alert.addAction(Cancel)
        
        // アラートシートの表示
        present(alert, animated: true, completion: nil)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension Notification.Name {
    static let myNotificationName = Notification.Name("TableUpdate")
    static let myNotificationName2 = Notification.Name("LabelStateUpdate")
}
