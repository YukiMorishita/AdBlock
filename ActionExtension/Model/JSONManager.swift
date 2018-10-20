//
//  JSONManager.swift
//  ActionExtension
//
//  Created by admin on 2018/10/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation

final class JSONManager: NSObject {
    
    // App Groups
    private let groupID = "group.jp.ac.osakac.cs.hisalab.adblock"
    
    // ファイル取得処理
    func getJsonFile() -> String {
        
        // ファイル名
        let fileName = "blockerList.json"
        let fileManager = FileManager.default
        
        // 共有JSONファイルのパスを設定
        let containerURL = (fileManager.containerURL(forSecurityApplicationGroupIdentifier: groupID)?.appendingPathComponent(fileName))!.path
        let fileExists = fileManager.fileExists(atPath: containerURL)
        // リソースJSONファイルのパスを設定
        let resourcePath = Bundle.main.path(forResource: fileName, ofType: nil)
        
        // JSON文字列
        var json = ""
        
        // 共有ファイルへのパスが存在した場合
        if fileExists {
            let jsonData = try? String(contentsOfFile: containerURL, encoding: String.Encoding.utf8)
            json = JSON(parseJSON: jsonData!).rawString()!
        }
        
        // 共有ファイルへのパスが存在しない場合
        if !fileExists {
            let jsonData = try? String(contentsOfFile: resourcePath!, encoding: String.Encoding.utf8)
            json = JSON(parseJSON: jsonData!).rawString()!
        }
        return json
    }
    
    // ドメインリスト生成処理
    func createDomainList() -> [String] {
        
        // ドメインリストを保持
        var domainList = [String]()
        // JSON文字列を設定
        let jsonStr = JSON(parseJSON: getJsonFile())
        // JSONStrの要素数を設定
        let jsonCount = jsonStr[].count
        
        // json文字列がある場合
        if jsonStr != "" {
            
            // json文字列からドメインを取得
            for i in 0...jsonCount - 1 {
                
                // domainListに追加
                let jsonTriggerURL = jsonStr[i]["trigger"]["url-filter"].rawString()
                domainList.append(jsonTriggerURL!)
            }
        }
        return domainList
    }
    
}
