//
//  ActionViewController.swift
//  ActionExtension
//
//  Created by admin on 2018/11/30.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {
    
    private var dataSource: AdDataSource!
    
    private let groupID = "group.jp.ac.osakac.cs.hisalab.adblock"
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = AdDataSource()
        
        saveButton.layer.cornerRadius = 5.0
        cancelButton.layer.cornerRadius = 5.0
    
        // UITableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(CustomCell.self, forCellReuseIdentifier: "cell")
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
                    
                    // URLからドメインを取得
                } else if let urlText = item as? String {
                    
                    let domainText = URL(string: urlText)?.host
                    // 取得したドメインを保存
                    self.dataSource.save(ad: Ad(domain: domainText!, state: false))
                }
            }
        }
        
    }
    
    // Viewを表示したときの処理
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 取得した広告ドメインを読み込む
        self.dataSource.load()
        // テーブルビューを更新
        tableView.reloadData()
    }
    
    // SaveButtonをタップした時の処理
    func saveButtonAlert() {
        
        // 登録済み広告ドメインを保持
        let addedList = dataSource.retrieveAcquiredAd()
        print(addedList.last!)
        
        // 取得した広告ドメインを読み込み
        dataSource.load()
        let getDomain = dataSource.data(at: 0)?.domain
        
        // 登録済みの場合 (重複アラート)
        if addedList.contains(getDomain!) {
            
            let alert = UIAlertController(title: getDomain!, message: "It is already registered public domain", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler:
                {
                    action in
                    
                    self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
            }))
            
            // アラート表示
            self.present(alert, animated: true, completion: nil)
        }
        
        // 登録済みでない場合 (登録アラート)
        if !addedList.contains(getDomain!) {
            
            // 取得した広告ドメインをホストアプリに共有する
            self.dataSource.shareDomainToHostApp()
            
            let alert = UIAlertController(title: getDomain!, message: "Saved Successfully", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler:
                { action in
                    
                    self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
            }))
            
            // アラート表示
            self.present(alert, animated: true, completion: nil)
        }
        
    }

    @IBAction func CancelButtonTaped(_ sender: UIButton) {
        
        // Action Extensionを閉じる
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }
    
    @IBAction func saveButtonTaped(_ sender: UIButton) {
        
        saveButtonAlert()
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomCell
        cell.Ad = dataSource.data(at: indexPath.row)
        
        return cell
    }
    
}
