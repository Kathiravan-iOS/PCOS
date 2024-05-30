//
//  PatientListTabCell.swift
//  Pcos
//
//  Created by Karthik Babu on 06/10/23.
//

import UIKit

class PatientListTabCell: UITableViewCell {

    @IBOutlet weak var cancel: UIButton!
    @IBOutlet weak var patientName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
