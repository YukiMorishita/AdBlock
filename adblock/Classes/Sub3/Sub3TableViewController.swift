//
//  Sub3TableViewController.swift
//  adblock-test
//
//  Created by admin on 2018/11/17.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class Sub3TableViewController: UITableViewController {
    
    private var dataSource: Sub3DataSource!
    private var jsonManager: JsonManager!
    
    private let groupID = "jp.ac.osakac.cs.hisalab.adblock"
    private let key = "TableList4"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = Sub3DataSource()
        jsonManager = JsonManager()
        
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
    
    @IBAction func test(_ sender: UIBarButtonItem) {
        
        //dataSource.setMyList()
        let jsonFileName = jsonManager.getJsonFileName()
        print(jsonFileName)
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
