//
//  SelectorListDataSource.swift
//  adblock
//
//  Created by admin on 2018/10/15.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation

final class OthersListDataSource: NSObject {
    
    fileprivate var jsonManager: JSONManager!
    
    // App Groups
    private let groupID = "group.jp.ac.osakac.cs.hisalab.adblock"
    private let key = "otherList"
    
    // テーブルビューのセクションタイトル
    private let sectionTitle = ["Ads Space Removal", "Social Button Hide", "Access Analysis Block"]
    
    // 広告の空白リストを保持
    private let section0 = [OthersList(text: "Google Ads", state: false)]
    // ソーシャルボタンのリストを保持
    private let section1 = [OthersList(text: "Twitter", state: false), OthersList(text: "Facebook", state: false),
                            OthersList(text: "Youtube", state: false), OthersList(text: "Google+", state: false),
                            OthersList(text: "LINE", state: false), OthersList(text: "Gree", state: false)]
    // アナリスティック解析のリストを保持
    private let section2 = [OthersList(text: "Google", state: false), OthersList(text: "Twitter", state: false),
                            OthersList(text: "FC2", state: false)]
    
    // UITableViewに表示する値を保持
    private var othersList = [[OthersList]]()
    
    // テーブルビューに表示する値を設定する (UITableView用)
    func setTableData() {
        
        self.othersList = [self.section0, self.section1, self.section2]
        saveList(list: self.othersList)
    }
    
    // othersListを読み込む
    func loadList() {
        
        let defaults = UserDefaults(suiteName: groupID)
        let otherListDictionaries = defaults?.object(forKey: key) as? [[[String: Any]]]
        guard let others = otherListDictionaries else { return }
        
        // 取得したothersListを設定
        self.othersList = others.map { $0.map { OthersList(text: $0["text"] as! String, state: $0["state"] as! Bool) } }
    }
    
    // othersListを保存
    func saveList(list: [[OthersList]]) {
        
        let defaults = UserDefaults(suiteName: groupID)
        var othersListDictionaries = [[[String: Any]]]()
        
        // otherListを保存
        othersListDictionaries = othersList.map { $0.map { ["text": $0.text, "state": $0.state] } }
        defaults?.set(othersListDictionaries, forKey: key)
    }
    
    // セクションタイトルの総数を返す　(UITableView用)
    func sectionTitleCount() -> Int {
        
        return sectionTitle.count
    }
    
    // 指定したsectionに対応するsectionTitleを返す　(UITableView用)
    func sectionTitleData(at section: Int) -> String {
        
        return self.sectionTitle[section]
    }
    
    // othersListの総数を返す (UITableView用)
    func sectionDataCount(at section: Int) -> Int {
        
        // othersList読み込み
        loadList()
        
        let sectionData = self.othersList[section]
        return sectionData.count
    }
    
    // 指定したsectionとindexに対応するothersListを返す (UITableViewに表示する値)
    func data(at section: Int, at index: Int) -> OthersList? {
        
        let sectionData = self.othersList[section]
        let cellData = sectionData[index]
        
        return cellData
    }
}
