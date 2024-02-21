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
                // Print the entire JSON response
                print("Received JSON response:", TodayProgressData)
                
                DispatchQueue.main.async {
                    self.Dday.text = " \(TodayProgressData.data?.day ?? 0)"
                    self.Dcalorie.text = "\(TodayProgressData.data?.calories_taken ?? 0)"

                    self.Dduration.text = " \(TodayProgressData.data?.exercise_duration ?? 0)"
                    self.Dfeedback.text = " \(TodayProgressData.data?.todays_feedback ?? "")"
                    self.Dsteps.text = " \(TodayProgressData.data?.no_of_steps ?? 0)"
                    self.Dname.text = " \(TodayProgressData.data?.name ?? "")"
                }






            case .failure(let error):
                print("Error fetching today's progress details:", error)
            }
        }
    }
}
