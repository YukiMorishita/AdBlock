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
    private let key1 = "add"
    private let key2 = "share"
    
    // 取得した広告ドメインを保持
    private var acquiredAd = GetAd(domain: "", state: false)
    
    // acquiredAdを返す
    func getAcquiredAd() -> GetAd {
        
        return self.acquiredAd
    }
    
    // ホストアプリに取得した広告ドメインを共有する
    func shareDomain() {
        
        // 広告ドメインを共有
        let defaults = UserDefaults(suiteName: groupID)
        var acquiredDictionaries = [String: Any]()
        
        // 広告ドメインを保存
        acquiredDictionaries = ["domain": self.acquiredAd.domain, "state": self.acquiredAd.state]
        defaults?.set(acquiredDictionaries, forKey: key2)

        // 取得した広告ドメインを削除
        self.acquiredAd = GetAd(domain: "", state: false)
    }
    
    // acquiredAdを読み込む
    func load() {
        
        // 保存したacquiredAdを取得
        let defaults = UserDefaults(suiteName: groupID)
        let acquiredAdDictionaries = defaults?.object(forKey: key1) as? [String: Any]
        guard let ads = acquiredAdDictionaries else { return }
        
        // 取得したacquiredAdを設定
        self.acquiredAd = GetAd(domain: ads["domain"] as! String, state: ads["state"] as! Bool )
    }
    
    // acquiredAdを保存
    func save(acquiredAd: GetAd) {
        
        let defaults = UserDefaults(suiteName: groupID)
        var acquiredAdDictionaries = [String: Any]()
        
        // acquiredAdを保存
        acquiredAdDictionaries = ["domain": acquiredAd.domain, "state": acquiredAd.state]
        defaults?.set(acquiredAdDictionaries, forKey: key1)
    }
    
    // 指定したindexに対応するacquiredAdを返す (UITableViewに表示する値)
    func data(at index: Int) -> GetAd? {
        
        return acquiredAd
    }
    
    // 指定したindexに対応するadListSrcのメンバstateのBool値を変更する
    func changeSwitchState(at index: Int) {
        
        // リストを読み込み
        load()
        
        // index番目の要素がfalseの場合
        if self.acquiredAd.state == false {
            self.acquiredAd.state = true
            
            // index番目の要素がtrueの場合
        } else {
            self.acquiredAd.state = false
        }
        
        // 保存
        save(acquiredAd: self.acquiredAd)
        // 読み込み
        load()
    }
    
}
