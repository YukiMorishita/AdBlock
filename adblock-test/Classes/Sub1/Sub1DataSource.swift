//
//  Sub1DataSource.swift
//  adblock-test
//
//  Created by admin on 2018/11/25.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation

final class Sub1DataSource: NSObject {
    
    private var jsonManager: JsonManager!
    
    private let groupID = "group.jp.ac.osakac.cs.hisalab.adblock"
    private let key = "TableList2"
    
    // テーブルビューのセクションタイトル
    private let sectionTitle = ["Ads Space Removal", "Social Button Hide", "Access Analysis Block"]
    
    // 広告の空白リストを保持
    private let section0 = [Advance(label: "Google Ads", state: false)]
    // ソーシャルボタンのリストを保持
    private let section1 = [Advance(label: "Twitter", state: false), Advance(label: "Facebook", state: false),
                            Advance(label: "Youtube", state: false), Advance(label: "Google+", state: false),
                            Advance(label: "LINE", state: false), Advance(label: "Gree", state: false)]
    // アナリスティック解析のリストを保持
    private let section2 = [Advance(label: "Google Analystic", state: false),
                            Advance(label: "Twitter Analystic", state: false),
                            Advance(label: "FC2 Access Analyzer", state: false)]
    
    private var advanceList = [[Advance]]()
    
    func createAdvanceList() {
        
        self.advanceList = [self.section0, self.section1, self.section2]
    }
    
    func load() {
        
        let defaults = UserDefaults(suiteName: groupID)
        let advanceListDic = defaults?.object(forKey: key) as? [[[String: Any]]]
        guard let advances = advanceListDic else { return }
        
        // 取得したothersListを設定
        self.advanceList = advances.map { $0.map { Advance(label: $0["label"] as! String, state: $0["state"] as! Bool) } }
    }
    
    func save() {
        
        let defaults = UserDefaults(suiteName: groupID)
        let advanceListDic = self.advanceList.map { $0.map { ["label": $0.label, "state": $0.state] } }
        
        defaults?.set(advanceListDic, forKey: key)
    }
    
    func getAdvanceList() -> [[Advance]] {
        
        return self.advanceList
    }
    
    func sectionTitleCount() -> Int {
        
        return self.sectionTitle.count
    }
    
    func sectionTitleData(at section: Int) -> String {
        
        if self.sectionTitle.count > section {
            
            return self.sectionTitle[section]
        }
        
        return ""
    }
    
    func sectionDataCount(at section: Int) -> Int {
        
        let sectionData = self.advanceList[section]
        
        return sectionData.count
    }
    
    func data(at section: Int, at index: Int) -> Advance? {
        
        let sectionData = self.advanceList[section]
        let cellData = sectionData[index]
        
        return cellData
    }
    
    func changeSwitchState(label: String, state: Bool) {
        
        // タップしたtableSwitchのsection番号を保持 (section0からスタート)
        var sectionIndex: Int = -1
        // タップしたtableSwitchの要素番号を保持
        var switchIndex: Int?
        
        // sectionとタップしたtableSwitchの番号を取得
        for list in self.advanceList {
            // 要素がnilならば
            if switchIndex == nil {
                // リストからタップしたラベルの文字列を検索し、その要素番号を取得
                switchIndex = list.findIndex(includeElement: { $0.label == label } ).filter { $0 >= 0 }.first
                // リストを数えることで、section番号を取得
                sectionIndex += 1
            }
        }
        
        // UiSwitchをONに変更
        if self.advanceList[sectionIndex][switchIndex!].state == false {
            self.advanceList[sectionIndex][switchIndex!].state = true
        
        // UISwitchをOFFに変更
        } else {
            self.advanceList[sectionIndex][switchIndex!].state = false
        }
        
    }
    
    func changeAllSwitchState(state: Bool) {
        
        // section数
        let section = self.advanceList.count
        
        // 引数stateがtrueの時
        if state == true {
            
            for s in 0..<section {
                // 各セクション内の要素数
                let index = self.advanceList[s].count
                
                // 表示されている要素のUISwitchをONに変更
                for i in 0..<index {
                    
                    self.advanceList[s][i].state = state
                }
            }
        }
        
        // 引数stateがfalseの時
        if state == false {
            
            for s in 0..<section {
                // 各セクション内の要素数
                let index = self.advanceList[s].count
                
                // 表示されている要素のUISwitchをOFFに変更
                for i in 0..<index {
                    
                    self.advanceList[s][i].state = state
                }
            }
        }
        
    }
    
}
