//
//  MealPlanCell.swift
//  Pcos
//
//  Created by Karthik Babu on 04/11/23.
//

import UIKit

class MealPlanCell: UITableViewCell {

    @IBOutlet weak var planName: UILabel!
    
    @IBOutlet weak var images: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
