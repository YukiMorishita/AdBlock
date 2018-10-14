//
//  JSONManager.swift
//  adblcok-test
//
//  Created by admin on 2018/09/29.
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
        let fileExits = fileManager.fileExists(atPath: containerURL)
        // リソースJSONファイルのパスを設定
        let resourcePath = Bundle.main.path(forResource: fileName, ofType: nil)
        
        // JSON文字列
        var json = ""
        
        // 共有ファイルへのパスが存在した場合
        if fileExits {
            let jsonData = try? String(contentsOfFile: containerURL, encoding: String.Encoding.utf8)
            json = JSON(parseJSON: jsonData!).rawString()!
        }
        
        // 共有ファイルへのパスが存在しない場合
        if !fileExits {
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
    
    // 共有ファイルに書き込む文字列を生成する処理
    func createJsonFile(adList: [AdList]) {
        
        // ファイル名
        let fileName = "blockerList.json"
        let fileManager = FileManager.default
        
        // 共有JSONファイルのパスを設定
        let containerURL = (fileManager.containerURL(forSecurityApplicationGroupIdentifier: groupID)?.appendingPathComponent(fileName))!.path
        let fileExits = fileManager.fileExists(atPath: containerURL)
        
        // スイッチの状態がONのドメインを保持
        let domainList = adList.filter { $0.state == true }.map { $0.domain }
        // 書き込むブロックルール
        var writeStr = ""
        
        // domainListに要素がある場合
        if domainList.isEmpty == false {
            
            // ブロックルールの生成
            for domain in domainList {
                
                // domainListが最初の場合 [ を記述する
                writeStr += (domain != domainList.first!) ? "" : "[\n"
                
                // ドメインごとにブロックルールを生成
                writeStr +=
                """
                    {
                        "action": {
                            "type": "block"
                        },
                        "trigger": {
                            "url-filter": "\(domain)",
                            "load-type": ["third-party"]
                        }
                    }
                """
                
                // domainListが最後の場合 ] を記述する
                writeStr += (domain != domainList.last!) ? ",\n" : "\n]\n"
            }
            
            // 共有ファイルへの書き込み
            // 書き込みに成功した場合
            do {
                try writeStr.write(toFile: containerURL, atomically: true, encoding: String.Encoding.utf8)
                // 書き込みに失敗した場合
            } catch let error as NSError {
                print("failed to write: \(error)")
            }
            
            print("1: created shared file")
        }
        
        // 共有ファイルが存在し、domainListに要素がない場合
        if fileExits && domainList.isEmpty == true {
            
            // ブロックルール生成
            writeStr =
            """
                [
                    {
                        "aciton": {
                            "type": "block"
                        },
                        "trigger": {
                            "url-filter": ".*",
                            "if-domain": [".*"]
                        }
                    }
                ]
            """
            
            // 共有ファイルへの書き込み
            // 書き込みに成功した場合
            do {
                try writeStr.write(toFile: containerURL, atomically: true, encoding: String.Encoding.utf8)
                // 書き込みに失敗した場合
            } catch let error as NSError {
                print("failed to write: \(error)")
            }
            
            print("2: created shared file")
        }
        
        // 共有ファイルが存在せず、domainListに要素がない場合
        if !fileExits && domainList.isEmpty == true {
            
            print("not created shared file")
        }
    }
    
}
