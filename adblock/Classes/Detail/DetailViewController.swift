//
//  DetailViewController.swift
//  adblock
//
//  Created by admin on 2018/12/06.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

enum Section: Int {
    
    case section0 = 0
    case section1 = 1
    case section2 = 2
    
    var sectionTitle: String {
        
        switch self {
        case .section0:
            return "domains"
        case .section1:
            return "rating"
        case .section2:
            return "comment"
        }
    }
}

class DetailViewController: UIViewController {
    
    var EXTRA_Label: String?
    var EXTRA_Rate: [Int]?
    var EXTRA_RateAvg: Int?
    var EXTRA_Domains: [String]?
    var EXTRA_Comment: String?
    var EXTRA_ID: String?
    
    private var dataSource: RootDataSource!
    
    @IBOutlet weak var fileNameLabel: UILabel!
    @IBOutlet weak var ratingStarLabel: UILabel!
    @IBOutlet weak var ratingCountLabel: UILabel!
    @IBOutlet weak var downloadButton: UIButton!
    
    @IBOutlet weak var starButton1: UIButton!
    @IBOutlet weak var starButton2: UIButton!
    @IBOutlet weak var starButton3: UIButton!
    @IBOutlet weak var starButton4: UIButton!
    @IBOutlet weak var starButton5: UIButton!
    @IBOutlet weak var commentTextView: UITextView!
    
    @IBOutlet weak var domainsCountLabel: UILabel!
    @IBOutlet weak var domainsTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        dataSource = RootDataSource()
        
        starButton1.tag = 1
        starButton2.tag = 2
        starButton3.tag = 3
        starButton4.tag = 4
        starButton5.tag = 5
        
        // 角丸
        downloadButton.layer.cornerRadius = 10.0
        commentTextView.layer.cornerRadius = 10.0
        domainsTextView.layer.cornerRadius = 10.0
        
        // 編集不可
        commentTextView.isEditable = false
        domainsTextView.isEditable = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        guard let _rateAvg = EXTRA_RateAvg else { return }
        guard let _comment = EXTRA_Comment else { return }
        guard let _domains = EXTRA_Domains else { return }
        
        ratingStarLabel.text = "\(_rateAvg)" + ".0" + " \(starWord(rate: _rateAvg))"
        
        commentTextView.text = _comment
        domainsTextView.text = domainsText(domains: _domains)
        
        domainsCountLabel.text = String(_domains.count) + " domains"
    }
    
    func starWord(rate: Int) -> String {
    
        var num = 0
        var star = ""
        
        while num < rate {
            
            star += "★"
            num += 1
        }
        
        return star
    }
    
    func starButtonTaped(sender: UIButton) {
        print("Star button Taped")
        
        let starOff = UIImage(named: "star-off-icon")
        let starOn = UIImage(named: "star-on-icon")?.tint(color: #colorLiteral(red: 1, green: 0.9827856562, blue: 0.6425816047, alpha: 1))
        
        // 未評価の場合
        
        if sender.tag == 5 {
            if sender.currentImage == starOff {
                
                starButton1.setImage(starOn, for: .normal)
                starButton2.setImage(starOn, for: .normal)
                starButton3.setImage(starOn, for: .normal)
                starButton4.setImage(starOn, for: .normal)
                starButton5.setImage(starOn, for: .normal)
            }
        }
        
        if sender.tag == 4 {
            if sender.currentImage == starOff {
                
                starButton1.setImage(starOn, for: .normal)
                starButton2.setImage(starOn, for: .normal)
                starButton3.setImage(starOn, for: .normal)
                starButton4.setImage(starOn, for: .normal)
            } else {
                starButton5.setImage(starOff, for: .normal)
            }
        }
        
        if sender.tag == 3 {
            if sender.currentImage == starOff {
                starButton1.setImage(starOn, for: .normal)
                starButton2.setImage(starOn, for: .normal)
                starButton3.setImage(starOn, for: .normal)
            } else {
                starButton4.setImage(starOff, for: .normal)
                starButton5.setImage(starOff, for: .normal)
            }
        }
        
        if sender.tag == 2 {
            if sender.currentImage == starOff {
                starButton1.setImage(starOn, for: .normal)
                starButton2.setImage(starOn, for: .normal)
            } else {
                starButton3.setImage(starOff, for: .normal)
                starButton4.setImage(starOff, for: .normal)
                starButton5.setImage(starOff, for: .normal)
            }
        }
        
        if sender.tag == 1 {
            if sender.currentImage == starOff {
                starButton1.setImage(starOn, for: .normal)
            } else {
                starButton2.setImage(starOff, for: .normal)
                starButton3.setImage(starOff, for: .normal)
                starButton4.setImage(starOff, for: .normal)
                starButton5.setImage(starOff, for: .normal)
            }
        }
        
        // 評価をアップロード
        self.uploadRate(tag: sender.tag)
        self.starButtonTapedAlert()
    }
    
    func uploadRate(tag: Int) {
        
        print("update Rate")
        
        let dbRootRef = Database.database().reference()
        var dbThisRef = DatabaseReference()
 
        let uid = "-" + (Auth.auth().currentUser?.uid)!
        let document = "document"
        let rates = "rates"
        let rate = tag
        guard let documentID = EXTRA_ID else { return }
        
        dbThisRef = dbRootRef.child(document).child(documentID).child(rates)
        let _data: Dictionary<String, AnyObject> = [uid: rate as AnyObject]
        dbThisRef.updateChildValues(_data)
    }
    
    // domainsTextViewの文字列を生成
    func domainsText(domains: [String]) -> String {
        
        var domainsText = ""
        
        for domain in domains {
            
            // 書き込む途中なら改行
            if domain == domains.last! {
                domainsText += domain
            }
            
            // 最後なら改行しない
            if domain != domains.last! {
                domainsText += domain + "\n"
            }
        }
        
        return domainsText
    }
    
    func starButtonTapedAlert() {
        
        let alert = UIAlertController(title: "Submitted", message: "Thanks for your feedback.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alert, animated: true, completion: nil)
    }
    
    // 自身のドメインリストをダウンロードしたリストで更新
    func download() {
        
        guard let domains = EXTRA_Domains else { return }
        
        dataSource.downloadToUpdateAdList(domains: domains)
        dataSource.save()
    }
    
    // ダウンロードの完了アラートを表示
    func downloadAlert() {
        
        let alert = UIAlertController(title: "Download", message: "Download complete", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alert) in
            print("Download")
            
            self.download()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "comment" {
            
            guard let _comment = EXTRA_Comment else { return }
            
            let nextVC = segue.destination as! MoreCommentViewController
            nextVC.EXTRA_Comment = _comment
        }
        
        if segue.identifier == "domains" {
            
            guard let _domains = EXTRA_Domains else { return }
            let _domainsCount = domainsCountLabel.text!
            
            let nextVC = segue.destination as! MoreDomainsViewController
            nextVC.EXTRA_Domains = _domains
            nextVC.EXTRA_DomainsCount = _domainsCount
        }
    }
    
    func reviewsMoreButtonTaped() {
        print("More Review")
    }
    
    func writeReviewButtonTaped() {
        print("Write a Review")
    }
    
    func domainsMoreButtontaped() {
        print("More Domains")
    }
    
    @IBAction func starButton1(_ sender: UIButton) {
        starButtonTaped(sender: sender)
    }
    
    @IBAction func starButton2(_ sender: UIButton) {
        starButtonTaped(sender: sender)
    }
    
    @IBAction func starButton3(_ sender: UIButton) {
        starButtonTaped(sender: sender)
    }
    
    @IBAction func starButton4(_ sender: UIButton) {
        starButtonTaped(sender: sender)
    }
    
    @IBAction func starButton5(_ sender: UIButton) {
        starButtonTaped(sender: sender)
    }
    
    @IBAction func reviewsMoreButton(_ sender: UIButton) {
        reviewsMoreButtonTaped()
    }
    
    @IBAction func downloadButtonTaped(_ sender: UIButton) {
        
        // ダウンロード
        downloadAlert()
        
//        // UItableViewの更新を通知
//        let notiCenter = NotificationCenter.default
//        notiCenter.post(name: .downloadAlert, object: nil)
    }
    
}

extension UIImage {
    func tint(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        let drawRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIRectFill(drawRect)
        draw(in: drawRect, blendMode: .destinationIn, alpha: 1)
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tintedImage!
    }
}
