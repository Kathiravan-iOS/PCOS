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
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationItem.hidesBackButton = true
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationItem.hidesBackButton = false

    }
        
    func updateUI() {
        var detailsText = ""
        for nutritionInfo in nutritionInfos {
            detailsText += "\(nutritionInfo.name) - Calories: \(nutritionInfo.calories) "
        }
        // Here, we round the totalCalories and convert it to Int just for display purposes
        let displayTotalCalories = Int(totalCalories)
        detailsText += "\nTotal Calories: \(displayTotalCalories)"
        detailsTextView.text = detailsText
        
        nameLabel.text = nameLabelText // Assuming this is where you want to display the name
    }
    @IBAction func backhome(_ sender: Any) {
        let mealDetailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PatientPlanVC") as! PatientPlanVC
        mealDetailsVC.username5 = namelabel ?? ""
        self.navigationController?.pushViewController(mealDetailsVC, animated: true)
    }
    

    }
