//
//  AdvancedBlockViewController.swift
//  adblock
//
//  Created by admin on 2018/08/20.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class AdvancedBlockViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let sectionTitle = ["Other Contents Block" ,"Access Analysis Block", "Social Buttons Hide", "Ads Space Remove"]
    let section0 = ["Cookies Block", "Images Block", "JavaScripts Block"]
    let section1 = ["Google Analystics", "Twitter Analystics", "FC2 Access Analyzer", "Other Analystics"]
    let section2 = ["Twitter", "Facebook", "Google+", "LINE", "Gree", "Tumblr", "Evernote", "Feedly", "AddThis", "Pocket", "mixi", "Hatena Bookmark"]
    let section3 = ["CSS Selectors Block"]
    
    /* Outlet */
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* テーブルビューの設定 */
        // タップの設定
        self.tableView.allowsSelection = false
        tableView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        tableView.separatorColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        
        /* デリゲートの設定 */
        tableView.delegate = self
        /* データソースの設定 */
        tableView.dataSource = self
    }
    
    // MARK: - UITableViewDataSource
    
    // セルに値を設定するメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // テーブルのセルを参照する
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdvancedCell", for: indexPath)
        
        if indexPath.section == 0 {
            cell.textLabel?.text = "\(section0[indexPath.row])"
        } else if indexPath.section == 1 {
            cell.textLabel?.text = "\(section1[indexPath.row])"
        } else if indexPath.section == 2 {
            cell.textLabel?.text = "\(section2[indexPath.row])"
        } else if indexPath.section == 3 {
            cell.textLabel?.text = "\(section3[indexPath.row])"
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegete
    
    // セルの個数を設定するメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // セルの個数を設定
        if section == 0 {
            return section0.count
        } else if section == 1 {
            return section1.count
        } else if section == 2 {
            return section2.count
        } else if section == 3 {
            return section3.count
        } else {
            return 0
        }
    }
    
    // セクション数を返すメソッド
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    
    // セクションタイトルを返すメソッド
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
