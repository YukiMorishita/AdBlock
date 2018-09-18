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
    var section0 = [(text: "Cookies Block", switchs: false), (text: "Images Block", switchs: false),(text: "JavaScripts Block", switchs: false)]
    var section1 = [
                    (text: "Google Analystics", switchs: false), (text: "Twitter Analystics", switchs: false),
                    (text: "FC2 Access Analyzer", switchs: false), (text: "Other Analystics", switchs: false)
                   ]
    var section2 = [
                    (text: "Twitter", switchs: false), (text: "Facebook", switchs: false), (text: "Google+", switchs: false),
                    (text: "LINE", switchs: false), (text: "Gree", switchs: false), (text: "Tumblr", switchs: false),
                    (text: "Evernote", switchs: false), (text: "Feedly", switchs: false), (text: "AddThis", switchs: false),
                    (text: "Pocket", switchs: false), (text: "mixi", switchs: false), (text: "Hatena Bookmark", switchs: false)
                   ]
    var section3 = [(text: "CSS Selectors Block", switchs: false)]
    
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
        // セクションの配置
        if indexPath.section == 0 {
            cell.textLabel?.text = "\(section0[indexPath.row].text)"
        } else if indexPath.section == 1 {
            cell.textLabel?.text = "\(section1[indexPath.row].text)"
        } else if indexPath.section == 2 {
            cell.textLabel?.text = "\(section2[indexPath.row].text)"
        } else if indexPath.section == 3 {
            cell.textLabel?.text = "\(section3[indexPath.row].text)"
        }
        
        /* スイッチの設定 */
        // インスタンスの生成
        let tableSwitch = UISwitch()
        // 色の設定
        tableSwitch.onTintColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        // タグにセルの要素番号を設定
        tableSwitch.tag = indexPath.row
        // section0のスイッチをタップした時の処理を設定
        if indexPath.section == 0 {
            tableSwitch.addTarget(self, action: #selector(switchTriggeredSection0), for: .valueChanged)
        }
        // section1のスイッチをタップした時の処理を設定
        if indexPath.section == 1 {
            tableSwitch.addTarget(self, action: #selector(switchTriggeredSection1), for: .valueChanged)
        }
        // section2のスイッチをタップした時の処理を設定
        if indexPath.section == 2 {
            tableSwitch.addTarget(self, action: #selector(switchTriggeredSection2), for: .valueChanged)
        }
        // section3のスイッチをタップした時の処理を設定
        if indexPath.section == 3 {
            tableSwitch.addTarget(self, action: #selector(switchTriggeredSection3), for: .valueChanged)
        }
        
//        // tag番目の要素がtrueの場合
//        if searchAdList[tableSwitch.tag].switchs == true {
//            // ONに設定
//            tableSwitch.isOn = true
//            // それ以外の場合
//        } else {
//            // OFFに設定
//            tableSwitch.isOn = false
//        }
        
        
        cell.accessoryView = tableSwitch
        return cell
    }
    
    // MARK: - UISwitch
    
    // section0のスイッチをタップした時の処理
    @objc private func switchTriggeredSection0(sender: UISwitch) {
        // スイッチのブール値を変更
        section0[sender.tag].switchs = sender.isOn
    
        // 保存するキー
        let saveKey = "Section0"
        // データの保存
        let saveData: [[String: Any]] = section0.map { ["text": $0.text, "switchs": $0.switchs] }
        AppGroupsManager.saveData(data: saveData, key: saveKey)
        // コンテンツブロッカーを更新
        ContentBlockerManager.reloadContentBlocker()
    }
    
    // section1のスイッチをタップした時の処理
    @objc private func switchTriggeredSection1(sender: UISwitch) {
        // スイッチのブール値を変更
        section1[sender.tag].switchs = sender.isOn
        
        // 保存するキー
        let saveKey = "Section1"
        // データの保存
        let saveData: [[String: Any]] = section1.map { ["text": $0.text, "switchs": $0.switchs] }
        AppGroupsManager.saveData(data: saveData, key: saveKey)
        // コンテンツブロッカーを更新
        ContentBlockerManager.reloadContentBlocker()
    }
    
    // section2のスイッチをタップした時の処理
    @objc private func switchTriggeredSection2(sender: UISwitch) {
        // スイッチのブール値を変更
        section2[sender.tag].switchs = sender.isOn
        
        // 保存するキー
        let saveKey = "Section2"
        // データの保存
        let saveData: [[String: Any]] = section2.map { ["text": $0.text, "switchs": $0.switchs] }
        AppGroupsManager.saveData(data: saveData, key: saveKey)
        // コンテンツブロッカーを更新
        ContentBlockerManager.reloadContentBlocker()
    }
    
    // section3のスイッチをタップした時の処理
    @objc private func switchTriggeredSection3(sender: UISwitch) {
        // スイッチのブール値を変更
        section3[sender.tag].switchs = sender.isOn
        
        // 保存するキー
        let saveKey = "Section3"
        // データの保存
        let saveData: [[String: Any]] = section3.map { ["text": $0.text, "switchs": $0.switchs] }
        AppGroupsManager.saveData(data: saveData, key: saveKey)
        // コンテンツブロッカーを更新
        ContentBlockerManager.reloadContentBlocker()
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
