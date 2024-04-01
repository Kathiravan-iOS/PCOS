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
        var namelabel: String?
        override func viewDidLoad() {
            super.viewDidLoad()
            updateUI()
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true 
    }
//    override func viewDidAppear(_ animated: Bool) {
//        self.navigationController?.navigationItem.hidesBackButton = false

//    }
        
    func updateUI() {
        var detailsText = ""
        for nutritionInfo in nutritionInfos {
            detailsText += "\(nutritionInfo.name) - Calories: \(nutritionInfo.calories) "
        }

        let displayTotalCalories = Int(totalCalories)
        detailsText += "\nTotal Calories: \(displayTotalCalories)"
        detailsTextView.text = detailsText
        
        nameLabel.text = nameLabelText
        detailsTextView.isUserInteractionEnabled = false
    }
    @IBAction func backhome(_ sender: Any) {
    if let viewcontroller = navigationController?.viewControllers {
            for currentVC in viewcontroller {
                if currentVC.isKind(of: PatientPlanVC.self) {
                    if let patientHomeVc = currentVC as? PatientPlanVC, let name = namelabel {
                        patientHomeVc.username5 = name
                        self.navigationController?.popToViewController(currentVC, animated: true)
                    }
                }
            }
        }
    }
    

    }
