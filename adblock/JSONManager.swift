//
//  JSONManager.swift
//  adblock
//
//  Created by admin on 2018/08/21.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation

class JSONManager: NSObject {
    
    // AppGroups ID
    private static let groupID = "group.jp.ac.osakac.cs.hisalab.adblock"
    
    // JSONファイルを取得するメソッド（ 共有ファイル || リソース ）
    class func getJSONFile() -> String {
        // JSON文字列
        var json = ""
        // JSONファイルの名前
        let jsonFileName = "blockerList.json"
        /* ファイルマネージャーの設定 */
        let fileManager = FileManager.default
        // 共有ファイルのパス
        let containerURL = (fileManager.containerURL(forSecurityApplicationGroupIdentifier: groupID)?.appendingPathComponent(jsonFileName))!.path
        // ファイルの有無
        let fileExists = fileManager.fileExists(atPath: containerURL)
        
        // JSONファイルのフルパスが存在する場合
        if fileExists {
            // JSONデータを文字列で設定
            let jsonData = try? String(contentsOfFile: containerURL, encoding: String.Encoding.utf8)
            // JSONデータをパース（解析）
            json = JSON(parseJSON: jsonData!).rawString()!
            
            // JSONファイルのフルパスが存在しない場合
        } else {
            // リソースのJSONファイルのパスを設定
            let resourcePath = Bundle.main.path(forResource: jsonFileName, ofType: nil)
            // JSONデータを文字列で設定
            let jsonData = try? String(contentsOfFile: resourcePath!, encoding: String.Encoding.utf8)
            // JSONデータをパース（解析）
            json = JSON(parseJSON: jsonData!).rawString()!
        }
        // JSON文字列を戻す
        return json
    }
    
    // 共有ファイルに書き込むメソッド
    class func createJSONFile(adList: [(text: String, switchs: Bool)]) {
        // 書き込むファイル名
        let jsonFileName = "blockerList.json"
        // フラグ
        var flag = false
        // 書き込むJSON文字列
        var jsonRule = ""
        
        /* ファイルマネージャーの設定 */
        let fileManager = FileManager.default
        // 共有ファイルのパス
        let containerURL = (fileManager.containerURL(forSecurityApplicationGroupIdentifier: groupID)?.appendingPathComponent(jsonFileName))!.path
        // ファイルの有無
        let fileExists = fileManager.fileExists(atPath: containerURL)
        
        // ブロックリストからスイッチがONの状態のtextを取得
        let writeURL = adList.filter { $0.switchs == true }.map { $0.text }
        // 1回だけの処理
        flag = (flag == false) ? true : flag
        // 1度目の時は、カギカッコと改行, 2度目の時は、何もしない
        jsonRule += (flag == true) ? "[\n" : ""
        
        // writeURLに要素がある場合
        if writeURL.isEmpty == false {
            // writeURLの要素数繰り返す
            for url in writeURL {
                jsonRule +=
                """
                    {
                        "action": {
                            "type": "block"
                        },
                        "trigger": {
                            "url-filter": "\(url)",
                            "load-type": [
                                "third-party"
                            ]
                        }
                    }
                """
                
                // 繰り返しが途中なら改行してカンマ, 最後なら改行してカギカッコ
                jsonRule += (url != writeURL.last!) ? ",\n" : "\n]\n"
            }
            
            /* 書き込みの設定 */
            do {
                try jsonRule.write(toFile: containerURL, atomically: true, encoding: String.Encoding.utf8)
                // 書き込みに失敗した場合
            } catch let error as NSError {
                print("failed to write: \(error)")
            }
            
            // 共有ファイルが存在し、書き込む文字列がない場合
        } else if fileExists && writeURL.isEmpty == true {
            print("not data")
            //　書き込むJSON文字列
            let jsonText =
            """
                [
                    {
                        "action": {
                            "type": "block"
                        },
                        "trigger": {
                            "url-filter": ".*",
                            "if-domain": [".*"]
                        }
                    }
                ]
            """
            
            // ファイルの書き込み(空白)
            do {
                try jsonText.write(toFile: containerURL, atomically: true, encoding: String.Encoding.utf8)
                // 書き込みに失敗した場合
            } catch let error as NSError {
                print("failed to write: \(error)")
            }
            
            // 共有ファイルを作らない
        } else {
            print("not create shared file")
        }
        
    }
    
    // JSON文字列からurl-filterのみを取得し、配列に格納するメソッド
    class func createURLFilterArray() -> Array<String> {
        // JSONデータから取得したURLを設定
        var jsonURLArray = [String]()
        // JSONデータの文字列を設定
        let jsonText = JSON(parseJSON: self.getJSONFile())
        // JSONデータの要素数を設定
        let jsonCount = jsonText[].count
        
        // jsonTextに文字列がある場合
        if jsonText != "" {
            // JSON要素の数繰り返す 0から始まるが、リストの数は1から始まるため-1を行う
            for i in 0...jsonCount - 1 {
                // jsonデータのトリガからurl-filterを取得
                let jsonTriggerURL = jsonText[i]["trigger"]["url-filter"].rawString()
                // 配列に取得したJSONデータのurl-filterを設定
                jsonURLArray.append(jsonTriggerURL!)
            }
        }
        // JSONデータのurl-filterを設定し,配列を戻す
        return jsonURLArray
    }
    
}
