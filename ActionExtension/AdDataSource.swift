//
//  AdDataSource.swift
//  ActionExtension
//
//  Created by admin on 2018/11/17.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation

final class AdDataSource: NSObject {
    
    private let groupID = "jp.ac.osakac.cs.hisalab.adblock-test"
    private let localSaveKey = "local"
    private let extensionKey = "ActionExtension"
    
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
    func data() -> Ad? {
        
        return self.ad
    }
    
    func retrieveAcquiredAd() -> [String] {
        
        var adList = [String]()
        
        let defaults = UserDefaults(suiteName: groupID)

        if (defaults?.object(forKey: "adList") != nil) {
            let adDic = defaults?.object(forKey: "adList") as? [[String: Any]]
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
