//
//  TableViewController.swift
//  Filterer
//
//  Created by ShenZhenyuan on 1/19/16.
//  Copyright © 2016 ShenZhenyuan. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    let filters = [
        "Red",
        "Blue",
        "Green",
        "Yellow"
    ]
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(filters[indexPath.row])
    }
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =
        tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath)
        
        cell.textLabel?.text = filters[indexPath.row]
        return cell
    }



}
