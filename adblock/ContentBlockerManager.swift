//
//  ContentBlockerManager.swift
//  adblock
//
//  Created by admin on 2018/08/20.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
import SafariServices

class ContentBlockerManager: NSObject {
    // ContentBlocker BundleID
    private static let contentBlockerID = "jp.ac.osakac.cs.hisalab.adblock.content-blocker"
    
    // ContentBlockerの更新メソッド
    class func reloadContentBlocker() {
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
    class func stateContentBlocker() {
        // UserDefaults
        let defaults = UserDefaults.standard
        SFContentBlockerManager.getStateOfContentBlocker(withIdentifier: contentBlockerID)
        {
            (state: SFContentBlockerState?, error: Error?) in
            
            if state?.isEnabled == true {
                //print("true")
                defaults.set(state?.isEnabled, forKey: "State")
            } else {
                //print("false")
                defaults.set(state?.isEnabled, forKey: "State")
            }
        }
        
    }
    
    
}
