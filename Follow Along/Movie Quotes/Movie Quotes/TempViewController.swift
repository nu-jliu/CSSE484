//
//  TempViewController.swift
//  Movie Quotes
//
//  Created by Jingkun Liu on 3/25/22.
//

import UIKit

class TempViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let tempCellIdentifier = "TempCell"
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.tempCellIdentifier, for: indexPath)
        
        // Configure cell
        cell.textLabel?.text = "This is row \(indexPath.row)"
        return cell
    }
    

}
