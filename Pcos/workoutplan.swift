//
//  workoutplan.swift
//  Pcos
//
//  Created by SAIL on 14/03/24.
//

import UIKit

class workoutplan: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    @IBAction func monday(_ sender: Any) {
        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ExerciseListVC") as! ExerciseListVC
        nextVC.day = "Monday"
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func tuesday(_ sender: Any) {
        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ExerciseListVC") as! ExerciseListVC
        nextVC.day = "tuesday"
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    @IBAction func wednesday(_ sender: Any) {
        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ExerciseListVC") as! ExerciseListVC
        nextVC.day = "Wednesday"
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func thursday(_ sender: Any) {
        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ExerciseListVC") as! ExerciseListVC
        nextVC.day = "Thursday"
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func friday(_ sender: Any) {
        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ExerciseListVC") as! ExerciseListVC
        nextVC.day = "Friday"
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func saturday(_ sender: Any) {
        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ExerciseListVC") as! ExerciseListVC
        nextVC.day = "Saturday"
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
    
    
    
}
