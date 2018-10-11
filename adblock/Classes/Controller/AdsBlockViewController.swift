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
    fileprivate var navigationBar: UINavigationBar!
    fileprivate var searchBar: UISearchBar!
    fileprivate var tableView: UITableView!
    fileprivate var tableSwitch: UISwitch!
    fileprivate var tabBar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        dataSource = AdListDataSource()
        
        navigationBar = UINavigationBar()
        //navigationBar.tintColor = UIColor.black
        navigationBar.isTranslucent = false
        //navigationBar.appearance().tintColor = UIColor.black
        
        let navigationItem = UINavigationItem()
        navigationItem.title = "Test"
        
        let leftNavBtn = UIBarButtonItem(image: UIImage(named: "menuIcon")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(leftBtnTaped(sender:)))
        navigationItem.leftBarButtonItem = leftNavBtn
        
        let rightNavBtn = UIBarButtonItem(image: UIImage(named: "switchIcon")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(rightBtnTaped(sender:)))
        navigationItem.rightBarButtonItem = rightNavBtn
        
        
        navigationBar.pushItem(navigationItem, animated: true)
        view.addSubview(navigationBar)
        
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
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AdListCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        
        tabBar = UITabBar()
        tabBar.barTintColor = UIColor.white
        tabBar.unselectedItemTintColor = UIColor.black
        tabBar.tintColor = UIColor.blue
        
        let homeTab = UITabBarItem(title: "Home", image: UIImage(named: "switchIcon2")?.withRenderingMode(.alwaysOriginal), tag: 0)
        let adsBlockTab = UITabBarItem(title: "Ads Block", image: UIImage(named: "menuIcon"), tag: 1)
        let trackingsBlockTab = UITabBarItem(title: "Trackings Block", image: UIImage(named: "menuIcon"), tag: 2)
        let eachSiteTab = UITabBarItem(title: "Each Site", image: UIImage(named: "menuIcon"), tag: 3)
        
        tabBar.items = [homeTab, adsBlockTab, trackingsBlockTab, eachSiteTab]
        tabBar.delegate = self
        view.addSubview(tabBar)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 保存したAdListを取得
        let defaults = UserDefaults.standard
        if (defaults.object(forKey: "adList") != nil) {
            print("二回目以降の起動")
            // 最後に保存したAdListを生成
            dataSource.loadList()
            
        } else {
            
            print("初回起動")
            // 初期のAdListを生成
            dataSource.createDefaultAdList()
        }
        // テーブルビューの更新
        tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let viewWidth = self.view.frame.size.width // 横幅 5s = 284 7 = 350
        let viewHeight = self.view.frame.size.height // 縦幅 5s = 568 5 = 667
        
        navigationBar.frame = CGRect(x: 0, y: 22, width: viewWidth, height: 40)
        
        searchBar.frame = CGRect(x: 0, y: 67, width: viewWidth, height: 50)
        
        tableView.frame = CGRect(x: 0, y: 116, width: viewWidth, height: 496)
        
        tabBar.frame = CGRect(x: 0, y: viewHeight - 49, width: viewWidth, height: 49)
    }
    
    func switchsDidChangeState() {
        
        var adList = [AdList]()
        let domainList = self.dataSource.getDomain()
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let actionEnableAll = UIAlertAction(title: "Enable All", style: .default)
        {
            (action: UIAlertAction) in
            
            for domain in domainList {
                adList.append(AdList(domain: domain, switchState: true))
            }
            self.dataSource.saveList(adList: adList)
            
            self.dataSource.loadList()
            self.tableView.reloadData()
        }
        
        let actionDisableAll = UIAlertAction(title: "Disable All", style: .default)
        {
            (action: UIAlertAction) in
            
            for domain in domainList {
                adList.append(AdList(domain: domain, switchState: false))
            }
            self.dataSource.saveList(adList: adList)
            
            self.dataSource.loadList()
            self.tableView.reloadData()
        }
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(actionEnableAll)
        alert.addAction(actionDisableAll)
        alert.addAction(actionCancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc func leftBtnTaped(sender: UIButton) {
        
        print("left Button Taped")
    }
    
    @objc func rightBtnTaped(sender: UIButton) {
        
        print("right Button Taped")
        switchsDidChangeState()
    }
    
}

extension AdsBlockViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let adList = dataSource.getAdList()
        var searchResults = [AdList]()
        
        searchResults.removeAll()
        
        //self.view.endEditing(true)
        searchBar.showsCancelButton = true
        
        if searchBar.text == "" {
            
            for ad in adList {
                searchResults.append(AdList(domain: ad.domain, switchState: ad.switchState))
            }
            
        } else {
            
            let searchFilter = adList.filter { $0.domain.lowercased().contains(self.searchBar.text!.lowercased()) }
            
            if searchFilter.isEmpty == false {
                for result in searchFilter {
                    searchResults.append(AdList(domain: result.domain, switchState: result.switchState))
                    print(result)
                }
            }
            
            dataSource.saveSearchResults(searchResults: searchResults)
            self.tableView.reloadData()
        }
        
        dataSource.saveSearchResults(searchResults: searchResults)
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.showsCancelButton = false
        self.view.endEditing(true)
        searchBar.text = ""
        self.tableView.reloadData()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        searchBar.showsCancelButton = true
        return true
    }
}

extension AdsBlockViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44
    }
}

extension AdsBlockViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchBar.text != "" {
            return dataSource.searchResultsCount()
            
        } else {
            return dataSource.adListCount()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 保存したAdListを取得 (スイッチの状態を更新するため)
        dataSource.loadList()
        dataSource.loadSearchResults()
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! AdListCell
        
        if searchBar.text != "" {
            // 検索結果配列を表示
            print("search")
            cell.searchResults = dataSource.searchData(at: indexPath.row)
            
        } else {
            print("default")
            cell.adList = dataSource.data(at: indexPath.row)
        }
        
        return cell
    }
}

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
