//
//  Medicalreporthome.swift
//  
//
//  Created by SAIL on 13/02/24.
//

import UIKit

class Medicalreporthome: UIViewController {
    var name : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    @IBAction func uploadreports(_ sender: Any) {
        
        let upload =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "uploadreports") as! uploadreports
        self.navigationController?.pushViewController(upload, animated: true)
    }
    
    @IBAction func viewreports(_ sender: Any) {
        let view = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PatientMedicalRecordVC") as! PatientMedicalRecordVC
        view.reportName = name
        self.navigationController?.pushViewController(view, animated: true)
    }
    
}
