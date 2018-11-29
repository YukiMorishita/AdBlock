//
//  ContentBlockerManager.swift
//  adblock-test
//
//  Created by admin on 2018/11/29.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
import SafariServices

final class ContentBlockerManager: NSObject {
    
    // ContentBlocker BundleID
    private let contentBlockerID = "jp.ac.osakac.cs.hisalab.adblock-test.ContentBlockerExtension"
    
    // ContentBlockerの更新メソッド
    func reloadContentBlocker() {
        SFContentBlockerManager.reloadContentBlocker(withIdentifier: contentBlockerID)
        {
            (error) in
            
            if let error = error {
                print(error as NSError)
            } else {
                print("Content Blocker Succesfully Reloaded")
            }
        }
    }
    
    // ContentBlockerの状態確認メソッド
    func stateContentBlocker() {
        SFContentBlockerManager.getStateOfContentBlocker(withIdentifier: contentBlockerID)
        {
            (state: SFContentBlockerState?, error: Error?) in
            
            if state?.isEnabled == true {
                print("Enable")
            } else {
                print("Disable")
            }
        }
    }
    
}
