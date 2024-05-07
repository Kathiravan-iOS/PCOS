//
//  Gifloader.swift
//  Pcos
//
//  Created by SAIL on 08/04/24.
//

import UIKit

class Gifloader: UIViewController {
    var usernamee: String = ""
    @IBOutlet weak var gif: UIImageView!
    
    override func viewDidLoad() {
        gif.image = UIImage.animatedGIF(named: "1223")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            let story = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SuccessFullVC") as! SuccessFullVC
            story.username3 = self.usernamee
            self.navigationController?.pushViewController(story, animated: true)
        }
        
    }
    


}
