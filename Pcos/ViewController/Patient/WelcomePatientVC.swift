//
//  WelcomePatientVC.swift
//  Pcos
//
//  Created by Karthik Babu on 06/10/23.
//

import UIKit

class WelcomePatientVC: UIViewController {
    var username1: String = ""
    @IBOutlet weak var tapScree: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tapScree.addAction(for: .tap) {
            let sampleVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SampleVC") as! SampleVC
            sampleVC.username2 = self.username1
            self.navigationController?.pushViewController(sampleVC, animated: true)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
}
