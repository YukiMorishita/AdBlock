//
//  RootDataSource.swift
//  adblock-test
//
//  Created by admin on 2018/11/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation

final class RootDataSource: NSObject {
    
    // App Groups
    private let groupID = "group.jp.ac.osakac.cs.hisalab.adblock"
    private let Key = "TableList1"
    private let exKey = "ActionExtension"
    
    // テーブルデータ (インスタンスサーチ実装)
    private var adList = [Ad]() // 管理用
    private var adTableList = [Ad]() // 表示用
    
    func load() {
        
        let defaults = UserDefaults(suiteName: groupID)
        let adListDic = defaults?.object(forKey: Key) as? [[String: Any]]
        guard let ads = adListDic else { return }
        
        self.adList = ads.map { Ad(domain: $0["domain"] as! String, state: $0["state"] as! Bool) }
    }
    
    func save() {
        
        let defaults = UserDefaults(suiteName: groupID)
        let adListDic = self.adList.map { ["domain": $0.domain, "state": $0.state] }
        
        defaults?.set(adListDic, forKey: Key)
    }
    
    func createAdList(domainList: [String]) {
        
        for domain in domainList {
            
            let ad = Ad(domain: domain, state: false)
            self.adList.append(ad)
        }
    }
    
    func getAdList() -> [Ad] {
        
        return self.adList
    }
    
    func getShareDomainToExtension() {
        
        let defaults = UserDefaults(suiteName: groupID)
        let adListDic = defaults?.object(forKey: exKey) as? [String: Any]
        guard let ads = adListDic else { return }
        
        self.adList.append(Ad(domain: ads["domain"] as! String, state: ads["state"] as! Bool))
        
        defaults?.removeObject(forKey: exKey)
    }
    
    func addAd(ad: String) {
        
        let domainList = self.adList.map { $0.domain }
        
        // 広告ドメインを新規追加
        if !domainList.contains(ad) {
            
            self.adList.append(Ad(domain: ad, state: false))
        }
        
        self.adTableList = self.adList
    }
    
    func unionTableData() {
        
        if self.adList.count == self.adTableList.count || self.adTableList.count == 0 {
            
            self.adTableList = self.adList
        }
        
        if self.adList.count > self.adTableList.count {
            
            var searchAdList = [Ad]()
            
            for ad in self.adTableList {
                
                let index = self.adList.findIndex(includeElement: { $0.domain == ad.domain })
                
                for i in index  {
                    
                    searchAdList.append(self.adList[i])
                }
            }
            
            self.adTableList = searchAdList
        }
    }
    
    func deleteAd(at index: Int) {
        
        if self.adList.count > index {
            
            self.adList.remove(at: index)
        }
        self.adTableList = self.adList
    }
    
    func searchAdList(searchText: String) {
        
        // 全テーブルデータを削除
        self.adTableList.removeAll()
        
        // 全テーブルデータを表示
        if searchText == "" {
            
            self.adTableList = self.adList
        }
        
        // テーブルデータから検索
        if searchText != "" {
            
            self.adTableList = self.adList.filter { $0.domain.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    func TableListCount() -> Int {
        
        return self.adTableList.count
    }
    
    func TableData(at index: Int) -> Ad? {
        
        if self.adTableList.count > index {
            
            return self.adTableList[index]
        }
        
        return nil
    }
    
    func changeSwitchState(domain: String, state: Bool) {
        
        // タップしたUISwitchの番号
        let index = self.adList.findIndex(includeElement: { $0.domain == domain}).first!
        
        // UISwitchをONに変更
        if self.adList[index].state == false {
            self.adList[index].state = true
            
            // UISwitchをOFFに変更
        } else {
            self.adList[index].state = false
        }
    }
    
    func changeAllSwitchState(state: Bool) {
        
        let domainList = self.adTableList.map { $0.domain }
        
        for domain in domainList {
            
            // 変更するスイッチの要素番号を取得
            let index = self.adList.findIndex(includeElement: { $0.domain == domain })
            
            // 表示されている要素のUISwitchをONに変更
            if state == true {
                
                self.adList[index[0]].state = state
            }
            
            // 表示されている要素のUISwitchをOFFに設定
            if state == false {
                
                self.adList[index[0]].state = state
            }
        }
    }
    
}

extension Array {
    
    // 配列内の要素番号を取得するメソッド
    func findIndex(includeElement: (Element) -> Bool) -> [Int] {
        
        // 要素番号を格納する配列
        var indexArray = [Int]()
        for (index, element) in enumerated() {
            if includeElement(element) {
                indexArray.append(index)
            }
        }
        return indexArray
    }
}
