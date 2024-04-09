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
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self = self else { return } 
            let story = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "PcosCategory") as! PcosCategory
            story.username4 = self.username3
            story.hideBackButton = true
            self.navigationController?.pushViewController(story, animated: true)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false

    }
    


}
