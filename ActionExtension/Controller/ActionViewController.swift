//
//  ActionViewController.swift
//  ActionExtension
//
//  Created by admin on 2018/10/15.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {
    
    // AppGroups
    private let groupID = "group.jp.ac.osakac.cs.hisalab.adblock"
    private let key1 = "share"
    private let key2 = "add"
    
    fileprivate var dataSource: GetAdDataSource!
    
    // UI
    fileprivate var navigationBar: UINavigationBar!
    fileprivate var tableView: UITableView!
    fileprivate var tableSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = GetAdDataSource()
        
        // UI
        // 背景食
        self.view.backgroundColor = .white
        
        // UINavigationBar
        navigationBar = UINavigationBar()
        navigationBar.isTranslucent = false
        
        // UINavigationItem
        let navigationItem = UINavigationItem()
        navigationItem.title = "Add Ad Domain"
        
        // LeftButton (Cancelボタン)
        let leftNavBtn = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(leftBtnTaped(sender:)))
        navigationItem.leftBarButtonItem = leftNavBtn
        
        // RightButton (Saveボタン)
        let rightNavBtn = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(rightBtnTaped(sender:)))
        navigationItem.rightBarButtonItem = rightNavBtn
        
        // ボタンの設定
        navigationBar.pushItem(navigationItem, animated: true)
        self.view.addSubview(navigationBar)
        
        // UITableView
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(GetAdCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        
        
        // Extension
        // アイテムの取得
        guard let item = self.extensionContext?.inputItems.first as? NSExtensionItem else { return }
        guard let itemProvider = item.attachments?.first else { return }
        
        // Uniform Type Identifier(UTI)
        let publicText = kUTTypeText as String
        
        // 文字列でドメインを取得
        if itemProvider.hasItemConformingToTypeIdentifier(publicText) {
            itemProvider.loadItem(forTypeIdentifier: publicText, options: nil)
            {
                (item, error) in
                
                // エラー処理
                if let error = error {
                    self.extensionContext?.cancelRequest(withError: error)
                
                //
                } else if let domainText = item as? String {
                    let domain = URL(string: domainText)
                    print(domain!.host!)

                }
            }
        }
        
    }
    
    // SubViewのレイアウトを設定
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // UiViewの縦横サイズ
        let viewWidth = self.view.frame.size.width
        //let viewHeight = self.view.frame.size.height
        
        // UIのレイアウトを設定
        navigationBar.frame = CGRect(x: 0, y: 22, width: viewWidth, height: 40)
        
        tableView.frame = CGRect(x: 0, y: 67, width: viewWidth, height: 496)
    }
    
    // リストが重複した時のアラート処理
    func duplicateAlert() {
        
        // 共有ファイルからドメインリストを取得し、追加しようとしたドメインが追加済みかを確認
        //let addedList = [String]()
        
        // 追加済みでない場合
        //if addedList
        
        /* アラートシートの設定 */
        //let alertLanguage = (firstLang().hasPrefix("ja")) ? "保存しました" : "Saved Successfully"
        let alert = UIAlertController(title: "test", message: "Saved Successfully", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        // 追加済みの場合
        // if addedList
        
        // アラート表示
        self.present(alert, animated: true, completion: nil)
    }
    
    // UINavigationBar LeftButton タップ時の処理
    @objc func leftBtnTaped(sender: UIButton) {
        
        print("left Button Taped")
        
        // Extensionを終了する
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }
    
    // UINavigationBar RightButton タップ時の処理
    @objc func rightBtnTaped(sender: UIButton) {
        
        print("right Button Taped")
        
        // アラートの表示
        duplicateAlert()
        
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }
    
    
}

// MARK: - UITableView
extension ActionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44
    }
}

extension ActionViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataSource.acquiredAdCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! GetAdCell
        cell.getAd = dataSource.data(at: indexPath.row)
        
        return cell
    }
}

