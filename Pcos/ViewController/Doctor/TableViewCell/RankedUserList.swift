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
    @IBOutlet weak var profile: UIImageView!
    
    func loadImage(from urlString: String?) {
            guard let urlString = urlString, let url = URL(string: urlString) else {
                self.profile.image = UIImage(named: "defaultPlaceholder")
                return
            }

            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.profile.image = image
                        self.profile.contentMode = .scaleAspectFill
                        self.profile.layer.cornerRadius = self.profile.frame.width / 2
                        self.profile.clipsToBounds = true
                        
                    }
                } else {
                    DispatchQueue.main.async {
                        
                        self.profile.image = UIImage(named: "defaultPlaceholder")
                        
                    }
                }
            }.resume()
        }
    func makeProfileImageCircular() {
           profile.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               profile.widthAnchor.constraint(equalToConstant: 100),
               profile.heightAnchor.constraint(equalToConstant: 100)
           ])
           profile.layer.cornerRadius = 50
           profile.clipsToBounds = true
       }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        makeProfileImageCircular()
        profile.layer.masksToBounds = true
        profile.layer.cornerRadius = profile.frame.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      
    }
    
}
