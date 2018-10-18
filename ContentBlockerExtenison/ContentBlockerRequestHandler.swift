//
//  ContentBlockerRequestHandler.swift
//  ContentBlockerExtenison
//
//  Created by admin on 2018/10/03.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import MobileCoreServices

enum BlockerError: Error {
    case LoadFailed
}

class ContentBlockerRequestHandler: NSObject, NSExtensionRequestHandling {
    
    /* App Groups */
    // Group ID
    let suiteName: String = "group.jp.ac.osakac.cs.hisalab.adblock"
    
    // ブロックリストを読み込むメソッド
    func beginRequest(with context: NSExtensionContext) {
        print("adblockのスイッチを切り替えることで最読み込み")
        // JSONファイル名
        let jsonFileName = "blockerList.json"
        
        /* ファイルマネージャー */
        let fileManager = FileManager.default
        let containerURL: URL = (fileManager.containerURL(forSecurityApplicationGroupIdentifier: suiteName)?.appendingPathComponent(jsonFileName))!
        // ファイルの存在確認
        let fileExists: Bool = fileManager.fileExists(atPath: containerURL.path)
        
        // ファイルが存在する場合
        if fileExists {
            let attachment = NSItemProvider(contentsOf: containerURL)
            
            let item = NSExtensionItem()
            item.attachments = [attachment!]
            
            context.completeRequest(returningItems: [item], completionHandler: nil)
            // ファイルが存在しない場合
        } else {
            print("Could not load the blocker list JSON")
            context.cancelRequest(withError: BlockerError.LoadFailed)
        }
    }
    
}

