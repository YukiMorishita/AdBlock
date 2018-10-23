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
    func defaultsAdList() {
        
        // インスタンスの生成
        let jsonManager = JSONManager()
        
        // adList生成
        for domain in jsonManager.createDomainList() {
            let ad = AdList(domain: domain, state: false)
            self.adListSrc.append(ad)
        }
        // adListSrcを保存
        defaultsSaveAdList(adList: self.adListSrc)
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
    
    // adListSrcとadListを統一する (インスタンスサーチ用)
    func unionAdList() {
        
        // Listを統一
        self.adList = self.adListSrc
        // adList保存
        saveList(adList: self.adList)
        // adListを読み込み
        loadList()
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
    
    // adListを空にする (UISearchBarの検索用)
    func removeAllAdList() {
        
        // 全ての要素を削除
        self.adList.removeAll()
        // adList保存
        saveList(adList: self.adList)
        // adListを読み込み
        loadList()
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
        
        // adListSrcとadListを読み込み (CustomCell再描画対策)
//        self.defaultsLoadAdList()
//        self.unionAdList()
        //loadList()
        
        if self.adList.count > index {
            return self.adList[index]
        }
        return nil
    }
    
    // 指定したindexに対応するadListSrcのメンバstateのBool値を変更する
    func changeSwitchState(at index: Int) {
        
        // adListSrcを読み込み
        defaultsLoadAdList()
        
        // index番目の要素がfalseの場合
        if self.adListSrc[index].state == false {
            self.adListSrc[index].state = true
            
        // index番目の要素がtrueの場合
        } else {
            self.adListSrc[index].state = false
        }
        
        // adListSrcを保存
        defaultsSaveAdList(adList: self.adListSrc)
        // adListSrcを読み込み
        defaultsLoadAdList()
        // 表示用データを統一
        //unionAdList()
        loadList()
    }
    
}

