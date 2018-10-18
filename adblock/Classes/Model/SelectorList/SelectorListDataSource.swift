//
//  SelectorListDataSource.swift
//  adblock
//
//  Created by admin on 2018/10/15.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation

final class SelectorListDataSource: NSObject {
    
    fileprivate var jsonManager: JSONManager!
    
    // App Groups
    private let groupID = "group.jp.ac.osakac.cs.hisalab.adblock"
    private let key1 = ""
    
    // UITableViewに表示する値を保持
    private var selectorList = [SelectorList]()
    
    // selectorListを返す
    func getSelectorList() -> [SelectorList] {
        
        return self.selectorList
    }
    
    // selectorListを生成
    func createSelectorList() {
        
        // インスタンスの生成
        jsonManager = JSONManager()
        
    }
    
    // selectorListを読み込む
    func loadList() {
        
    }
    
    // selectorListを保存
    func saveList(selectorList: [SelectorList]) {
        
    }
    
    // 指定したindexに対応するselectorListを返す (UITableViewに表示する値)
    func data(at index: Int) -> SelectorList? {
        
        if self.selectorList.count > index {
            return selectorList[index]
        }
        return nil
    }
    
    // 指定したindexに対応するselectorListのメンバstateのBool値を変更する
    func changeSwitchState(at index: Int) {
        
        
    }
}
