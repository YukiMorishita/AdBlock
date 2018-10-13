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
    
    fileprivate var navigationBar: UINavigationBar!
    fileprivate var searchBar: UISearchBar!
    fileprivate var tableView: UITableView!
    fileprivate var tableSwitch: UISwitch!
    fileprivate var tabBar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        dataSource = AdListDataSource()
        jsonManager = JSONManager()
        blockerManager = ContentBlockerManager()
        
        // UINavigationBar
        navigationBar = UINavigationBar()
        //navigationBar.tintColor = UIColor.black
        navigationBar.isTranslucent = false
        //navigationBar.appearance().tintColor = UIColor.black
        
        // UINavigationItem
        let navigationItem = UINavigationItem()
        navigationItem.title = "Test"
        
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
        tableView.register(AdListCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        
        // UITabBar
        tabBar = UITabBar()
        tabBar.barTintColor = UIColor.white
        tabBar.unselectedItemTintColor = UIColor.black
        tabBar.tintColor = UIColor.blue
        
        // TabButton
        let homeTab = UITabBarItem(title: "Home", image: UIImage(named: "switchIcon2")?.withRenderingMode(.alwaysOriginal), tag: 0)
        let adsBlockTab = UITabBarItem(title: "Ads Block", image: UIImage(named: "menuIcon"), tag: 1)
        let trackingsBlockTab = UITabBarItem(title: "Trackings Block", image: UIImage(named: "menuIcon"), tag: 2)
        let eachSiteTab = UITabBarItem(title: "Each Site", image: UIImage(named: "menuIcon"), tag: 3)
        
        // TabButtonを設定
        tabBar.items = [homeTab, adsBlockTab, trackingsBlockTab, eachSiteTab]
        tabBar.delegate = self
        view.addSubview(tabBar)
    }
    
    // Viewを表示したときの処理
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // adList生成
        let defaults = UserDefaults.standard
        // 保存したAdListを取得
        if (defaults.object(forKey: "adList") != nil) {
            print("二回目以降の起動")
            // 最後に保存したAdListを生成
            dataSource.loadList()
            
        } else {
            print("初回起動")
            // 初期のAdListを生成
            dataSource.createDefaultAdList()
        }
        
        // テーブルビューを更新
        tableView.reloadData()
    }
    
    // SubViewのレイアウトを設定
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // UIViewの上下サイズ
        let viewWidth = self.view.frame.size.width
        let viewHeight = self.view.frame.size.height
        
        navigationBar.frame = CGRect(x: 0, y: 22, width: viewWidth, height: 40)
        
        searchBar.frame = CGRect(x: 0, y: 67, width: viewWidth, height: 50)
        
        tableView.frame = CGRect(x: 0, y: 116, width: viewWidth, height: 496)
        
        tabBar.frame = CGRect(x: 0, y: viewHeight - 49, width: viewWidth, height: 49)
    }
    
    // スイッチの状態を一括変更する処理
    func switchsDidChangeState() {
        
        var adList = [AdList]()
        let domainList = self.dataSource.getDomain()
        
        // UIAleartController
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // 全スイッチON
        let actionEnableAll = UIAlertAction(title: "Enable All", style: .default)
        {
            (action: UIAlertAction) in
            
            for domain in domainList {
                adList.append(AdList(domain: domain, state: true))
            }
        }
        
        // 全スイッチOFF
        let actionDisableAll = UIAlertAction(title: "Disable All", style: .default)
        {
            (action: UIAlertAction) in
            
            for domain in domainList {
                adList.append(AdList(domain: domain, state: false))
            }
        }
        
        self.dataSource.saveList(adList: adList)
        
        // 表示データを更新
        self.dataSource.loadList()
        self.tableView.reloadData()
        
        // JSONファイルを生成
        ///jsonManager.createJSONFile(adList: <#T##[(text: String, switchs: Bool)]#>)
        
        // Content Blockerを更新
        self.blockerManager.reloadContentBlocker()
        
        // キャンセル
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // アラートを設定
        alert.addAction(actionEnableAll)
        alert.addAction(actionDisableAll)
        alert.addAction(actionCancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    // UINavigationBar LeftButton タップ時の処理
    @objc func leftBtnTaped(sender: UIButton) {
        
        print("left Button Taped")
    }
    
    // UINavigationBar RightButton タップ時の処理
    @objc func rightBtnTaped(sender: UIButton) {
        
        print("right Button Taped")
        // 全スイッチの状態を変更
        switchsDidChangeState()
    }
    
}


// MARK - UISearchBar
extension AdsBlockViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        var adList = [(domain: String, state: Bool)]()
        var searchAdList = [(domain: String, state: Bool)]()
        for ad in dataSource.getAdList() { adList.append((domain: ad.domain, state: ad.state)) }
        
        // 検索文字が空
        if searchText == "" {
            print("文字なし")
            // すべてを表示する
            dataSource.adListUni()
            dataSource.loadList()
            print("全件表示")
            print(dataSource.getAdList())
        } else {
            print("文字あり")
            
            searchAdList = adList.filter { $0.domain.lowercased().contains(searchBar.text!.lowercased()) }
        }
        
        for ad in searchAdList {
            dataSource.saveList(adList: [AdList(domain: ad.domain, state: ad.state)])
        }
        // 表示データ更新
        dataSource.loadList()
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.showsCancelButton = false
        self.view.endEditing(true)
        searchBar.text = ""
        
        dataSource.adListUni()
        dataSource.loadList()
        tableView.reloadData()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
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
        
        // 保存したAdListを取得 (スイッチの状態を更新するため)
        dataSource.loadList()
        
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
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "TBlock")
            present(nextVC!, animated: false, completion: nil)
        case 3:
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "EachSite")
            present(nextVC!, animated: false, completion: nil)
        default:
            return
        }
    }
}
