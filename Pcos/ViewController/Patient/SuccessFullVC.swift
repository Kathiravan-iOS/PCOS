//
//  SuccessFullVC.swift
//  Pcos
//
//  Created by Karthik Babu on 08/10/23.
//

import UIKit

class SuccessFullVC: UIViewController {
    var username3 : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let story = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "PcosCategory") as! PcosCategory
            story.username4 = self.username3
            self.navigationController?.pushViewController(story, animated: true)
        }

    }


}
