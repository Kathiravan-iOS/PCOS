//
//  SelectProfileVC.swift
//  Pcos
//
//  Created by Karthik Babu on 06/10/23.
//

import UIKit

class SelectProfileVC: UIViewController {

    var userProfile = String()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true

    }
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false

    }
    @IBAction func doctorLogin(_ sender: Any) {
        UserDefaultsManager.shared.saveUserName("Doctor")
        
        let loginVC =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(loginVC, animated: true)
        
    }
    
    @IBAction func patientLogin(_ sender: Any) {
        UserDefaultsManager.shared.saveUserName("Patient")
//        UserDefaults.standard.set(userProfile, forKey: "UserProfile")
        let loginVC =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC // LoginVC
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
}
