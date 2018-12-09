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
    
    private let groupID = "group.jp.ac.osakac.cs.hisalab.adblock"
    private let key = "TableList4"
    
    private var ratingAvg = [(avg: Int, name: String)]()
    
    /// FireBase DataBaseG
    private var dbRootRef: DatabaseReference!
    private var dbThisRef: DatabaseReference?
    private var dbTableData: [DataSnapshot] = [DataSnapshot]()
    
    private let groupid = "-LSswgLbGSb6PkNDkBEn"
    
    private let group = "group"
    private let groups = "groups"
    private let document = "document"
    private let documents = "documents"
    
    private let dbKey1 = "name"
    private let dbKey2 = "rates"
    private let dbKey3 = "comment"
    private let dbKey4 = "domains"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = Sub3DataSource()
        jsonManager = JsonManager()
        
        
        GIDSignIn.sharedInstance()?.uiDelegate = self
        
        // NotificationCenter (通知を登録)
        let notificationCenter = NotificationCenter.default
        // 通知の監視
        notificationCenter.addObserver(self, selector: #selector(observerPass), name: .databaseObserver, object: nil)
        notificationCenter.addObserver(self, selector: #selector(downloadAlert), name: .downloadAlert, object: nil)
        
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
    
    func databaseObserver() {
        
        print("change database data")
        
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
    
    func ratingAverage() {
        
        let groups = self.dbTableData.map { $0.key }
        var names = [String]()
        let rates = "rates"
        var index = 0
        var childDocument = [DataSnapshot]()
        
        // 平均レートをリセット
        self.ratingAvg.removeAll()
        
        for i in 0..<groups.count {
            
            names.append(self.dbTableData[i].childSnapshot(forPath: "name").value as! String)
        }
        
        // database のデータを取得
        for i in 0..<groups.count {
            
            childDocument.append( dataSource.data(at: i)! )
        }
        
        // database のratesを取得
        for document in childDocument {
            
            var rateList = [Int]()
            // ratesのデータ数
            let childCount = document.childSnapshot(forPath: rates).childrenCount
            
            for i in 0..<childCount {
                
                let rates = document.childSnapshot(forPath: rates).childSnapshot(forPath: groups[Int(i)]).value
                rateList.append(rates as! Int)
            }
            
            var total = 0
            
            // 各、rateの合計
            for rate in rateList {
                
                total += rate
            }
            
            // 各、平均を取得
            let avg = total / rateList.count
            ratingAvg.append((avg: avg, name: names[index]))
            
            index += 1
        }
        
        // 平均データを保存
        let defaults = UserDefaults(suiteName: groupID)
        let rateAvgDic = ratingAvg.map { ["avg": $0.avg, "name": $0.name] }
        defaults?.set(rateAvgDic, forKey: "ratingAvg")
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
                let rateAvg = self.ratingAvg[index.row].avg
                let comment = self.dbTableData[index.row].childSnapshot(forPath: self.dbKey3).value
                let domains = self.dbTableData[index.row].childSnapshot(forPath: self.dbKey4).value
                
                let documentID = self.dbTableData[index.row].key
                
                let nextVC = segue.destination as! DetailViewController
                nextVC.EXTRA_Label = label as? String
                nextVC.EXTRA_Rate = rate as? [Int]
                nextVC.EXTRA_RateAvg = rateAvg
                nextVC.EXTRA_Comment = comment as? String
                nextVC.EXTRA_Domains = domains as? [String]
                nextVC.EXTRA_ID = documentID
            }
        }
    }
    
    @objc func downloadAlert() {
        
        let alert = UIAlertController(title: "Download", message: "Download complete", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alert) in
            
            print("download")
            
//            // UITableViewを更新 (通知を送る)
//            let notiCenter = NotificationCenter.default
//            notiCenter.post(name: .tableDataReload, object: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // 非同期処理のコールバック
    @objc func observerPass() {
        
        dataSource.setTableData(tableD: self.dbTableData)
        ratingAverage()
    }
    
}
