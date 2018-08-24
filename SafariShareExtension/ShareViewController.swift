//
//  ShareViewController.swift
//  SafariShareExtension
//
//  Created by admin on 2018/08/22.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices

class ShareViewController: SLComposeServiceViewController {
    
    // App Groups
    let suiteName = "group.jp.ac.osakac.cs.hisalab.adblock"
    let keyName = "shareData"
    
    //
    var domain = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* ShareExtenisonのUI設定 */
        self.title = "Ads Block"
        
        // UI色
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 1.0, green: 0.75, blue: 0.5, alpha: 1.0)

        // ボタンの設定
        let controller = self.navigationController!.viewControllers.first!
        controller.navigationItem.rightBarButtonItem!.title = "Save"
        controller.navigationItem.leftBarButtonItem!.title = "Cancel"
        
        // URLの取得
        self.getURL()
        
        let switchButton = UISwitch()
        switchButton.layer.position = CGPoint(x: 150, y: 80.0)

        self.textView.addSubview(switchButton)
    }
    
    override func isContentValid() -> Bool {
        self.charactersRemaining = self.contentText.count as NSNumber
        
        // 文字が入力されていれば
        let canPost: Bool = self.contentText.count > 0
        if canPost {
            return true
        }
        return false
    }
    
    override func didSelectPost() {
        guard let item = self.extensionContext?.inputItems.first as? NSExtensionItem else { return }
        guard let itemProvider = item.attachments?.first as? NSItemProvider else { return }
        
        // Uniform Type Identifier(UTI)
        let publicURL = kUTTypeURL as String
        // アイテムからURLを取得
        if itemProvider.hasItemConformingToTypeIdentifier(publicURL) {
            itemProvider.loadItem(forTypeIdentifier: publicURL, options: nil)
            {
                (item, error) in
                // エラー処理
                if let error = error {
                    self.extensionContext?.cancelRequest(withError: error)
                    
                } else if let url = item as? NSURL {
                    // Hostアプリとデータの共有
                    self.getURLToDomain(url: url)
                }
            }
        }
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }
    
    override func configurationItems() -> [Any]! {
        return []
    }
    
    func getURL() {
        // URLを取得
        guard let item = self.extensionContext?.inputItems.first as? NSExtensionItem else { return }
        guard let itemProvider = item.attachments?.first as? NSItemProvider else { return }
        
        // Uniform Type Identifier(UTI)
        let publicURL = kUTTypeURL as String
        // アイテムからURLを取得
        if itemProvider.hasItemConformingToTypeIdentifier(publicURL) {
            itemProvider.loadItem(forTypeIdentifier: publicURL, options: nil)
            {
                (item, error) in
                // エラー処理
                if let error = error {
                    self.extensionContext?.cancelRequest(withError: error)
                    
                } else if let url = item as? NSURL {
                    // Hostアプリとデータの共有
                    self.getURLToDomain(url: url)
                }
            }
        }
    }
    
    // 取得したURLからドメインへ変換し、Hostアプリに共有するメソッド
    func getURLToDomain(url: NSURL) {
        // 取得したURLからドメインを設定
        self.domain = url.host!
        
        // 表示するテキスト
        self.PostText(text: domain)
        
        // データの保存(Hostアプリに共有)
        let shareDefaults = UserDefaults(suiteName: suiteName)!
        shareDefaults.set(domain, forKey: keyName)
    }
    
    // コントローラーのテキストビューの設定を行うメソッド
    func PostText(text: String) {
        // 表示するテキスト
        self.textView.text = "TARGET SITE" + " : " + text
        // テキストの編集を不可
        self.textView.isEditable = false
    }
    
}
