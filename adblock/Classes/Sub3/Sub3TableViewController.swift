//
//  Sub3TableViewController.swift
//  adblock-test
//
//  Created by admin on 2018/11/17.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import GoogleSignIn

class Sub3TableViewController: UITableViewController, GIDSignInUIDelegate {
    
    private var dataSource: Sub3DataSource!
    private var jsonManager: JsonManager!
    
    private let groupID = "jp.ac.osakac.cs.hisalab.adblock"
    private let key = "TableList4"
    
    /// FireBase DataBaseG
    private var dbRootRef: DatabaseReference!
    private var dbThisRef: DatabaseReference?
    private var dbTableData: [DataSnapshot] = [DataSnapshot]()
    
    private let randomKey = "-LSswgLbGSb6PkNDkBEn"
    
    private let group = "group"
    private let groups = "groups"
    private let document = "document"
    private let documents = "documents"
    
    private let dbKey1 = "name"
    private let dbKey2 = "rates"
    private let dbKey3 = "domains"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = Sub3DataSource()
        jsonManager = JsonManager()
        
        GIDSignIn.sharedInstance()?.uiDelegate = self
        
        // NotificationCenter (通知を登録)
        let notificationCenter = NotificationCenter.default
        // 通知の監視
        notificationCenter.addObserver(self, selector: #selector(observerPass), name: .databaseObserver, object: nil)
        // 通知の監視
        notificationCenter.addObserver(self, selector: #selector(starButtonTapedAlert), name: .starButtonTapedAlert, object: nil)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(Sub3CustomCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.dbRootRef = Database.database().reference()
        databaseObserver()
    }
    
    @objc func observerPass() {
        
        dataSource.setTableData(tableD: self.dbTableData)
    }
    
    func databaseObserver() {
        
        if let _ = Auth.auth().currentUser {
            
            self.dbThisRef = self.dbRootRef.child(document)
            
            self.dbThisRef?.observe(.value, with: { (snapshot) in
                
                var array = [DataSnapshot]()
                
                for item in snapshot.children {
                    
                    let child = item as! DataSnapshot
                    array.append(child)
                }
                
                self.dbTableData = array
                
                // UITableViewを更新 (通知を送る)
                let notiCenter = NotificationCenter.default
                notiCenter.post(name: .databaseObserver, object: nil)
                
                self.tableView.reloadData()
            })
        }
        
    }
    
    // データベースの更新
    func databaseWrite(name: String, rates: [Int], domains: [String], comment: [String]) {
        
        let uid = "-" + (Auth.auth().currentUser?.uid)!
        let relation = [uid: true as AnyObject]
        let _relation  = [randomKey: true as AnyObject]
        let rates = rates.filter { $0 > 0 }
        
        self.dbRootRef = Database.database().reference()
        self.dbThisRef = self.dbRootRef.child(group).child(randomKey).child(documents)
        
        // リレーションの構築
        let _data: Dictionary<String, AnyObject> = relation
        self.dbThisRef?.updateChildValues(_data)
        
        // 新規ファイルの追加
        self.dbThisRef = dbRootRef.child(document).child(uid)
        let _newData: Dictionary<String, AnyObject> = [dbKey1: name as AnyObject, dbKey2: rates as AnyObject, dbKey3: domains as AnyObject, groups: _relation as AnyObject]
        self.dbThisRef?.updateChildValues(_newData)
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
    
    @IBAction func uploadButtonTaped(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Upload", message: "upload", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:
        {
                (action) in
                
                print("cancel")
        }))
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler:
        {
                (action) in
                
                print("upload")
                
                let fileName = self.jsonManager.getJsonFileName()
                let domains = self.jsonManager.getDomains()
                
                self.databaseWrite(name: fileName, rates: [0], domains: domains, comment: [""])
        }))
        
        // アラート表示
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return dataSource.tableDataCount()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Sub3CustomCell
        cell.shareList = dataSource.data(at: indexPath.row)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "edit", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "edit" {
            
            if let index = tableView.indexPathForSelectedRow {
                
                let label = self.dbTableData[index.row].childSnapshot(forPath: self.dbKey1).value
                let rate = self.dbTableData[index.row].childSnapshot(forPath: self.dbKey2).value
                let domains = self.dbTableData[index.row].childSnapshot(forPath: self.dbKey3).value
                //let comments = self.dbTableData[index.row].childSnapshot(forPath: )
                
                let nextVC = segue.destination as! DetailViewController
                nextVC.EXTRA_Label = label as? String
                nextVC.EXTRA_Rate = rate as? [Int]
                nextVC.EXTRA_Domains = domains as? [String]
            }
        }
    }
    
    @objc func starButtonTapedAlert() {
        
        let alert = UIAlertController(title: "Submitted", message: "Thanks for your feedback.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alert, animated: true, completion: nil)
    }
    
}
