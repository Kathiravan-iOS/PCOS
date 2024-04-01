import UIKit

class recorddailyprogreeVC: UIViewController {
    var recordname : String = ""
    @IBOutlet weak var day: UITextField!
    @IBOutlet weak var exerciseduration: UITextField!
    @IBOutlet weak var feedback: UITextField!
    @IBOutlet weak var steps: UITextField!
    @IBOutlet weak var calorie: UITextField!
    @IBOutlet weak var name: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = recordname
        self.title = "Record Your Progress"
        day.delegate = TextFieldHelper.shared
        exerciseduration.delegate = TextFieldHelper.shared
        feedback.delegate = TextFieldHelper.shared
        steps.delegate = TextFieldHelper.shared
        calorie.delegate = TextFieldHelper.shared
        name.delegate = TextFieldHelper.shared
       
    }

    @IBAction func submitprogree(_ sender: Any) {
        getprogressAPI()
    }

    func getprogressAPI() {
        guard let nameText = name.text, !nameText.isEmpty,
              let dayText = day.text, !dayText.isEmpty,
              let calorieText = calorie.text, !calorieText.isEmpty,
              let exerciseDurationText = exerciseduration.text, !exerciseDurationText.isEmpty,
              let feedbackText = feedback.text, !feedbackText.isEmpty,
              let stepsText = steps.text, !stepsText.isEmpty else {
            showAlert(message: "Please fill in all fields.")
            return
        }

        let progress: [String: String] = [
            "name": nameText,
            "day": dayText,
            "calories_taken": calorieText,
            "exercise_duration": exerciseDurationText,
            "todays_feedback": feedbackText,
            "no_of_steps": stepsText
        ]

        APIHandler().postAPIValues(type: progressModel.self, apiUrl: ServiceAPI.todaysprogress, method: "POST", formData: progress) { result in
                switch result {
                case .success(let data):
                    if data.success {
                        DispatchQueue.main.async {
                            // Show success message and navigate on "OK"
                            let alertController = UIAlertController(title: "Success", message: "Progress recorded successfully.", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                                // Navigate to PatientPlanVC
                                self.navigateToPatientPlanVC()
                            }
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true, completion: nil)
                        }
                    } else {
                        DispatchQueue.main.async {
                            // Handle failure scenario
                            self.showAlert(message: data.message)
                        }
                    }
                case .failure(let error):
                    print("Decoding error: \(error)")
                }
            }
        }

        func navigateToPatientPlanVC() {
            if let targetVC = self.navigationController?.viewControllers.first(where: { $0 is PatientPlanVC }) {
                self.navigationController?.popToViewController(targetVC, animated: true)
            }
        }


    func showAlert(message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
