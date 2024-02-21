//
//  SectionTitleCell.swift
//  Pcos
//
//  Created by Karthik Babu on 04/11/23.
//

import UIKit

class SectionTitleCell: UITableViewCell {

    @IBOutlet weak var hometitle: UILabel!
    var titles = ["Start your routine", "Stay Hydrated Drink Water", "Do exercise!", "Stay Healthy"]
    var titleTimer: Timer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        startTitleAnimation()
    }

    func startTitleAnimation() {
        titleTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(updateTitle), userInfo: nil, repeats: true)
    }

    @objc func updateTitle() {
        if titles.isEmpty { return }
        
        let randomIndex = Int(arc4random_uniform(UInt32(titles.count)))
        hometitle.text = titles[randomIndex]
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleTimer?.invalidate()
        titleTimer = nil
    }
}
