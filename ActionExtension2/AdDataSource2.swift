//
//  AdDataSource2.swift
//  ActionExtension2
//
//  Created by admin on 2018/12/02.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation

final class AdDataSource2: NSObject {
    
    private let groupID = "group.jp.ac.osakac.cs.hisalab.adblock"
    private let hostAppKey = "TableList3"
    private let localSaveKey = "local2"
    private let extensionKey = "ActionExtension2"
    
    private var ad = Ad(domain: "", state: false)
    
    // ホストアプリに取得した広告ドメインを共有
    func shareDomainToHostApp() {
        
        let defaults = UserDefaults(suiteName: groupID)
        let adDic = ["domain": self.ad.domain, "state": self.ad.state] as [String : Any]
        
        defaults?.set(adDic, forKey: extensionKey)
    }
    
    // 取得した広告ドメインを読み込む
    func load() {
        
        let defaults = UserDefaults(suiteName: groupID)
        let adDic = defaults?.object(forKey: localSaveKey) as? [String: Any]
        guard let ad = adDic else { return }
        
        self.ad = Ad(domain: ad["domain"] as! String, state: ad["state"] as! Bool)
    }
    
    // 取得した広告ドメインを保存
    func save(ad: Ad) {
        
        let defaults = UserDefaults(suiteName: groupID)
        let adDic = ["domain": ad.domain, "state": ad.state] as [String: Any]
        
        defaults?.set(adDic, forKey: localSaveKey)
    }
    
    // UITableViewに表示する値を返す
    func data(at index: Int) -> Ad? {
        
        return self.ad
    }
    
    func retrieveAcquiredAd() -> [String] {
        
        var adList = [String]()
        
        let defaults = UserDefaults(suiteName: groupID)
        
        if (defaults?.object(forKey: hostAppKey) != nil) {
            let adDic = defaults?.object(forKey: hostAppKey) as? [[String: Any]]
            guard let ads = adDic else { return [""] }
            
            adList = ads.map { Ad(domain: $0["domain"] as! String, state: $0["state"] as! Bool) }.map { $0.domain }
        }
        
        return adList
    }
    
    // UISwitchの状態を切り替える
    func changeSwitchState() {
        
        // UISwitchの状態を切替
        if self.ad.state == false {
            self.ad.state = true
            
        } else {
            self.ad.state = false
        }
        
        save(ad: self.ad)
    }
    
}
