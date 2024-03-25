//
//  DoctorCatInstructionVC.swift
//  Pcos
//
//  Created by Karthik Babu on 06/10/23.
//

import UIKit

class DoctorCatInstructionVC: UIViewController {
    
    var selectedPatientName: String?

    @IBOutlet weak var instructionTableView: UITableView!
    var instructionList = ["Patient Profile", "Patient Activity", "Patient’s Menstural Calender", "View Patient’s Today Progress", "View Patient’s Medical Records"]
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.setupBackButton()
        instructionTableView.delegate = self
        instructionTableView.dataSource = self
        customizeNavigationBar(title: "Doctor Category Instructions")
    }
//    func setupBackButton() {
//        let backImage = UIImage(named: "back")?.withRenderingMode(.alwaysOriginal)
//            let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backAction))
//            backButton.imageInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0) 
//            
//            self.navigationItem.leftBarButtonItem = backButton
//    }

    @objc func backAction() {
        if let navigationController = self.navigationController {
            for controller in navigationController.viewControllers {
                if controller is DoctorHomeVC {
                    navigationController.popToViewController(controller, animated: true)
                    break
                }
            }
        }
    }
    func navigateToViewController(for item: String) {
            var destinationViewController = UIViewController()

            switch item {
            case "Patient Profile":
                let profilevc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PatientProfileVC") as! PatientProfileVC
                profilevc.selectedPatientName = selectedPatientName
                profilevc.shouldHideeditButton = true
                destinationViewController = profilevc
                
            case "Patient Activity":
                let patient = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PatientActivityVC") as! PatientActivityVC
                patient.name1 = selectedPatientName ?? ""
                destinationViewController = patient
                
            case "Patient’s Menstural Calender":
                
                if #available(iOS 16.0, *) {
                    if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CalendarVC") as? CalendarVC {
                        vc.selectedPatientName = self.selectedPatientName ?? ""
                        destinationViewController = vc
                    }
                    
                } else {
                    destinationViewController = UIViewController()
                }
               
//            case "View Assesment Result":
//                destinationViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PatientAssementResultVC") as! PatientAssementResultVC
            case "View Patient’s Today Progress":
                let todayProgressVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TodayPatientProgessVC") as! TodayPatientProgessVC
                        todayProgressVC.selectedPatientName = selectedPatientName
                        destinationViewController = todayProgressVC

            case "View Patient’s Medical Records":
                let medicalrecord = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PatientMedicalRecordVC") as! PatientMedicalRecordVC
                medicalrecord.reportName = selectedPatientName ?? ""
                        destinationViewController = medicalrecord
            default:
                return 
            }
        self.navigationController?.pushViewController(destinationViewController, animated: true)
        }
    

}


extension DoctorCatInstructionVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return instructionList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = instructionTableView.dequeueReusableCell(withIdentifier: "instructionTabCell") as! InstructionTabCell
        cell.instruction_Lbl.text = instructionList[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        instructionTableView.deselectRow(at: indexPath, animated: true)
          if let cell = tableView.cellForRow(at: indexPath) {
              cell.contentView.backgroundColor = .white // Set your desired background color
          }
        let selectedItem = instructionList[indexPath.row]
        navigateToViewController(for: selectedItem)
    }
}
