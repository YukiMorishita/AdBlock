//
//  DetailViewController.swift
//  adblock
//
//  Created by admin on 2018/12/06.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

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
    var EXTRA_Domains: [String]?
    var EXTRA_Comment: [String]?

    @IBOutlet weak var fileNameLabel: UILabel!
    @IBOutlet weak var ratingStarLabel: UILabel!
    @IBOutlet weak var ratingCountLabel: UILabel!
    @IBOutlet weak var downloadButton: UIButton!
    
    @IBOutlet weak var ratingsMoreButton: UIButton!
    @IBOutlet weak var starButton1: UIButton!
    @IBOutlet weak var starButton2: UIButton!
    @IBOutlet weak var starButton3: UIButton!
    @IBOutlet weak var starButton4: UIButton!
    @IBOutlet weak var starButton5: UIButton!
    @IBOutlet weak var reviewsTextView: UITextView!
    
    @IBOutlet weak var domainsMoreButton: UIButton!
    @IBOutlet weak var domainsCountLabel: UILabel!
    @IBOutlet weak var domainsTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        guard let filename = EXTRA_Label else { return }
        guard let rating = EXTRA_Rate else { return }
        guard let domains = EXTRA_Domains else { return }
        guard let comments = EXTRA_Comment else { return }
        
        print(filename)
        print(rating)
        print(domains)
        print(comments)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
