//
//  MoreDomainsViewController.swift
//  adblock
//
//  Created by admin on 2018/12/08.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit


class MoreDomainsViewController: UIViewController {
    
    var EXTRA_Domains: [String]?
    var EXTRA_DomainsCount: String?
    
    private var domains = [String]()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var domainsCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.allowsSelection = false
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let _domains = EXTRA_Domains else { return }
        guard let _domainsCount = EXTRA_DomainsCount else { return }
        
        self.domains = _domains
        self.domainsCountLabel.text = _domainsCount
    }

}

extension MoreDomainsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44
    }
    
}

extension MoreDomainsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.domains.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.domains[indexPath.row]
        
        return cell
    }
}
