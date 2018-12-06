//
//  DetailTableViewController.swift
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

class DetailTableViewController: UITableViewController {
    
    var EXTRA_Label: String?
    var EXTRA_Rate: [Int]?
    var EXTRA_Domains: [String]?
    var EXTRA_Comment: [String]?
    
    private var sectionData = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = UITableView()
        tableView.delegate  = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        guard let filename = EXTRA_Label else { return }
        guard let rating = EXTRA_Rate else { return }
        guard let domains = EXTRA_Domains else { return }
        
        self.sectionData = [filename, "\(rating)", "\(domains.count) + 件"]
    }
    
    // MARK: - Table view delegete
    

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case Section.section0.rawValue:
            return Section.section0.sectionTitle
        case Section.section1.rawValue:
            return Section.section1.sectionTitle
        case Section.section2.rawValue:
            return Section.section2.sectionTitle
        default: return nil
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        //cell.textLabel?.text = self.sectionData[indexPath.row]
        
        return cell
    }

}
