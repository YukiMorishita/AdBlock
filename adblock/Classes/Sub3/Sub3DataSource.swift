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
    
    private var tableList = [Share]()
    private var tableData = [DataSnapshot]()
    
    func createTableList() {
        
        jsonManager = JsonManager()
        
        let fileName = jsonManager.getJsonFileName()
        print(fileName)
    }
    
    func load() {
        
        let defaults = UserDefaults(suiteName: groupID)
        let tableListDic = defaults?.object(forKey: key) as? [[String: Any]]
        guard let tables = tableListDic else { return }
        
        // 取得したothersListを設定
        self.tableList = tables.map { Share(name: $0["name"] as! String, rate: $0["rate"] as! Int) }
    }
    
    func save() {
        
        let defaults = UserDefaults(suiteName: groupID)
        let tableListDic = self.tableList.map { ["name": $0.name, "rate": $0.rate] }
        
        defaults?.set(tableListDic, forKey: key)
    }
    
    func tableDataCount() -> Int {
        
        return self.tableData.count
    }
    
    func data(at index: Int) -> DataSnapshot? {
        
        if self.tableData.count > index {
            
            return self.tableData[index]
        }
        
        return nil
    }
    
    func setTableData(tableD: [DataSnapshot]) {
        
        self.tableData = tableD
    }
    
    /// Firebase Cloud Storage
    private var storageRef: StorageReference!
    
    
}


