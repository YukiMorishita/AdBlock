//
//  AppGroupsManager.swift
//  adblock
//
//  Created by admin on 2018/08/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation

class AppGroupsManager: NSObject {
    private static let groupID = "group.jp.ac.osakac.cs.hisalab.adblock"
    
    // データとキーを指定して保存
    class func saveData(data: [[String: Any]], key: String) {
        let userDefaults = UserDefaults(suiteName: groupID)
        userDefaults?.set(data, forKey: key)
    }
    
    // キーを指定してデータを取得
    class func loadData(key: String) -> [[String: Any]]? {
        let userDefaults = UserDefaults(suiteName: groupID)
        return userDefaults?.object(forKey: key) as! [[String: Any]]?
    }
    
    // データとキーを指定してShare Extension保存
    class func sharedSaveData(data: String, key: String) {
        let sharedDefaults = UserDefaults(suiteName: groupID)
        sharedDefaults?.set(data, forKey: key)
    }
    
    // キーを指定してShare Extensionデータを取得
    class func sharedLoadData(key: String) -> String? {
        let sharedDefaults = UserDefaults(suiteName: groupID)
        return sharedDefaults?.object(forKey: key) as! String?
    }
}

// How to Use

// Save
//let data: [[String: Any]] = adList.map { ["text": $0.text, "switchs": $0.switchs] }
//AppGroupsManager.saveData(data: data, key: "ad")

// Load
//if let load = AppGroupsManager.loadData(key: "ad") {
//adList = load.map { (text: $0["text"], switchs: $0["switchs"]) } as! [(text: String, switchs: Bool)]
//print(adList)
//}

