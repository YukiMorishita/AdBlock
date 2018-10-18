//
//  GetAdDataSource.swift
//  ActionExtension
//
//  Created by admin on 2018/10/15.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation

final class GetAdDataSource: NSObject {
    
    // AppGroups
    private let groupID = "group.jp.ac.osakac.cs.hisalab.adblock"
    private let key1 = "share"
    
    // 取得した広告ドメインを保持
    private var acquiredAd = [GetAd]()
    
    // acquiredAdを返す
    func getAcquiredAd() -> [GetAd] {
        
        return self.acquiredAd
    }
    
    // acquiredAdを読み込む
    func load() {
        
        // 保存したacquiredAdを取得
        let defaults = UserDefaults(suiteName: groupID)
        let acquiredAdDictionaries = defaults?.object(forKey: key1) as? [[String: Any]]
        guard let ads = acquiredAdDictionaries else { return }
        
        // 取得したacquiredAdを設定
        self.acquiredAd = ads.map { GetAd(domain: $0["domain"] as! String, state: $0["state"] as! Bool) }
    }
    
    // acquiredAdを保存
    func save(acquiredAd: [GetAd]) {
        
        let defaults = UserDefaults(suiteName: groupID)
        var acquiredAdDictionaries = [[String: Any]]()
        
        // acquiredAdを保存
        acquiredAdDictionaries = acquiredAd.map { ["domain": $0.domain, "state": $0.state] }
        defaults?.set(acquiredAdDictionaries, forKey: key1)
    }
    
    // acquiredAdの総数を返す (UITableViewのCell数)
    func acquiredAdCount() -> Int {
        
        return self.acquiredAd.count
    }
    
    // 指定したindexに対応するacquiredAdを返す (UITableViewに表示する値)
    func data(at index: Int) -> GetAd? {
        
        if self.acquiredAd.count > index {
            return self.acquiredAd[index]
        }
        return nil
    }
    
}
