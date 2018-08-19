//
//  ShareViewController.swift
//  ShareURL
//
//  Created by admin on 2018/08/03.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices

class ShareViewController: SLComposeServiceViewController {
    // App Groups
    let suiteName: String = "group.jp.ac.osakac.cs.hisalab.adblock"
    let keyName: String = "shareData"
    
    // 取得したドメイン
    var domain: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // タイトル名
        self.title = "ブロックリスト追加"
        
        // UI色
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.backgroundColor = UIColor(red:1.0, green:0.75, blue:0.5, alpha:1.0)
        
        // postName
        let controller: UIViewController = self.navigationController!.viewControllers.first!
        // 右側のバーボタンアイテム名を設定
        controller.navigationItem.rightBarButtonItem!.title = "追加"
        // 左側のバーボタンアイテム名を設定
        controller.navigationItem.leftBarButtonItem!.title = "キャンセル"
    }
    
    // 文字が入力されていない場合ポストを無効にするメソッド
    override func isContentValid() -> Bool {
        self.charactersRemaining = self.contentText.count as NSNumber
        
        // 入力文字が0以上ならば
        let canPost: Bool = self.contentText.count > 0
        if canPost {
            return true
        }
        return false
    }
    
    // ポストを押した時のメソッド
    override func didSelectPost() {
        let extensionItem: NSExtensionItem = self.extensionContext?.inputItems.first as! NSExtensionItem
        let itemProvider = extensionItem.attachments?.first as! NSItemProvider
        
        let puclicURL = String(kUTTypeURL)  // "public.url"
        
        // shareExtension で NSURL を取得
        if itemProvider.hasItemConformingToTypeIdentifier(puclicURL) {
            itemProvider.loadItem(forTypeIdentifier: puclicURL, options: nil, completionHandler: { (item, error) in
                // NSURLを取得する
                if let url: NSURL = item as? NSURL {
                    //print("url: \(url)") // https://www.google.co.jp/?sa=X...
                    // NSURL型をString型にキャスト
                    let stringURL: String = url.absoluteString!
                    
                    // String型をNSURL型にキャストできた場合
                    if let component: NSURLComponents = NSURLComponents(string: stringURL) {
                        // URLからドメインのみを取得
                        self.domain = component.host!
                        print(self.domain) // www.google.co.jp
                    }
                    
                    // 保存処理
                    let sharedDefaults: UserDefaults = UserDefaults(suiteName: self.suiteName)!
                    // ドメインを保存
                    sharedDefaults.set(self.domain, forKey: self.keyName)
                    
                }
            })
            
        } else {
            // 表示された文字列
            let contentText = self.contentText // https://www.google.co.jp/?sa=X...
            // String型の文字列をNSURL型にキャスト
            let component: NSURLComponents = NSURLComponents(string: contentText!)!
            // NSURL型のドメインをString型にキャスト
            self.domain = component.host!
            print(self.domain) // www.google.co.jp
            
            // 保存処理
            let sharedDefaults: UserDefaults = UserDefaults(suiteName: self.suiteName)!
            // ドメインを保存
            sharedDefaults.set(self.domain, forKey: self.keyName)
        }
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }
    
    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }
    
}
