//
//  WeeklyProgressVC.swift
//  Pcos
//
//  Created by MAC SAIL   on 12/04/24.
//

import UIKit

class WeeklyProgressVC: UIViewController {

    @IBOutlet weak var weeklyTableView: UITableView!{
        didSet {
            weeklyTableView.delegate = self
            weeklyTableView.dataSource = self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

extension WeeklyProgressVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = weeklyTableView.dequeueReusableCell(withIdentifier: "WeeklyProgressTableCell") as! WeeklyProgressTableCell
        return cell
    }
}
