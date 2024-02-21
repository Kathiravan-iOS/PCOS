//
//  RankedUserList.swift
//  Pcos
//
//  Created by Karthik Babu on 05/10/23.
//

import UIKit

class RankedUserList: UITableViewCell {
  @IBOutlet weak var namelabel : UILabel?
  @IBOutlet weak var scoreLabel : UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
