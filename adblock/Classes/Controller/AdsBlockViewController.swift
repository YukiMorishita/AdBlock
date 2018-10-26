//
//  AdsBlockViewController.swift
//  adblock
//
//  Created by admin on 2018/10/03.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class AdsBlockViewController: UIViewController {
    
    fileprivate var dataSource: AdListDataSource!
    fileprivate var jsonManager: JSONManager!
    fileprivate var blockerManager: ContentBlockerManager!
    
    // UI
    fileprivate var navigationBar: UINavigationBar!
    fileprivate var searchBar: UISearchBar!
    fileprivate var tableView: UITableView!
    fileprivate var tableSwitch: UISwitch!
    fileprivate var tabBar: UITabBar!
    
    // AppGroups ID
    private let groupID = "group.jp.ac.osakac.cs.hisalab.adblock"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 背景色
        view.backgroundColor = .white
        
        dataSource = AdListDataSource()
        jsonManager = JSONManager()
        blockerManager = ContentBlockerManager()
        
        // UINavigationBar
        navigationBar = UINavigationBar()
        navigationBar.isTranslucent = false
        
        // UINavigationItem
        let navigationItem = UINavigationItem()
        navigationItem.title = "Ads Block"
        
        // LeftButton
        let leftNavBtn = UIBarButtonItem(image: UIImage(named: "menuIcon")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(leftBtnTaped(sender:)))
        navigationItem.leftBarButtonItem = leftNavBtn
        
        // RightButton
        let rightNavBtn = UIBarButtonItem(image: UIImage(named: "switchIcon")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(rightBtnTaped(sender:)))
        navigationItem.rightBarButtonItem = rightNavBtn
        
        // 左右ボタンを設定
        navigationBar.pushItem(navigationItem, animated: true)
        view.addSubview(navigationBar)
        
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
        view.addSubview(searchBar)
        
        // UITableView
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(AdListCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        
        // UITabBar
        tabBar = UITabBar()
        tabBar.barTintColor = UIColor.white
        tabBar.unselectedItemTintColor = UIColor.black
        tabBar.tintColor = UIColor.blue
        
        // TabButton
        let homeTab = UITabBarItem(title: "Home", image: UIImage(named: "menuIcon")?.withRenderingMode(.alwaysOriginal), tag: 0)
        let adsBlockTab = UITabBarItem(title: "Ads Block", image: UIImage(named: "menuIcon"), tag: 1)
        let trackingsBlockTab = UITabBarItem(title: "Others Block", image: UIImage(named: "menuIcon"), tag: 2)
        let eachSiteTab = UITabBarItem(title: "Each Site", image: UIImage(named: "menuIcon"), tag: 3)
        
        // TabButtonを設定
        tabBar.items = [homeTab, adsBlockTab, trackingsBlockTab, eachSiteTab]
        tabBar.delegate = self
        view.addSubview(tabBar)
        
        
        // NotificationCenter
        let notificationCenter = NotificationCenter.default
        // テーブルの更新通知
        notificationCenter.addObserver(self, selector: #selector(tableViewReload), name: .tableViewReload, object: nil)
    }
    
    // Viewを表示したときの処理
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // adList生成
        let defaults = UserDefaults(suiteName: groupID)
        // 保存したAdListを取得
        if (defaults?.object(forKey: "adList") != nil) {
            print("二回目以降の起動")
            
            // 保存していたadListSrcを取得
            dataSource.defaultsLoadAdList()
            // adListを更新
            dataSource.loadList()
            // adListをadListSrcと同期
            dataSource.unionAdList()
            
            /// Action Extensionの処理
            if defaults?.object(forKey: "share") != nil {
                // 共有された広告ドメインをadListに追加
                dataSource.shareDomain()
                // adListをadListSrcと同期
                dataSource.unionAdList()
            } else {
                print("not share domain")
            }
            
            // 共有ファイルに書き込み
            jsonManager.createJsonFile(adList: dataSource.getAdList())
            // Content Blocker Extensionを更新
            blockerManager.reloadContentBlocker()
            
        } else {
            print("初回起動")
            
            // adListを生成
            dataSource.createAdList()
        }
        
        // テーブルビューを更新
        tableView.reloadData()
    }
    
    // SubViewのレイアウトを設定
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // UIViewの縦横サイズ
        let viewWidth = self.view.frame.size.width
        let viewHeight = self.view.frame.size.height
        
        navigationBar.frame = CGRect(x: 0, y: 22, width: viewWidth, height: 40)
        searchBar.frame = CGRect(x: 0, y: 67, width: viewWidth, height: 50)
        tableView.frame = CGRect(x: 0, y: 116, width: viewWidth, height: 496)
        tabBar.frame = CGRect(x: 0, y: viewHeight - 49, width: viewWidth, height: 49)
    }
    
    // スイッチの状態を一括変更する処理
    func switchsDidChangeState() {
        
        // UIAleartController
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // 全スイッチON
        let actionEnableAll = UIAlertAction(title: "Enable All", style: .default)
        {
            (action: UIAlertAction) in
            
            // 全てのUISwitchの状態をONに変更する
            self.dataSource.changeAllSwitchState(state: true)
            // adListとadListSrcを同期
            self.dataSource.unionAdList()
            
            // 共有ファイル生成
            self.jsonManager.createJsonFile(adList: self.dataSource.getAdList())
            
            // Content Blocker Extensionを更新
            self.blockerManager.reloadContentBlocker()
            
            // テーブルビューの更新
            self.tableView.reloadData()
        }
        
        // 全スイッチOFF
        let actionDisableAll = UIAlertAction(title: "Disable All", style: .default)
        {
            (action: UIAlertAction) in
            
            // 全てのUISwitchの状態をOFFに変更する
            self.dataSource.changeAllSwitchState(state: false)
            // adListとadListSrcを同期
            self.dataSource.unionAdList()
            
            // 共有ファイル生成
            self.jsonManager.createJsonFile(adList: self.dataSource.getAdList())
            
            // Content Blocker Extensionを更新
            self.blockerManager.reloadContentBlocker()
            
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
    
    
    // UINavigationBar LeftButton タップ時の処理
    @objc func leftBtnTaped(sender: UIButton) {
        
        print("left NaviButton Taped")
    }
    
    // UINavigationBar RightButton タップ時の処理
    @objc func rightBtnTaped(sender: UIButton) {
        
        print("right NaviButton Taped")
        // 全UISwitchの状態を変更
        switchsDidChangeState()
    }
    
    // テーブルビューを更新する処理 (AdListCell用)
    @objc func tableViewReload() {
        
        // adListSrcを読み込み
        dataSource.defaultsLoadAdList()
        // adListとadListSrcを同期
        dataSource.unionAdList()
        // adListを更新
        dataSource.loadList()
        
        // テーブルビューを更新
        tableView.reloadData()
    }
    
}

// MARK - UISearchBar
extension AdsBlockViewController: UISearchBarDelegate {
    
    // 検索文字が変更された時の処理
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        print("tap search bar")
        
        // 検索文字列が含まれるデータを表示して保存
        dataSource.searchAdList(searchText: searchText)
        
        // テーブルビューを更新
        tableView.reloadData()
    }
    
    // 検索ボタンをタップした時の処理
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // キャンセルボタン非表示
        searchBar.showsCancelButton = false
        // キーボードを下げる
        searchBar.endEditing(true)
    }
    
    // キャンセルボタンをタップした時の処理
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        // キャンセルボタン非表示
        searchBar.showsCancelButton = false
        // キーボードを下げる
        self.view.endEditing(true)
        
        // UISearchBarの検索文字を空に設定
        searchBar.text = ""
        // adListSrcを読み込み
        dataSource.defaultsLoadAdList()
        // 検索文字列が空の時,全要素表示
        dataSource.searchAdList(searchText: "")
        
        // テーブルビューの更新
        tableView.reloadData()
    }
    
    // UiSearchBarタップ時の処理
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        // キャンセルボタン表示
        searchBar.showsCancelButton = true
        
        return true
    }
}

// MARK: - UITableView
extension AdsBlockViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44
    }
}

extension AdsBlockViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataSource.adListCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // セルを参照し、値を設定
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! AdListCell
        cell.adList = dataSource.data(at: indexPath.row)
        
        return cell
    }
}

// MARK: - UITabBar
extension AdsBlockViewController: UITabBarDelegate {
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case 0:
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "Home")
            present(nextVC!, animated: false, completion: nil)
        case 1:
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ABlock")
            present(nextVC!, animated: false, completion: nil)
        case 2:
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "OBlock")
            present(nextVC!, animated: false, completion: nil)
        case 3:
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "EachSite")
            present(nextVC!, animated: false, completion: nil)
        default:
            return
        }
    }
    
    
}
