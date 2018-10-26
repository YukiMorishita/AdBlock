//
//  AdListDataSource.swift
//  adblock
//
//  Created by admin on 2018/10/03.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation

final class AdListDataSource: NSObject {
    
    fileprivate var jsonManager: JSONManager!
    
    // AppGroups
    private let groupID = "group.jp.ac.osakac.cs.hisalab.adblock"
    private let key1 = "adListSrc"
    private let key2 = "adList"
    private let key3 = "share"
    
    // 初期adListを保持
    private var adListSrc = [AdList]()
    // UITableViewに表示するadList (インスタンスサーチ用)
    private var adList = [AdList]()
    
    // adListSrcを返す
    func getList() -> [AdList] {
        
        return self.adListSrc
    }
    
    // adListを返す
    func getAdList() -> [AdList] {
        
        return self.adList
    }
    
    // 初期のadListを生成
    func createAdList() {
        
        // インスタンスの生成
        let jsonManager = JSONManager()
        
        // adListSrc生成
        for domain in jsonManager.createDomainList() {
            let ad = AdList(domain: domain, state: false)
            self.adListSrc.append(ad)
        }
        
        // adListSrcをadListに代入
        self.adList = self.adListSrc
        
        // adListSrcを保存
        defaultsSaveAdList(adList: self.adListSrc)
        // adListを保存
        saveList(adList: self.adList)
    }
    
    // adListSrcを読み込む
    func defaultsLoadAdList() {
        
        // 保存したadListSrcを取得
        let defaults = UserDefaults(suiteName: groupID)
        let adListDictionaries = defaults?.object(forKey: key1) as? [[String: Any]]
        guard let ads = adListDictionaries else { return }
        // 取得したadListSrcを設定
        self.adListSrc = ads.map { AdList(domain: $0["domain"] as! String, state: $0["state"] as! Bool) }
    }
    
    // adListSrcを保存
    func defaultsSaveAdList(adList: [AdList]) {
        
        let defaults = UserDefaults(suiteName: groupID)
        var adListDictionaries = [[String: Any]]()
        
        // adListを保存
        adListDictionaries = adList.map { ["domain": $0.domain, "state": $0.state] }
        defaults?.set(adListDictionaries, forKey: key1)
    }
    
    // adListSrcとadListの要素を同期する (インスタンスサーチ用)
    func unionAdList() {
        
        // adListが空の場合
        if self.adList.count == 0 {

            print("状態を変更できるUISwitchがありません")
        }
        
        // adListがadListと同じ要素数
        if self.adList.count == self.adListSrc.count {
            // データを統一
            self.adList = self.adListSrc
        }
        
        // 表示用adListが管理用adListと異なる要素数、または、adListが1要素以上なら (UISearchBar利用時の要素同期)
        if self.adList.count != self.adListSrc.count || self.adList.count > 0 {
            
            // 検索対象と同一のadListSrcを保持
            var searchAdList = [AdList]()
            
            // adListSrc内からadListと同じ要素を取得
            for ad in self.adList {
                
                let index = self.adListSrc.findIndex(includeElement: { $0.domain == ad.domain })
                
                // マッチした要素をsearchAdListに追加
                for i in index {
                    
                    searchAdList.append(self.adListSrc[i])
                }
            }
            
            // 要素を同期
            self.adList = searchAdList
        }
        
        // adListの変更を保存
        saveList(adList: self.adList)
    }
    
    // Action Extensionｎから送られてきた値をadListに追加
    func shareDomain() {
        
        // データを取得
        let defaults = UserDefaults(suiteName: groupID)
        let adDictionary = defaults?.object(forKey: key3) as? [String: Any]
        guard let adDic = adDictionary else { return }
        
        // 取得したデータを追加
        self.adListSrc.append(AdList(domain: adDic["domain"] as! String , state: adDic["state"] as! Bool))
        
        // 保存
        defaultsSaveAdList(adList: self.adListSrc)
        // ロード
        defaultsLoadAdList()
        
        // 取得したデータを削除
        defaults?.removeObject(forKey: key3)
    }
    
    // 検索文字列に応じて表示データを変更する処理 (UISearchBar用)
    func searchAdList(searchText: String) {
        
        // adListを全データ削除
        self.adList.removeAll()
        
        // UISearchBarが未入力の場合
        if searchText == "" {
            
            // 表示用adListを管理用adListで上書き (UITableView全データ表示)
            self.adList = self.adListSrc
        }
        
        // UISearchBarに文字列が入力された場合
        if searchText != "" {
            
            // 表示用adListを管理用adListで上書き (UITableView検索文字列にマッチしたデータを表示)
            self.adList = self.adListSrc.filter { $0.domain.lowercased().contains(searchText.lowercased()) }
        }
        
        // adListの変更を保存
        saveList(adList: self.adList)
    }
    
    // adListを読み込む
    func loadList() {
        
        // 保存したadListSrcを取得
        let defaults = UserDefaults(suiteName: groupID)
        let adListDictionaries = defaults?.object(forKey: key2) as? [[String: Any]]
        guard let ads = adListDictionaries else { return }
        
        // 取得したadListSrcを設定
        self.adList = ads.map { AdList(domain: $0["domain"] as! String, state: $0["state"] as! Bool) }
    }
    
    // adListを保存
    func saveList(adList: [AdList]) {
        
        let defaults = UserDefaults(suiteName: groupID)
        var adListDictionaries = [[String: Any]]()
        
        // adListを保存
        adListDictionaries = adList.map { ["domain": $0.domain, "state": $0.state] }
        defaults?.set(adListDictionaries, forKey: key2)
    }
    
    // adListの総数を返す (UITableViewのCell数)
    func adListCount() -> Int {
        
        return self.adList.count
    }
    
    // 指定したindexに対応するadListを返す (UITableViewに表示する値)
    func data(at index: Int) -> AdList? {
        
        if self.adList.count > index {
            return self.adList[index]
        }
        
        return nil
    }
    
    // 指定したindexに対応するadListSrcのメンバstateのBool値を変更する
    func changeSwitchState(at index: Int) {
        
        // adListSrcを読み込み
        //defaultsLoadAdList()
        
        // index番目の要素がfalseの場合
        if self.adListSrc[index].state == false {
            self.adListSrc[index].state = true
            
        // index番目の要素がtrueの場合
        } else {
            self.adListSrc[index].state = false
        }
        
        // adListSrcを保存
        defaultsSaveAdList(adList: self.adListSrc)
    }
    
    // 全てのUISwitchの状態を変更する
    func changeAllSwitchState(state: Bool) {
        
        // 表示されているadListのメンバdomainを設定
        let domainList = self.adList.map { $0.domain }
        
        // adListSrcからadListと同じ要素を取得
        for domain in domainList {
            // 要素番号を設定
            let index = self.adListSrc.findIndex(includeElement: { $0.domain == domain })
            
            // 引数stateがtrueの時
            if state == true {
                // 表示されている要素のUISwitchをONに変更
                self.adListSrc[index[0]].state = state
            }
            
            // 引数stateがfalseの時
            if state == false {
                // 表示されている要素のUISwitchをOFFに設定
                self.adListSrc[index[0]].state = state
            }
        }
        
        // adListSrcの変更を保存
        defaultsSaveAdList(adList: self.adListSrc)
    }
    
    
}
