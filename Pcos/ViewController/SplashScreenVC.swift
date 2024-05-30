//
//  SplashScreenVC.swift
//  Pcos
//
//  Created by Karthik Babu on 06/10/23.
//

import UIKit

class SplashScreenVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func goStart(_ sender: Any) {
        //        let doctorVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PatientPlanVC" ) as! PatientPlanVC
        //        self.navigationController?.pushViewController(doctorVC, animated: true)
        if #available(iOS 16.0, *) {
            let selectProfile = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectProfileVC") as! SelectProfileVC
            //        } else {
            //            // Fallback on earlier versions
            //        } //SelectProfileVC
            self.navigationController?.pushViewController(selectProfile, animated: true)
        }
    }
}
//SelectProfileVC
