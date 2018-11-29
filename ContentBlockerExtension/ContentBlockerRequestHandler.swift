//
//  ContentBlockerRequestHandler.swift
//  ContentBlockerExtension
//
//  Created by admin on 2018/11/17.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import MobileCoreServices

enum BlockerError: Error {
    case LoadFailed
}

class ContentBlockerRequestHandler: NSObject, NSExtensionRequestHandling {
    
    private let groupID: String = "group.jp.ac.osakac.cs.hisalab.adblock"
    
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

    func beginRequest(with context: NSExtensionContext) {
        
        let jsonFileName = getJsonFileName()
        let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupID)?.appendingPathComponent(jsonFileName)
        let fileExists = FileManager.default.fileExists(atPath: containerURL!.path)
        
        if fileExists {
            let attachment = NSItemProvider(contentsOf: containerURL)
        
            let item = NSExtensionItem()
            item.attachments = [attachment] as? [NSItemProvider]
        
            context.completeRequest(returningItems: [item], completionHandler: nil)
        }
        
        if !fileExists {
            print("Could not load the blocker list JSON")
            context.cancelRequest(withError: BlockerError.LoadFailed)
        }
        
    }
    
}
