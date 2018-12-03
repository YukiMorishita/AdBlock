//
//  Sub3TableViewController.swift
//  adblock-test
//
//  Created by admin on 2018/11/17.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import GoogleSignIn

class Sub3TableViewController: UITableViewController, GIDSignInUIDelegate {
    
    private var dataSource: Sub3DataSource!
    private var jsonManager: JsonManager!
    
    private let groupID = "jp.ac.osakac.cs.hisalab.adblock"
    private let key = "TableList4"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = Sub3DataSource()
        jsonManager = JsonManager()
        
        GIDSignIn.sharedInstance()?.uiDelegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //UITableViewを更新
        tableView.reloadData()
    }
    
    
    @IBAction func authButtonTaped(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // Google SignIn
        let signIn = UIAlertAction(title: "Sign In", style: .default, handler:
        {
            (action: UIAlertAction) in
            
            // Sign In
            GIDSignIn.sharedInstance()?.signIn()
            print("Google アカウントで、サインインしました。")
        })
        
        let signOut = UIAlertAction(title: "Sign Out", style: .default, handler:
        {
            (action: UIAlertAction) in
            
            // Sign Out
            GIDSignIn.sharedInstance()?.signOut()
            print("Google アカウントで、サインアウトしました。")
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(signIn)
        alert.addAction(signOut)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        
        return "test"//dataSource.sectionTitleData(at: section)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1//dataSource.sectionTitleCount()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return 1//dataSource.sectionDataCount(at: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) //as! Sub3CustomCell
        //cell.shareList = dataSource.data(at: indexPath.section, at: indexPath.row)

        return cell
    }
    
}
