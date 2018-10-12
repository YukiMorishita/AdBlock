//
//  AdListDataSource.swift
//  adblock
//
//  Created by admin on 2018/10/03.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation

final class AdListDataSource: NSObject {
    
    // ブロックするAdList一覧を保持するArray
    // UITableViewに表示させるためのデータ
    private var adList = [AdList]()
    private var searchAdList = [AdList]()
    fileprivate var jsonManager: JSONManager!
    
    func createDefaultAdList() {
        
        // インスタンスの生成
        let jsonManager = JSONManager()
        // ドメインリストの生成
        for domain in jsonManager.createDomainArray() {
            let ad = AdList(domain: domain, state: false)
            adList.append(ad) // ドメインをadListに追加
        }
        
        self.searchAdList = self.adList
        saveList(adList: adList) // 保存
    }
    
    // UserDefaultsから保存したadListを取得
    func loadList() {
        
        let defaults = UserDefaults.standard
        // 辞書化したadListを保持するArray
        let adListDictionaries = defaults.object(forKey: "adList") as? [[String: Any]]
        guard let ads = adListDictionaries else { return }
        
        // adListを初期化
        searchAdList.removeAll()
        
        // adListを配列にキャスト
        for dic in ads {
            let ad = AdList(from: dic)
            searchAdList.append(ad) // ドメインをadListに追加
        }
    }
    
    // adListをUserDefaultsに保存
    func saveList(adList: [AdList]) {
        
        let defaults = UserDefaults.standard
        // 辞書化したadListを保持するArray
        var adListDictionaries = [[String: Any]]()
        
        // adListを辞書型にキャスト
        adListDictionaries = searchAdList.map { ["domain": $0.domain, "state": $0.state] }
        // UserDefaultsに辞書型にキャストしたadListを保存
        defaults.set(adListDictionaries, forKey: "adList")
    }
    
    // adListの総数を返す
    func adListCount() -> Int {
        
        return searchAdList.count
    }
    
    // 指定したindexに対応するadListを返す
    func data(at index: Int) -> AdList? {
        
        if searchAdList.count > index {
            return searchAdList[index]
        }
        return nil
    }
    
    func getAdList() -> [AdList] {
        
        var adList = [(domain: String, state: Bool)]()
        
        for ad in searchAdList {
            adList.append((domain: ad.domain, state: ad.state))
        }
        
        return adList
    }
    
    func getDomain() -> [String] {
        
        var domainList = [String]()
        
        for ad in self.searchAdList {
            domainList.append(ad.domain)
        }
        
        return domainList
    }
    
    func RemoveAdList() {
        
        self.searchAdList.removeAll()
    }
    
    // タップしたスイッチのインデックスを取得し、adListにスイッチのON・OFFを保存
    func switchStateDidChangeAdList(domain: String) {
        
        // ドメイン一覧を保持
        var adList = [String]()
        // adListを読み込む
        loadList()
        
        // domainList生成
        for ad in self.searchAdList {
            adList.append(ad.domain)
        }
        
        // adListから引数であるドメインを検索
        let index = adList.findIndex(includeElement: { $0 == domain })
        // 引数のドメインがdomainListにあれば、スイッチの状態を切り替える
        if index.isEmpty == false {
            if searchAdList[index[0]].state == false {
                searchAdList[index[0]].state = true
            } else {
                searchAdList[index[0]].state = false
            }
            saveList(adList: searchAdList) // 保存
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
