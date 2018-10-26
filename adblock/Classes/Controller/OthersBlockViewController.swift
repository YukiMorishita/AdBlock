//
//  OthersBlockViewController.swift
//  adblock
//
//  Created by admin on 2018/10/14.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class OthersBlockViewController: UIViewController {
    
    // App Groups
    private let groupID = "group.jp.ac.osakac.cs.hisalab.adblock"
    private let key = "otherList"
    
    fileprivate var dataSource: OthersListDataSource!
    fileprivate var jsonManager: JSONManager!
    fileprivate var blockerManager: ContentBlockerManager!
    
    // UI
    fileprivate var navigationBar: UINavigationBar!
    fileprivate var tableView: UITableView!
    fileprivate var tabBar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = OthersListDataSource()
        jsonManager = JSONManager()
        blockerManager = ContentBlockerManager()
        
        let defaults = UserDefaults(suiteName: groupID)
        if defaults?.object(forKey: key) != nil {
            dataSource.loadList()
        } else {
            // 表示するリストを設定
            dataSource.setOthersList()
        }
        
        // UINavigationBar
        navigationBar = UINavigationBar()
        navigationBar.isTranslucent = false
        
        // UINavigationItem
        let navigationItem = UINavigationItem()
        navigationItem.title = "Ads Block"
        
        // Left Button
        let leftNavBtn = UIBarButtonItem(image: UIImage(named: "menuIcon")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(leftBtnTaped(sender:)))
        navigationItem.leftBarButtonItem = leftNavBtn
        
        // Right Button
        let rightNavBtn = UIBarButtonItem(image: UIImage(named: "switchIcon")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(rightBtnTaped(sender:)))
        navigationItem.rightBarButtonItem = rightNavBtn
        
        // 左右ボタン設定
        navigationBar.pushItem(navigationItem, animated: true)
        self.view.addSubview(navigationBar)
        
        // UITableView
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(OthersListCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)
        
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
    }
    
    // Viewを表示した時の処理
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 表示データ更新
        dataSource.loadList()
        // テーブルビューを更新
        tableView.reloadData()
    }
    
    // SubViewのレイアウトを設定
    override func viewDidLayoutSubviews() {
        
        // UIViewの縦横サイズ
        let viewWidth = self.view.frame.size.width
        let viewHeight = self.view.frame.size.height
        
        navigationBar.frame = CGRect(x: 0, y: 22, width: viewWidth, height: 40)
        tableView.frame = CGRect(x: 0, y: 67, width: viewWidth, height: 546)
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

            // 共有ファイル生成

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

            // 共有ファイル生成

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
    
    @objc func leftBtnTaped(sender: UIButton) {
        
        print("Left NaviButton Taped")
    }
    
    @objc func rightBtnTaped(sender: UIButton) {
        
        print("Rihgt NaviButton Taped")
        // 全UISwitchの状態を変更
        switchsDidChangeState()
    }
    
}
    
    
    // MARK: - UITableView
    extension OthersBlockViewController: UITableViewDelegate {
        
        // テーブルセルの高さを返す
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            
            return 44
        }
        
        // セクションヘッダーの高さを返す
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            
            return 35
        }
        
        // セクションヘッダーの状態を設定
        func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
            
            view.tintColor = #colorLiteral(red: 0.8878365549, green: 0.8878365549, blue: 0.8878365549, alpha: 1)
        }
        
        // セクション数を返す
        func numberOfSections(in tableView: UITableView) -> Int {
            
            return dataSource.sectionTitleCount()
        }
        
        // セクションのタイトルを返す
        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            
            return dataSource.sectionTitleData(at: section)
        }
    }
    
    extension OthersBlockViewController: UITableViewDataSource {
        
        // セクションごとの行数を返す
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            return dataSource.sectionDataCount(at: section)
        }
        
        // Cellごとのデータを返す
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            // 表示データ更新
            dataSource.loadList()
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! OthersListCell
            cell.othersList = dataSource.data(at: indexPath.section, at: indexPath.row)
            
            return cell
        }
    }
    
    // MARK: - UITabBar
    extension OthersBlockViewController: UITabBarDelegate {
        
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
