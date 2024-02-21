//
//  MealsShceduleVC.swift
//  Pcos
//
//  Created by Karthik Babu on 06/11/23.
//

import UIKit

class MealsShceduleVC: UIViewController {
    
    
    
    @IBOutlet weak var breakfast: UIView!
    @IBOutlet weak var lunch: UIView!
    @IBOutlet weak var dinner: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        breakfast.addAction(for: .tap) {
            let mealDetailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MealsDetailsVC") as! MealsDetailsVC
            self.navigationController?.pushViewController(mealDetailsVC, animated: true)
        }
        lunch.addAction(for: .tap) {
            let mealDetailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MealsDetailsVC") as! MealsDetailsVC
            self.navigationController?.pushViewController(mealDetailsVC, animated: true)
        }
        dinner.addAction(for: .tap) {
            let mealDetailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MealsDetailsVC") as! MealsDetailsVC
            self.navigationController?.pushViewController(mealDetailsVC, animated: true)
        }

        
    }


}
