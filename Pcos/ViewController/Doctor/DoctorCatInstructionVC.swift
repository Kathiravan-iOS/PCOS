

import UIKit

class DoctorCatInstructionVC: UIViewController {
    
    var selectedPatientName: String?

    @IBOutlet weak var delete: UIImageView!
    @IBOutlet weak var instructionTableView: UITableView!
    var instructionList = ["Patient Profile", "Patient Activity", "Patient’s Menstural Calender", "View Patient’s Today Progress", "View Patient’s Medical Records"]
    override func viewDidLoad() {
        super.viewDidLoad()
        instructionTableView.delegate = self
        instructionTableView.dataSource = self
        customizeNavigationBar(title: "Doctor Category Instructions")
        
        let deleteTapGesture = UITapGestureRecognizer(target: self, action: #selector(deletePatient))
            delete.isUserInteractionEnabled = true
            delete.addGestureRecognizer(deleteTapGesture)
        }

    @objc func deletePatient() {
        guard let patientName = selectedPatientName, let url = URL(string: ServiceAPI.delete) else {
            print("Invalid details")
            return
        }

        let confirmationAlert = UIAlertController(title: "Confirm Deletion", message: "Are you sure you want to delete this patient?", preferredStyle: .alert)
        confirmationAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        confirmationAlert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let bodyParameters = "name=\(patientName)"
            request.httpBody = bodyParameters.data(using: .utf8)
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

            URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    print("Error or Invalid response received from the server")
                    return
                }

                guard error == nil else {
                    print("Error making request: \(String(describing: error))")
                    return
                }

                DispatchQueue.main.async {
                    // Pop to DoctorHomeVC
                    self?.popToDoctorHomeVC()
                }
            }.resume()
        })

        present(confirmationAlert, animated: true, completion: nil)
    }


    func popToDoctorHomeVC() {
        if let navigationController = self.navigationController {
            for controller in navigationController.viewControllers {
                if let doctorHomeVC = controller as? DoctorHomeVC {
                    navigationController.popToViewController(doctorHomeVC, animated: true)
                    doctorHomeVC.reloadData() 
                    break
                }
            }
        }
    }


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
              cell.contentView.backgroundColor = .white
          }
        let selectedItem = instructionList[indexPath.row]
        navigateToViewController(for: selectedItem)
    }
}
