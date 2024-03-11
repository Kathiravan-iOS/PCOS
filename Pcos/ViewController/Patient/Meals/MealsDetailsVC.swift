//
//  MealsDetailsVC.swift
//  Pcos
//
//  Created by Karthik Babu on 06/11/23.
//

import UIKit

class MealsDetailsVC: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailsTextView: UITextView!
    var nameLabelText: String?

    var nutritionInfos: [NutritionInfo] = []
        var totalCalories: Double = 0
        var namelabel: String? // Property to hold the value
        
        override func viewDidLoad() {
            super.viewDidLoad()
            updateUI()
        }
        
    func updateUI() {
        var detailsText = ""
        for nutritionInfo in nutritionInfos {
            detailsText += "\(nutritionInfo.name) - Calories: \(nutritionInfo.calories), Carbs: \(nutritionInfo.carbohydrates)g, Protein: \(nutritionInfo.protein)g, Fat: \(nutritionInfo.fat)g\n"
        }
        // Here, we round the totalCalories and convert it to Int just for display purposes
        let displayTotalCalories = Int(totalCalories)
        detailsText += "\nTotal Calories: \(displayTotalCalories*100)"
        detailsTextView.text = detailsText
        
        nameLabel.text = nameLabelText // Assuming this is where you want to display the name
    }
    @IBAction func backhome(_ sender: Any) {
        let mealDetailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PatientPlanVC") as! PatientPlanVC
        mealDetailsVC.username5 = nameLabelText ?? ""
        self.navigationController?.pushViewController(mealDetailsVC, animated: true)
    }
    

    }
