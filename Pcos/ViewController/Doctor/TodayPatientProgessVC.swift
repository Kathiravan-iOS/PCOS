import UIKit

class TodayPatientProgessVC: UIViewController {
    @IBOutlet weak var Dday: UITextField!
    @IBOutlet weak var Dfeedback: UITextField!
    @IBOutlet weak var Dduration: UITextField!
    @IBOutlet weak var Dsteps: UITextField!
    @IBOutlet weak var Dcalorie: UITextField!
    @IBOutlet weak var Dname: UITextField!

    var selectedPatientName: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTodayProgressDetails()
        disableTextFieldsForDoctors()
    }

    func fetchTodayProgressDetails() {
        guard let name = selectedPatientName else {
            return
        }
        

        print("Patient Name:", name)

        let progressAPIURL = "\(ServiceAPI.baseURL)todayprogress-D.php?name=\(name)"

        APIHandler().getAPIValues(type: TodayProgressModel.self, apiUrl: progressAPIURL, method: "GET") { result in
            switch result {
            case .success(let TodayProgressData):
                guard let progressData = TodayProgressData.data else {
                    self.showAlert(withTitle: "No Progress Recorded", message: "No progress has been recorded for today.")
                    return
                }
                print("Received JSON response:", TodayProgressData)
                
                DispatchQueue.main.async {
                    self.Dday.text = progressData.Date
                    self.Dcalorie.text = "\(progressData.calories_taken ?? 0)"
                    self.Dduration.text = "\(progressData.exercise_duration ?? 0)"
                    self.Dfeedback.text = "\(progressData.todays_feedback ?? 0)"
                    self.Dsteps.text = "\(progressData.no_of_steps ?? 0)"
                    self.Dname.text = progressData.name
                }

            case .failure(let error):
                print("Error fetching today's progress details:", error)
                self.showAlert(withTitle: "Error", message: "Failed to fetch today's progress details.")
            }
        }
    }
    func disableTextFieldsForDoctors() {
        if UserDefaultsManager.shared.getUserName() == "Doctor" {
            Dday.isUserInteractionEnabled = false
            Dfeedback.isUserInteractionEnabled = false
            Dduration.isUserInteractionEnabled = false
            Dsteps.isUserInteractionEnabled = false
            Dcalorie.isUserInteractionEnabled = false
            Dname.isUserInteractionEnabled = false
        }
    }

    func showAlert(withTitle title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default){
            action in self.popToDoctorCatInstructionVC()
        }
        alertController.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }
    func popToDoctorCatInstructionVC() {
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers.reversed() {
                if let doctorCatInstructionVC = viewController as? DoctorCatInstructionVC {
                    doctorCatInstructionVC.selectedPatientName = self.selectedPatientName
                    self.navigationController?.popToViewController(doctorCatInstructionVC, animated: true)
                    return
                }
            }
        }
    }


}
