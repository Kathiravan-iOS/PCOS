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
    var namef:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        breakfast.addAction(for: .tap) { [self] in
            let mealDetailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NutritionVC") as! NutritionVC
            mealDetailsVC.namelabel = "300 Calories"
            mealDetailsVC.namef1 = namef
            self.navigationController?.pushViewController(mealDetailsVC, animated: true)
        }
        lunch.addAction(for: .tap) { [self] in
            let mealDetailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NutritionVC") as! NutritionVC
            mealDetailsVC.namelabel = "500 Calories"
            mealDetailsVC.namef1 = namef
            self.navigationController?.pushViewController(mealDetailsVC, animated: true)
        }
        dinner.addAction(for: .tap) { [self] in
            let mealDetailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NutritionVC") as! NutritionVC
            mealDetailsVC.namelabel = "300 Calories"
            mealDetailsVC.namef1 = namef
            self.navigationController?.pushViewController(mealDetailsVC, animated: true)
        }

        
    }


}
