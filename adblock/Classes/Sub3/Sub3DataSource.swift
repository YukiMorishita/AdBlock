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
    
    /// FireBase DataBaseG
    private var dbRootRef: DatabaseReference!
    private var dbThisRef: DatabaseReference?
    private var dbTableData: [DataSnapshot] = [DataSnapshot]()
    
    private let groupid = "-LSswgLbGSb6PkNDkBEn"
    
    private let group = "group"
    private let groups = "groups"
    private let document = "document"
    private let documents = "documents"
    
    private let dbKey1 = "name"
    private let dbKey2 = "rates"
    private let dbKey3 = "domains"
    
    private var tableData = [DataSnapshot]()
    
    func getTableData() -> [DataSnapshot]? {
        
        return self.tableData
    }
    
    func ratingAverage() -> String {
        
        let group = self.tableData.map { $0.childSnapshot(forPath: "group").key }
        print(group)

//        let rates = self.tableData.map { $0.childSnapshot(forPath: "rates") }
//
//        print(rates)
        
        return "3"
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


