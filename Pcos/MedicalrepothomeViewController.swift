//
//  MedicalrepothomeViewController.swift
//  Pcos
//
//  Created by SAIL on 14/02/24.
//

import UIKit

class MedicalrepothomeViewController: UIViewController {
    var name : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func upload(_ sender: Any) {
        let upload = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "uploadreports") as! uploadreports
        upload.name1 = name
        self.navigationController?.pushViewController(upload, animated: true)
    }

    @IBAction func view(_ sender: Any) {
        let view = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PatientMedicalRecordVC") as! PatientMedicalRecordVC
        view.reportName = name
        self.navigationController?.pushViewController(view, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
