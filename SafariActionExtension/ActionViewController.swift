//
//  ActionViewController.swift
//  SafariActionExtension
//
//  Created by admin on 2018/08/22.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {
    // App Groups
    private let suiteName: String = "group.jp.ac.osakac.cs.hisalab.adblock"
    private let keyName: String = "shareData"
    
    // UILabel
    @IBOutlet weak var getDomain: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // アイテムの取得
        guard let item = self.extensionContext?.inputItems.first as? NSExtensionItem else { return }
        guard let itemProvider = item.attachments?.first as? NSItemProvider else { return }
        
        // Uniform Type Identifier(UTI)
        let publicURL = kUTTypeURL as String
        // アイテムからURLを取得
        if itemProvider.hasItemConformingToTypeIdentifier(publicURL) {
            itemProvider.loadItem(forTypeIdentifier: publicURL, options: nil)
            {
                [weak self] (item, error) in
                // エラー処理
                if let error = error {
                    self?.extensionContext?.cancelRequest(withError: error)
                    
                // URLを取得した時の処理
                } else if let url = item as? NSURL {
                    let domain = url.host
                    self?.getDomain.text = domain
                    print(domain!)
                }
            }
        }
    }
    
    // Cancelボタンの処理
    @IBAction func cancel() {
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }
    
    // Saveボタンの処理
    @IBAction func save(_ sender: UIBarButtonItem) {
        self.saveDomain()
    }
    
    // ドメインの追加を行うメソッド
    func saveDomain() {
        // 追加したドメインリスト
        var addList = [String]()
        let defaults = UserDefaults.standard
        
        // 保存されたデータを取得
        if defaults.object(forKey: "AddList") != nil {
            addList = defaults.object(forKey: "AddList") as! [String]
        }
        
        // 追加するドメインがリストにない場合
        if addList.index(of: self.getDomain.text!) == nil {
            // リストに追加
            addList.append(self.getDomain.text!)
            // addListを保存
            defaults.set(addList, forKey: "AddList")
            
            // データの保存(Hostアプリに共有)
            let shareDefaults = UserDefaults(suiteName: suiteName)!
            shareDefaults.set(self.getDomain.text!, forKey: keyName)
            
            /* アラートシートの設定 */
            let alertLanguage = (firstLang().hasPrefix("ja")) ? "保存しました" : "Saved Successfully"
            let alert = UIAlertController(title: self.getDomain.text!, message: alertLanguage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in print("OK")}))
            
            // アラート表示
            self.present(alert, animated: true, completion: nil)
            
            // 追加するドメインがリストにある場合
        } else {
            /* アラートシートの設定 */
            let alertLanguage = (self.firstLang().hasPrefix("ja")) ? "既に登録済されています" : "That has already been recorded domain"
            let alert = UIAlertController(title: self.getDomain.text!, message: alertLanguage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler:
                {
                    action in
                    
                    self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
                    
                }))
            
            // アラート表示
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //端末で設定された先頭の言語を受け取るメソッド
    func firstLang() -> String {
        // 設定された言語の先頭を取得
        let prefLang = Locale.preferredLanguages.first
        return prefLang!
    }
    
}
