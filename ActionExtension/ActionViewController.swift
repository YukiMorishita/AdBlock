//
//  ActionViewController.swift
//  ActionExtension
//
//  Created by admin on 2018/11/17.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {
    
    private var dataSource: AdDataSource!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = AdDataSource()
    
        // UITableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.isScrollEnabled = false
        tableView.register(CustomCell.self, forCellReuseIdentifier: "cell")
        
        // UIButton
        saveButton.layer.cornerRadius = 5.0
        cancelButton.layer.cornerRadius = 5.0
        
        
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
                    let saveAd = Ad(domain: domainText!, state: false)
                    self.dataSource.save(ad: saveAd)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dataSource.load()
        // UITableViewを更新
        tableView.reloadData()
    }
    
    func tapedSaveButtonAlert() {
        
        // 登録済みの広告ドメインを取得
        let adList: [String] = dataSource.retrieveAcquiredAd()
        // 取得した広告ドメイン
        let getAd = dataSource.data()?.domain
        
        if adList.contains(getAd!) {
            
            let alert = UIAlertController(title: getAd!, message: "It is already registered ad domain", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                
                    self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
            }))
            
            // アラート表示
            self.present(alert, animated: true, completion: nil)
        }
        
        if !adList.contains(getAd!) {
            
            // ホストアプリに取得した広告ドメインを共有
            self.dataSource.shareDomainToHostApp()
            
            let alert = UIAlertController(title: getAd!, message: "Saved Successfully", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                
                self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
            }))
            
            // アラート表示
            self.present(alert, animated: true, completion: nil)
        }
        
    }
        
    
    @IBAction func tapedSaveButton(_ sender: UIButton) {
        
        print("saved Successfully")
        // アラートを表示
        tapedSaveButtonAlert()
    }
    
    @IBAction func tapedCancelButton(_ sender: UIButton) {
        
        print("exits ActionExtension")
        // Action Extensionを閉じる
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "TARGET SITE"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        cell.adList = dataSource.data()
        
        return cell
    }
}

