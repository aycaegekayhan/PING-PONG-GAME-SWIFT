//
//  HighScoresViewController.swift
//  Bearcat Ninja
//
//  Created by Berk Çohadar on 11/18/21.
//

import UIKit

class HighScoresViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var highScoreTable: UITableView!
    @IBOutlet var HighScores: UIView!
    var highScoreValues = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        highScoreTable.delegate = self
        highScoreTable.dataSource = self
        
        highScoreValues = ["152","188","212","245","267"]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = highScoreValues[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return highScoreValues.count
    }
    
}
