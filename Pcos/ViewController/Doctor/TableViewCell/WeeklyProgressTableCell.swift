//
//  WeeklyProgressTableCell.swift
//  Pcos
//
//  Created by MAC SAIL   on 12/04/24.
//

import UIKit

class WeeklyProgressTableCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }
    @IBOutlet weak var dateLabel: UILabel!
       @IBOutlet weak var dayLabel: UILabel!
       @IBOutlet weak var caloriesLabel: UILabel!
       @IBOutlet weak var exerciseLabel: UILabel!
       @IBOutlet weak var feedbackLabel: UILabel!
       @IBOutlet weak var stepsLabel: UILabel!
    

    func configure(with item: WeeklyProgress) {
        print("Configuring cell with:", item)
        dateLabel.text = item.date
        dayLabel.text = "Day \(item.day)"
        caloriesLabel.text = "\(item.caloriesTaken) Kcal"
        exerciseLabel.text = "\(item.exerciseDuration) mins"
        feedbackLabel.text = "\(item.todaysFeedback) hrs"
        stepsLabel.text = "\(item.noOfSteps) Steps"
    }

   }

