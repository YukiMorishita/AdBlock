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
    //private var adList = [AdList]()
    fileprivate var jsonManager: JSONManager!
    
    func adListUni() {
        
        //RemoveAdList()
        //adList = adList
        //saveList(adList: adList)
    }
    
    func createDefaultAdList() {
        
        // インスタンスの生成
        let jsonManager = JSONManager()
        // ドメインリストの生成
        for domain in jsonManager.createDomainList() {
            let ad = AdList(domain: domain, state: false)
            // 初期データは同期
            adList.append(ad) // ドメインをadListに追加
            //adList.append(ad)
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
        adListDictionaries = adList.map { ["domain": $0.domain, "state": $0.state] }
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
    
    func getAdList() -> [AdList] {
        
        return adList
    }

    
    func getDomain() -> [String] {
        
        var domainList = [String]()
        
        for ad in self.adList {
            domainList.append(ad.domain)
        }
        
        return domainList
    }
    
    func RemoveAdList() {
        
        self.adList.removeAll()
        saveList(adList: adList)
    }
    
    // タップしたスイッチのインデックスを取得し、adListにスイッチのON・OFFを保存
    func switchStateDidChangeAdList(domain: String) {
        
        // ドメイン一覧を保持
        var adList = [String]()
        // adListを読み込む
        loadList()
        
        // domainList生成
        for ad in self.adList {
            adList.append(ad.domain)
        }
        
        // adListから引数であるドメインを検索
        let index = adList.findIndex(includeElement: { $0 == domain })
        // 引数のドメインがdomainListにあれば、スイッチの状態を切り替える
        if index.isEmpty == false {
            if self.adList[index[0]].state == false {
                self.adList[index[0]].state = true
            } else {
                self.adList[index[0]].state = false
            }
            saveList(adList: self.adList) // 保存
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
