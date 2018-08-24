//
//  MainViewController.swift
//  adblock
//
//  Created by admin on 2018/08/21.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var contentBlockerStateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contentBlockerStateLabel.text = (ContentBlockerManager.stateContentBlocker()) ? "Enable" : "Disable"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
