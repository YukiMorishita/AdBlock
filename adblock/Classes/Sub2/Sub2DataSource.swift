//
//  Sub2DataSource.swift
//  adblock-test
//
//  Created by admin on 2018/11/26.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation

final class Sub2DataSource: NSObject {
    
    // App Groups
    private let groupID = "group.jp.ac.osakac.cs.hisalab.adblock"
    private let key = "TableList3"
    private let exKey = "ActionExtension2"
    
    // テーブルデータ (インスタンスサーチ実装)
    private var domainList = [Domain]() // 管理用
    private var tableList = [Domain]() // 表示用
    
    func load() {
        
        let defaults = UserDefaults(suiteName: groupID)
        let domainListDic = defaults?.object(forKey: key) as? [[String: Any]]
        guard let domains = domainListDic else { return }
        
        self.domainList = domains.map { Domain(domain: $0["domain"] as! String, state: $0["state"] as! Bool) }
    }
    
    func save() {
        
        let defaults = UserDefaults(suiteName: groupID)
        let domainListDic = self.domainList.map { ["domain": $0.domain, "state": $0.state] }
        
        defaults?.set(domainListDic, forKey: key)
    }
    
    func unionTableData() {
        
        if self.domainList.count == self.tableList.count || self.tableList.count == 0 {
            
            self.tableList = self.domainList
        }
        
        if self.domainList.count > self.tableList.count {
            
            var searchDomainList = [Domain]()
            
            for domain in self.tableList {
                
                let index = self.domainList.findIndex(includeElement: { $0.domain == domain.domain })
                
                for i in index {
                    
                    searchDomainList.append(self.domainList[i])
                }
            }
            
            self.tableList = searchDomainList
        }
    }
    
    func getEachSiteList() -> [Domain] {
        
        return self.domainList
    }
    
    func tableListCount() -> Int {
        
        return self.tableList.count
    }
    
    func tableData(at index: Int) -> Domain? {
        
        if self.tableList.count > index {
            
            return self.tableList[index]
        }
        
        return nil
    }
    
    func addDomain(domain: String) {
        
        let domainList = self.domainList.map { $0.domain }
        
        // 広告ドメインを新規追加
        if !domainList.contains(domain) {
            
            self.domainList.append(Domain(domain: domain, state: false))
        }
        self.tableList = self.domainList
    }
    
    func deleteDomain(at index: Int) {
        
        if self.domainList.count > index {
            
            self.domainList.remove(at: index)
        }
        self.tableList = self.domainList
    }
    
    func searchDomainList(searchText: String) {
        
        self.tableList.removeAll()
        
        if searchText == "" {
            
            self.tableList = self.domainList
        }
        
        if searchText != "" {
            
            self.tableList = self.domainList.filter { $0.domain.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    func changeSwitchState(domain: String, state: Bool) {
        
        let index = self.domainList.findIndex(includeElement: { $0.domain == domain }).first!
        
        // UISwitchをONに変更
        if self.domainList[index].state == false {
            self.domainList[index].state = true
            
            // UISwitchをOFFに変更
        } else {
            self.domainList[index].state = false
        }
    }
    
    func changeAllSwitchState(state: Bool) {
        
        let domainList = self.tableList.map { $0.domain }
        
        for domain in domainList {
            
            // 変更するスイッチの要素番号を取得
            let index = self.domainList.findIndex(includeElement: { $0.domain == domain })
            
            // 表示されている要素のUISwitchをONに変更
            if state == true {
                
                self.domainList[index[0]].state = state
            }
            
            // 表示されている要素のUISwitchをOFFに設定
            if state == false {
                
                self.domainList[index[0]].state = state
            }
        }
    }
    
}
