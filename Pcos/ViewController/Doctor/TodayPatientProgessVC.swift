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
                    self.Dday.text = "\(progressData.day ?? 0)"
                    self.Dcalorie.text = "\(progressData.calories_taken ?? 0)"
                    self.Dduration.text = "\(progressData.exercise_duration ?? 0)"
                    self.Dfeedback.text = "\(progressData.todays_feedback ?? "")"
                    self.Dsteps.text = "\(progressData.no_of_steps ?? 0)"
                    self.Dname.text = "\(progressData.name ?? "")"
                }

            case .failure(let error):
                print("Error fetching today's progress details:", error)
                self.showAlert(withTitle: "Error", message: "Failed to fetch today's progress details.")
            }
        }
    }

    func showAlert(withTitle title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default){
            action in self.DoctorHomeVC()
        }
        alertController.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }
    func DoctorHomeVC(){
        let back = UIStoryboard(name: "Main", bundle: nil)
        let vc = back.instantiateViewController(withIdentifier: "DoctorCatInstructionVC") as! DoctorCatInstructionVC
        vc.selectedPatientName = selectedPatientName
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
