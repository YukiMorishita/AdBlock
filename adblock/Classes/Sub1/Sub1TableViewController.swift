//
//  Sub1TableViewController.swift
//  adblock-test
//
//  Created by admin on 2018/11/17.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class Sub1TableViewController: UITableViewController {
    
    private var dataSource: Sub1DataSource!
    private var jsonManager: JsonManager!
    private var contentBlockerManager: ContentBlockerManager!
    
    private let groupID = "group.jp.ac.osakac.cs.hisalab.adblock"
    private let key = "TableList2"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = Sub1DataSource()
        jsonManager = JsonManager()
        contentBlockerManager = ContentBlockerManager()
        
        // 初回の起動
        let defaults = UserDefaults(suiteName: groupID)
        if defaults?.object(forKey: key) == nil {
            // テーブルデータ作成・保存
            dataSource.createAdvanceList()
            dataSource.save()
        }
        
        // 二回目以降の起動
        if defaults?.object(forKey: key) != nil {
            // テーブルデータを取得
            dataSource.load()
        }
        
        // NotificationCenter (通知を登録)
        let notificationCenter = NotificationCenter.default
        // 通知の監視
        notificationCenter.addObserver(self, selector: #selector(tableDataReload), name: .tableDataReload2, object: nil)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(Sub1CustomCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 共有ファイル作成
        jsonManager.createAndWriteJsonFile()
        // Content Blocker Extension を更新
        contentBlockerManager.reloadContentBlocker()
        //UITableViewを更新
        tableView.reloadData()
    }
    
    func changeAllSwitchStateAlert() {
        
        // UIAleartController
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // 全スイッチON
        let actionEnableAll = UIAlertAction(title: "Enable All", style: .default)
        {
            (action: UIAlertAction) in
            
            // 全てのUISwitchの状態をONに変更する
            self.dataSource.changeAllSwitchState(state: true)
            self.dataSource.save()
            
            // 共有ファイル作成
            self.jsonManager.createAndWriteJsonFile()
            // Content Blocker Extension を更新
            self.contentBlockerManager.reloadContentBlocker()
            // テーブルビューの更新
            self.tableView.reloadData()
        }
        
        // 全スイッチOFF
        let actionDisableAll = UIAlertAction(title: "Disable All", style: .default)
        {
            (action: UIAlertAction) in
            
            // 全てのUISwitchの状態をOFFに変更する
            self.dataSource.changeAllSwitchState(state: false)
            self.dataSource.save()
            
            // 共有ファイル作成
            self.jsonManager.createAndWriteJsonFile()
            // Content Blocker Extension を更新
            self.contentBlockerManager.reloadContentBlocker()
            // テーブルビューの更新
            self.tableView.reloadData()
        }
        
        // キャンセル
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // アラートを設定
        alert.addAction(actionEnableAll)
        alert.addAction(actionDisableAll)
        alert.addAction(actionCancel)
        
        // アラートを表示
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func allSwitchStateChangeButtonTaped(_ sender: UIBarButtonItem) {
        
        print("left NaviButton Taped")
        // 全UISwitchの状態を変更
        changeAllSwitchStateAlert()
    }
    
    // UITableViewを更新 (CustomCell用)
    @objc func tableDataReload() {
        
        dataSource.load()
        tableView.reloadData()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return dataSource.sectionTitleData(at: section)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return dataSource.sectionTitleCount()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return dataSource.sectionDataCount(at: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Sub1CustomCell
        cell.advanceList = dataSource.data(at: indexPath.section, at: indexPath.row)
        
        return cell
    }

}
