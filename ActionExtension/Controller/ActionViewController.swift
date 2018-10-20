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
    private let key = "share"
    
    fileprivate var dataSource: GetAdDataSource!
    fileprivate var jsonManager: JSONManager!
    
    // UI
    fileprivate var navigationBar: UINavigationBar!
    fileprivate var tableView: UITableView!
    fileprivate var tableSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // インスタンスの生成
        dataSource = GetAdDataSource()
        jsonManager = JSONManager()
        
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
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(GetAdCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        
        // URL文字列の取得
        guard let item = self.extensionContext?.inputItems.first as? NSExtensionItem else { return }
        guard let itemProvider = item.attachments?.first else { return }
        
        // Uniform Type Identifier(UTI)
        let publicText = kUTTypeText as String
        
        // 文字列でURLを取得
        if itemProvider.hasItemConformingToTypeIdentifier(publicText) {
            itemProvider.loadItem(forTypeIdentifier: publicText, options: nil)
            {
                (item, error) in
                
                // エラー処理
                if let error = error {
                    self.extensionContext?.cancelRequest(withError: error)
                    
                    // URL文字列を取得できた場合
                } else if let URLText = item as? String {
                    
                    // URLからドメインを取得
                    let domainText = URL(string: URLText)?.host
                    // ドメインを保存
                    self.dataSource.save(acquiredAd: GetAd(domain: domainText!, state: false))
                }
            }
        }
        
    }
    
    // Viewを表示したときの処理
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // リストを読み込み
        self.dataSource.load()
        // テーブルビューを更新
        tableView.reloadData()
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
    
    // 保存時のアラート処理
    func saveAlert() {
        
        // 登録済み広告ドメインを保持
        var addedList = [String]()
        // 登録済み広告ドメインの確認
        let defaults = UserDefaults(suiteName: groupID)
        
        // ホストアプリに広告ドメインリストがあれば
        if (defaults?.object(forKey: "adList") != nil) {
            
            // 登録済み広告リストを取得
            let adListDictionaries = defaults?.object(forKey: "adList") as? [[String: Any]]
            guard let ads = adListDictionaries else { return }
            // 取得した広告リストを設定
            let adList = ads.map { GetAd(domain: $0["domain"] as! String, state: $0["state"] as! Bool) }
            // 取得した広告リストから広告ドメインを取得
            addedList = adList.map { $0.domain }
        }
        
        // 取得した広告ドメインを読み込み
        dataSource.load()
        
        // 登録済みの場合 (重複アラート)
        if addedList.contains((dataSource.data(at: 0)?.domain)!) {
            
            /* アラートシートの設定 */
            //let alertLanguage = (firstLang().hasPrefix("ja")) ? "保存しました" : "Saved Successfully"
            let alert = UIAlertController(title: "test", message: "保存済み", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler:
                {
                    action in
                    
                    self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
            }))
            
            // アラート表示
            self.present(alert, animated: true, completion: nil)
        }
        
        // 登録済みでない場合
        if !addedList.contains((dataSource.data(at: 0)?.domain)!) {
            
            // 取得した広告ドメインをホストアプリに共有する
            self.dataSource.shareDomain()
            
            /* アラートシートの設定 */
            //let alertLanguage = (firstLang().hasPrefix("ja")) ? "保存しました" : "Saved Successfully"
            let alert = UIAlertController(title: "test", message: "Saved Successfully", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler:
                { action in
                    
                    self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
            }))
            
            // アラート表示
            self.present(alert, animated: true, completion: nil)
        }
        
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
        saveAlert()
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
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! GetAdCell
        cell.getAd = dataSource.data(at: indexPath.row)
        
        return cell
    }
}

