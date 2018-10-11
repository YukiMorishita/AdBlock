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
    private var searchResults = [AdList]()
    fileprivate var jsonManager: JSONManager!
    
    func getDomain() -> [String] {
        
        var domainList = [String]()
        
        for ad in adList {
            domainList.append(ad.domain)
        }
        
        return domainList
    }
    
    func getAdList() -> [(domain: String, switchState: Bool)] {
        
        var adList = [(domain: String, switchState: Bool)]()
        
        loadList()
        
        for ad in self.adList {
            adList.append((domain: ad.domain, switchState: ad.switchState))
        }
        return adList
    }
    
    func createDefaultAdList() {
        
        // インスタンスの生成
        let jsonManager = JSONManager()
        // ドメインリストの生成
        for domain in jsonManager.createDomainArray() {
            let ad = AdList(domain: domain, switchState: false)
            adList.append(ad) // ドメインをadListに追加
        }
        saveList(adList: adList) // 保存
    }
    
    // UserDefaultsから保存したadListを取得
    func loadList() {
        
        let defaults = UserDefaults.standard
        // 辞書化したadListを保持するArray
        let adListDictionaries = defaults.object(forKey: "adList") as? [[String: Any]]
        guard let ads = adListDictionaries else { return }
        
        // adListを初期化
        adList.removeAll()
        
        // adListを配列にキャスト
        for dic in ads {
            let ad = AdList(from: dic)
            adList.append(ad) // ドメインをadListに追加
        }
    }
    
    // adListをUserDefaultsに保存
    func saveList(adList: [AdList]) {
        
        let defaults = UserDefaults.standard
        // 辞書化したadListを保持するArray
        var adListDictionaries = [[String: Any]]()
        
        // adListを辞書型にキャスト
        adListDictionaries = adList.map { ["domain": $0.domain, "switchState": $0.switchState] }
        // UserDefaultsに辞書型にキャストしたadListを保存
        defaults.set(adListDictionaries, forKey: "adList")
    }
    
    // adListの総数を返す
    func adListCount() -> Int {
        
        return adList.count
    }
    
    // 指定したindexに対応するadListを返す
    func data(at index: Int) -> AdList? {
        
        if adList.count > index {
            return adList[index]
        }
        return nil
    }
    
    // タップしたスイッチのインデックスを取得し、adListにスイッチのON・OFFを保存
    func switchStateDidChangeAdList(domain: String) {
        
        // ドメイン一覧を保持
        var domainList = [String]()
        // adListを読み込む
        loadList()
        
        // domainList生成
        for ad in adList {
            domainList.append(ad.domain)
        }
        
        // domainListから引数であるドメインを検索
        let index = domainList.findIndex(includeElement: { $0 == domain })
        // 引数のドメインがdomainListにあれば、スイッチの状態を切り替える
        if index.isEmpty == false {
            if adList[index[0]].switchState == false {
                adList[index[0]].switchState = true
            } else {
                adList[index[0]].switchState = false
            }
            saveList(adList: adList) // 保存
        }
    }
    
    func loadSearchResults() {
        
        let defaults = UserDefaults.standard
        // 辞書化したsearchResultsを保持するArray
        let searchResultsDictionaries = defaults.object(forKey: "searchResults") as? [[String: Any]]
        print(" load: \(String(describing: searchResultsDictionaries))")
        guard let results = searchResultsDictionaries else { return }
        
        // searchResultsを初期化
        searchResults.removeAll()
        
        // searchResultsを配列にキャスト
        for dic in results {
            let result = AdList(from: dic)
            searchResults.append(result) // 検索結果をsearchResultsに追加
        }
    }
    
    func saveSearchResults(searchResults: [AdList]) {
        
        let defaults = UserDefaults.standard
        // 辞書化したsearchResultsを保持するArray
        var searchResultsDictionaries = [[String: Any]]()
        
        // searchResultsを辞書型にキャスト
        searchResultsDictionaries = searchResults.map { ["domain": $0.domain, "switchState": $0.switchState] }
        print(" save: \(searchResultsDictionaries)")
        // UserDefaultsに辞書型にキャストしたsearchResultsを保存
        defaults.set(searchResultsDictionaries, forKey: "searchResults")
    }
    
    func searchResultsCount() -> Int {
        
        return searchResults.count
    }
    
    func searchData(at index: Int) -> AdList? {
        
        if searchResults.count > index {
            return searchResults[index]
        }
        return nil
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
