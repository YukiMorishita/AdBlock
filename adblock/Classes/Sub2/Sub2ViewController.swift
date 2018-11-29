//
//  Sub2ViewController.swift
//  adblock-test
//
//  Created by admin on 2018/11/17.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class Sub2ViewController: UIViewController {
    
    private var dataSource: Sub2DataSource!
    private var jsonManager: JsonManager!
    private var contentBlockerManager: ContentBlockerManager!
    
    private let groupID = "group.jp.ac.osakac.cs.hisalab.adblock"
    private let key = "TableList3"
    
    fileprivate var searchBar: UISearchBar!
    fileprivate var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = Sub2DataSource()
        jsonManager = JsonManager()
        contentBlockerManager = ContentBlockerManager()
        
        // NotificationCenter (通知を登録)
        let notificationCenter = NotificationCenter.default
        // 通知の監視
        notificationCenter.addObserver(self, selector: #selector(tableDataReload), name: .tableDataReload3, object: nil)
        
        // UISearchBar
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Search"
        searchBar.layer.position = CGPoint(x: self.view.bounds.width/2, y: 89)
        searchBar.searchBarStyle = .default
        searchBar.keyboardType = .URL
        searchBar.showsSearchResultsButton = false
        searchBar.enablesReturnKeyAutomatically = false
        searchBar.setValue("Cancel", forKey: "_cancelButtonText")
        self.view.addSubview(searchBar)
        
        // UITableView
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(Sub2CustomCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        // 二回目以降の起動
        let defaults = UserDefaults(suiteName: groupID)
        if defaults?.object(forKey: key) != nil {
            // テーブルデータを取得
            dataSource.load()
            dataSource.unionTableData()
        }
        
        // JSONファイルを取得・共有ファイルを作成
        jsonManager.createAndWriteJsonFile()
        // Content Blocker Extension を更新
        contentBlockerManager.reloadContentBlocker()
        // UItableViewを更新
        tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let viewWidth = self.view.frame.size.width
        
        searchBar.frame = CGRect(x: 0, y: 64, width: viewWidth, height: 56)
        tableView.frame = CGRect(x: 0, y: 120, width: viewWidth, height: 498)
    }
    
    func addAdAlert() {
        
        let alert = UIAlertController(title: "New addition", message: "Please Enter Ad Domain", preferredStyle: .alert)
        alert.addTextField(configurationHandler: { (textField) in
            
            textField.placeholder = "Enter Ad Domain"
            textField.keyboardType = .URL
        })
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            let textField = alert.textFields![0] as UITextField
            let domain = textField.text!
            
            // 新規広告ドメインを追加・保存
            self.dataSource.addDomain(domain: domain)
            self.dataSource.save()
            
            // 表示用テーブルデータと統合
            self.dataSource.unionTableData()
            
            // UITableViewを更新
            self.tableView.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            print("Text field: cancel")
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func changeAllSwitchStateAlert() {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // 全スイッチON
        let actionEnableAll = UIAlertAction(title: "Enable All", style: .default)
        {
            (action: UIAlertAction) in
            
            // 全てのUISwitchの状態をONに変更する
            self.dataSource.changeAllSwitchState(state: true)
            self.dataSource.save()
            
            // 表示用テーブルデータと統合
            self.dataSource.unionTableData()
            
            // JSONファイルを取得・共有ファイルを作成
            self.jsonManager.createAndWriteJsonFile()
            // Content Blocker Extension を更新
            self.contentBlockerManager.reloadContentBlocker()
            
            // UITableViewを更新
            self.tableView.reloadData()
        }
        
        // 全スイッチOFF
        let actionDisableAll = UIAlertAction(title: "Disable All", style: .default)
        {
            (action: UIAlertAction) in
            
            // 全てのUISwitchの状態をOFFに変更する
            self.dataSource.changeAllSwitchState(state: false)
            self.dataSource.save()
            
            // 表示用テーブルデータと統合
            self.dataSource.unionTableData()
            
            // JSONファイルを取得・共有ファイルを作成
            self.jsonManager.createAndWriteJsonFile()
            // Content Blocker Extension を更新
            self.contentBlockerManager.reloadContentBlocker()
            
            // UITableViewを更新
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
    
    
    
    @IBAction func didChangeSwitchStateBtn(_ sender: UIBarButtonItem) {
        
        print("left NaviButton Taped")
        // 全UISwitchの状態を変更
        changeAllSwitchStateAlert()
    }
    
    @IBAction func addAdbtn(_ sender: UIBarButtonItem) {
        
        print("right NaviButton Taped")
        
        dataSource.load()
        addAdAlert()
    }
    
    // UITableViewを更新 (AdListCell用)
    @objc func tableDataReload() {
        
        // テーブルデータ取得
        dataSource.load()
        dataSource.unionTableData()
        
        // UITableViewを更新
        tableView.reloadData()
    }

}

extension Sub2ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // テーブルデータを取得
        dataSource.load()
        dataSource.unionTableData()
        
        // 文字列を検索
        dataSource.searchDomainList(searchText: searchText)
        
        // UITableViewを更新
        tableView.reloadData()
    }
    
    // 検索ボタンをタップした時の処理
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // テーブルデータを取得
        dataSource.load()
        dataSource.unionTableData()
        
        // キャンセルボタン非表示
        searchBar.showsCancelButton = false
        // キーボードを下げる
        searchBar.endEditing(true)
    }
    
    // キャンセルボタンをタップした時の処理
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        // テーブルデータを取得
        dataSource.load()
        dataSource.unionTableData()
        
        // UISearchBarの検索文字を空に設定
        searchBar.text = ""
        // 検索文字列が空の時,全要素表示
        dataSource.searchDomainList(searchText: "")
        
        // キャンセルボタン非表示
        searchBar.showsCancelButton = false
        // キーボードを下げる
        searchBar.endEditing(true)
        
        // UiTableViewの更新
        tableView.reloadData()
    }
    
    // UiSearchBarタップ時の処理
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        print("taped UISearchBar")
        // キャンセルボタン表示
        searchBar.showsCancelButton = true
        
        return true
    }
}

extension Sub2ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44
    }
}

extension Sub2ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataSource.tableListCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Sub2CustomCell
        cell.forEachList = dataSource.tableData(at: indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            // UITableViewCellを削除
            dataSource.deleteDomain(at: indexPath.row)
            dataSource.save()
            
            // JSONファイルを取得・共有ファイルを作成
            jsonManager.createAndWriteJsonFile()
            // Content Blocker Extension を更新
            contentBlockerManager.reloadContentBlocker()
            
            // トランジション
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
