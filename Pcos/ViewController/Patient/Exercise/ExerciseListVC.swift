//
//  ExerciseListVC.swift
//  Pcos
//
//  Created by Karthik Babu on 06/11/23.
//

import UIKit

class ExerciseListVC: UIViewController {

    @IBOutlet weak var exerciseList: UITableView! {
        didSet {
            exerciseList.delegate = self
            exerciseList.dataSource = self
        }
    }
    
    var imgName = ["yoga 1","yoga 2","yoga 3","yoga 4","yoga 1","yoga 3","yoga 2","yoga 4"]
    var yogaName = ["HIGH STEPPING","SIDE HOP","FRONT LIFT","BUT BRIDGE","SQUATS","WALL PUSH-UPS","JUMPING JACKS","FROG PRESS"]

    override func viewDidLoad() {
        super.viewDidLoad()
        customizeNavigationBar(title: "Exercise")
        
    }
    

}

extension ExerciseListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = exerciseList.dequeueReusableCell(withIdentifier: "ExcerciseTabCell") as! ExcerciseTabCell
        cell.img.image = UIImage(named: imgName[indexPath.row])
        cell.nameLbl.text = yogaName[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        exerciseList.deselectRow(at: indexPath, animated: true)
        
        let exerciseVideoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ExerciseVideoVC") as! ExerciseVideoVC
        exerciseVideoVC.exerciseNameStr = yogaName[indexPath.row].lowercased()
        exerciseVideoVC.exerciseImage = UIImage(named: imgName[indexPath.row])
        self.navigationController?.pushViewController(exerciseVideoVC, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}


class ExcerciseTabCell : UITableViewCell {
    @IBOutlet weak var img : UIImageView!
    @IBOutlet weak var nameLbl : UILabel!
}


