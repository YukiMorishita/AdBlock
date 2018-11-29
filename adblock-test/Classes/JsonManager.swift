//
//  JsonManager.swift
//  adblock-test
//
//  Created by admin on 2018/11/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation

final class JsonManager: NSObject {
    
    private let groupID = "group.jp.ac.osakac.cs.hisalab.adblock"
    private let tableKey1 = "TableList1"
    private let tableKey2 = "TableList2"
    private let tableKey3 = "TableList3"
    private let tableKey4 = "TableList4"
    
    func getJsonFileName() -> String {
        
        var jsonFileName = ""
        let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupID)
        
        do {
            let containerDir = try FileManager.default.contentsOfDirectory(at: containerURL!, includingPropertiesForKeys: nil)
            let dir = containerDir.map { $0.lastPathComponent }.filter { $0.contains(".json") }
            
            if dir.isEmpty == false {
                jsonFileName = dir.last!
            }
            
            if dir.isEmpty == true {
                jsonFileName = "blockerList.json"
            }
        } catch let error as NSError{
            print("failed to json file: \(error)")
        }
        
        return jsonFileName
    }
    
    func readJsonFile(fileName: String = "blockerList") -> String {
        
        var jsonText = "" // 戻り値
        let jsonFileName = fileName + ".json" // 読み込むファイル名
        
        let resourcePath = Bundle.main.path(forResource: jsonFileName, ofType: nil)
        let resourceURL = URL(fileURLWithPath: resourcePath!)
        
        let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupID)?.appendingPathComponent(jsonFileName)
        let fileExists = FileManager.default.fileExists(atPath: containerURL!.path)
        
        // Read File
        if fileExists {
            print("read container file")
            do {
                jsonText = try String(contentsOf: containerURL!, encoding: String.Encoding.utf8)
            } catch let error as NSError {
                print("failed to read: \(error)")
            }
        }
        
        if !fileExists {
            print("read resource file")
            do {
                jsonText = try String(contentsOf: resourceURL, encoding: String.Encoding.utf8)
            } catch let error as NSError {
                print("failed to read: \(error)")
            }
        }
        
        return jsonText
    }
    
    func createAndWriteJsonFile() {
        
        let jsonFileName = getJsonFileName()
        var jsonText = createAdListToJsonText() + createAdvancedListToJsonText() + createEachSiteListToJsonText()
        
        if jsonText.isEmpty == true {
            
            // 全てのドメインをブロックしないルールを作成
            jsonText =
            """
                {
                    "action": {
                        "type": "block"
                    },
                    "trigger": {
                        "url-filter": ".*",
                        "if-domain": [".*"]
                    }
                },
            
            """
        }
        
        let writeJsonText = "[\n" + String(jsonText.prefix(jsonText.count - 2)) + "\n]" + "\n"
        // ⬆ [ + \n + (createAd + createOthers) + ここで、「,」の文字を削る + \n + ] + \n//
        
        let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupID)?.appendingPathComponent(jsonFileName)
        
        do {
            print("create and write file")
            try writeJsonText.write(to: containerURL!, atomically: true, encoding: String.Encoding.utf8)
        } catch let error as NSError {
            print("failed to write: \(error)")
        }
        
        print(writeJsonText)
        
    }
    
    func changeJsonFileName(changeFileName: String) {
        
        let JsonFileName = getJsonFileName()
        let changeJSONFileName = changeFileName + ".json"
        let ContainerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupID)?.appendingPathComponent(JsonFileName)
        let changeContainerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupID)?.appendingPathComponent(changeJSONFileName)
        
        do {
            try FileManager.default.moveItem(at: ContainerURL!, to: changeContainerURL!)
        } catch let error as NSError {
            print("failed to cahnge file name: \(error)")
        }
        
    }
    
    func createDomainList() -> [String] {

        var domainList = [String]()
        let jsonText = JSON(parseJSON: readJsonFile())
        let jsonCount = jsonText[].count

        for i in 0...jsonCount - 1 {

            let jsonTriggerURL = jsonText[i]["trigger"]["url-filter"].rawString()
            domainList.append(jsonTriggerURL!)
        }

        return domainList
    }
    
    func createAdListToJsonText() -> String {
        
        var jsonText = ""
        
        let dataSource = RootDataSource()
        
        dataSource.load()
        let adList = dataSource.getAdList()
        let domainList = adList.filter { $0.state == true }.map { $0.domain }
        
        if domainList.isEmpty == false {
            
            // ドメインごとにブロックルールを作成
            for domain in domainList {
                jsonText +=
                """
                    {
                        "action": {
                            "type": "block"
                        },
                        "trigger": {
                            "url-filter": "\(domain)",
                            "load-type": ["third-party"]
                        }
                    },
                
                """
            }
        }
        
        return jsonText
    }
    
    func createAdvancedListToJsonText() -> String {
        
        // JSON文字列
        var jsonText = ""
        
        let dataSource = Sub1DataSource()
        
        dataSource.load()
        let advanceList = dataSource.getAdvanceList()
        
        if advanceList.isEmpty == false {
            
            let sectionNum = advanceList.count
            
            for s in 0..<sectionNum {
                // 読み込むJSONファイル名を設定
                let readFileName = advanceList[s].filter { $0.state == true }.map { $0.label }
                
                // ファイルを読み込む
                for i in 0..<readFileName.count {
                    jsonText += readJsonFile(fileName: readFileName[i])
                }
            }
        }
        
        if !advanceList.isEmpty == true {
            
            // 空文字を設定
            jsonText += ""
        }
        
        return jsonText
    }
    
    func createEachSiteListToJsonText() -> String {
        
        var jsonText = ""
        
        let dataSource = Sub2DataSource()
        
        dataSource.load()
        let eachSiteList = dataSource.getEachSiteList()
        let domainList = eachSiteList.filter { $0.state == true }.map { $0.domain }
        
        if domainList.isEmpty == false {
            
            // ドメインごとにブロックルールを作成
            for domain in domainList {
                jsonText +=
                """
                    {
                        "action": {
                            "type": "block"
                        },
                        "trigger": {
                            "url-filter": "\(domain)",
                            "load-type": ["third-party"]
                        }
                    },
                
                """
            }
        }
        
        return jsonText
    }
    
    // Test
    func removeJsonFile(fileName: String) {
        
        let jsonFileName = fileName + ".json"
        let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupID)?.appendingPathComponent(jsonFileName)
        
        do {
            try FileManager.default.removeItem(at: containerURL!)
        } catch let error as NSError {
            print(error)
        }
        
    }

}
