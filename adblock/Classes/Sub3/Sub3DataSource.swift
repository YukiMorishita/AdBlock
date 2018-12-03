//
//  Sub3DataSource.swift
//  adblock-test
//
//  Created by admin on 2018/11/26.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

final class Sub3DataSource: NSObject {
    
    private var jsonManager: JsonManager!
    
    private let groupID = "group.jp.ac.osakac.cs.hisalab.adblock"
    private let key = "TableList4"
    
    private let sectionTitle = ["MY DomainList", "Share DomainLists "]
    private let myList = [Domain]()
    private var shareList = [Domain]()
    private var tableList = [[Domain]]()
    
    func setMyList() {
        
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupID)// [plist, Library, blockerList.json] ブロックリストのディレクトリを作成する必要がある。
        
        do {
            let contentUrls = try FileManager.default.contentsOfDirectory(at: url!, includingPropertiesForKeys: nil)
            let files = contentUrls.map{$0.lastPathComponent}
            print(files) //-> ["test1.txt", "test2.txt"]
//            let jsonFile = files.filter { $0.contains(".json") }
//            print(jsonFile)
        } catch {
            print(error)
        }
        
        // 自分のドメインリスト名を取得
        
        // 配列に追加
    }
    
    func setShareList() {
        
        // データベースからデータを取得
        
        // 配列に追加
    }
    
    func createTableList() {
        
        self.tableList = [self.myList + self.shareList]
    }
    
    func load() {
        
        let defaults = UserDefaults(suiteName: groupID)
        let tableListDic = defaults?.object(forKey: key) as? [[[String: Any]]]
        guard let tables = tableListDic else { return }
        
        // 取得したothersListを設定
        self.tableList = tables.map { $0.map { Domain(domain: $0["domain"] as! String, state: $0["state"] as! Bool) } }
    }
    
    func save() {
        
        let defaults = UserDefaults(suiteName: groupID)
        let tableListDic = self.tableList.map { $0.map { ["domain": $0.domain, "state": $0.state] } }
        
        defaults?.set(tableListDic, forKey: key)
    }
    
    func sectionTitleCount() -> Int {
        
        return self.sectionTitle.count
    }
    
    func sectionTitleData(at section: Int) -> String {
        
        if self.sectionTitle.count > section {
            
            return self.sectionTitle[section]
        }
        
        return ""
    }
    
    func sectionDataCount(at section: Int) -> Int {
        
        if self.tableList.count > section {
            
            let sectionData = self.tableList[section]
            return sectionData.count
        }
        
        return 0
    }
    
    func data(at section: Int, at index: Int) -> Domain? {
        
        if self.tableList.count > section {
            let sectionData = self.tableList[section]
            let cellData = sectionData[index]
            return cellData
        }
        
        return nil
    }
    
    /// FireBase DataBaseG
    private var dbRootRef: DatabaseReference!
    private var dbThisRef: DatabaseReference?
    private var dbTableData: [DataSnapshot] = [DataSnapshot]()
    
    private let dbPath = "documents"
    private let dbKey1 = "fileName"
    private let dbKey2 = "rate"
    private let dbKey3 = "domains"
    
    func databaseObserver() {
        
        if let _ = Auth.auth().currentUser {
            
            self.dbThisRef = self.dbRootRef.child(dbPath)
        }
    }
    
    /// Firebase Cloud Storage
    private var storageRef: StorageReference!
    
    
}
