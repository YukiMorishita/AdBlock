//
//  OthersBlockViewController.swift
//  adblock
//
//  Created by admin on 2018/10/14.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class OthersBlockViewController: UIViewController {
    
    fileprivate var dataSource: AdListDataSource!
    fileprivate var jsonManager: JSONManager!
    fileprivate var blockerManager: ContentBlockerManager!
    
    fileprivate var navigationBar: UINavigationBar!
    fileprivate var tableView: UITableView!
    fileprivate var tableSwitch: UISwitch!
    fileprivate var tabBar: UITabBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = AdListDataSource()
        jsonManager = JSONManager()
        blockerManager = ContentBlockerManager()
        
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
    
    @objc func leftBtnTaped(sender: UIButton) {
        
        print("Left Button Taped")
    }
    
    @objc func rightBtnTaped(sender: UIButton) {
        
        print("Rihgt Button Taped")
    }

}

// MARK: - UITableView
extension OthersBlockViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44
    }
}

extension OthersBlockViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataSource.adListCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! AdListCell
        cell.adList = dataSource.data(at: indexPath.row)
        
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
