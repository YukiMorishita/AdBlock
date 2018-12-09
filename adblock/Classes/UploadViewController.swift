//
//  UploadViewController.swift
//  adblock
//
//  Created by admin on 2018/12/08.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class UploadViewController: UIViewController {
    
    private var jsonManager: JsonManager!
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var uploadButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let toolBar1: UIToolbar = UIToolbar()
        let toolBar2: UIToolbar = UIToolbar()
        
        toolBar1.barStyle = UIBarStyle.default
        toolBar1.sizeToFit()
        
        toolBar2.barStyle = UIBarStyle.default
        toolBar2.sizeToFit()
        
        let spacer:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        
        let doneButton1:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(textFieldCloseKeyBoard(textView:)))
        let doneButton2:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(textViewCloseKeyBoard(textView:)))
        
        let toolBarItems1 = [spacer, doneButton1]
        let toolBarItems2 = [spacer, doneButton2]
        
        toolBar1.setItems(toolBarItems1, animated: true)
        toolBar2.setItems(toolBarItems2, animated: true)
        
        textField.inputAccessoryView = toolBar1
        commentTextView.inputAccessoryView = toolBar2
        
        commentTextView.layer.cornerRadius = 10.0
        textView.layer.cornerRadius = 10.0
        textView.isEditable = false
        uploadButton.layer.cornerRadius = 10.0
        
        textField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        jsonManager = JsonManager()
        
        let _name = nameText(name: jsonManager.getJsonFileName())
        let _domains = jsonManager.getDomains()
        
        textField.placeholder = _name
        textView.text = domainsText(domains: _domains)
    }
    
    func nameText(name: String) -> String {
        
        let nameText = String(name.prefix(name.count - 5))
        
        return nameText
    }
    
    func domainsText(domains: [String]) -> String {
        
        var domainsText = ""
        
        for domain in domains {
            
            if domain == domains.last! {
                domainsText += domain
            }
            
            if domain != domains.last! {
                
                domainsText += domain + "\n"
            }
        }
        
        return domainsText
    }
    
    func upload(name: String, comment: String, domains: [String]) {
        
        print("upload")
        
        let dbRootRef = Database.database().reference()
        var dbThisRef: DatabaseReference
        
        let groupid = "-LSswgLbGSb6PkNDkBEn"
        let documents = "documents"
        let document = "document"
        let groups = "groups"
        let group = "group"
        
        if Auth.auth().currentUser != nil {
            
            // ユーザ認証に利用したIDを設定
            let uid = "-" + (Auth.auth().currentUser?.uid)!
            // documentリレーション
            let documentRelation = [uid: true as AnyObject]
            // groupリレーション
            let groupRelation = [groupid: true as AnyObject]
            
            dbThisRef = dbRootRef.child(group).child(groupid).child(documents)
            
            // documetnsリレーションの構築
            let _relation: Dictionary<String, AnyObject> = documentRelation
            dbThisRef.updateChildValues(_relation)
            
            // Upload
            dbThisRef = dbRootRef.child(document).child(uid)
            let _data: Dictionary<String, AnyObject> = ["name": name as AnyObject, "comment": comment as AnyObject, "domains": domains as AnyObject, groups: groupRelation as AnyObject]
            dbThisRef.updateChildValues(_data)
        } else {
            print("ユーザー認証をしてください。")
            userUnauthenticatedAlert()
        }
        
        if Auth.auth().currentUser == nil {
            
            print("ユーザー認証をしてください。")
            userUnauthenticatedAlert()
        }
    }
    
    func userUnauthenticatedAlert() {
        
        let alert = UIAlertController(title: "ユーザ未認証", message: "test", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            print("ユーザ認証が行われていません。")
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    func uploadButtonTaped() {
        let alert = UIAlertController(title: "Upload", message: "Do you want to upload?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            
            print("cancel")
        }))
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            // アップロードする値を取得
            let _name = self.textField.text!
            let _comment = self.commentTextView.text!
            let _domains = self.jsonManager.getDomains()
            
            self.upload(name: _name, comment: _comment, domains: _domains)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func uploadButton(_ sender: UIButton) {
        
        print("upload button taped")
        
        // アップロード
        uploadButtonTaped()
    }
    
    
    @objc func textFieldCloseKeyBoard(textView : UITextView){
        //キーボードを隠す
        textField.resignFirstResponder()
    }
    
    @objc func textViewCloseKeyBoard(textView : UITextView){
        //キーボードを隠す
        commentTextView.resignFirstResponder()
    }
    
}

extension UploadViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        
        // キーボードを閉じる
        textField.resignFirstResponder()
        
        return true
    }
}
