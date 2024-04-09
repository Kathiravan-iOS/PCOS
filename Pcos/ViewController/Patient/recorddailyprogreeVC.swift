import UIKit

struct TotalCalorieResponse: Decodable {
    let success: Bool
    let name: String
    let total_calorie: Int
}

class recorddailyprogreeVC: UIViewController {
    var recordname: String = ""
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
        if !recordname.isEmpty {
            fetchTotalCalorie(forName: recordname)
        }
        day.delegate = TextFieldHelper.shared
        exerciseduration.delegate = TextFieldHelper.shared
        feedback.delegate = TextFieldHelper.shared
        steps.delegate = TextFieldHelper.shared
        calorie.delegate = TextFieldHelper.shared
        name.delegate = TextFieldHelper.shared
    }
    
    @IBAction func submitProgress(_ sender: Any) {
        getprogressAPI()
    }
    
    func fetchTotalCalorie(forName name: String) {
        let urlString = "\(ServiceAPI.baseURL)/totalcalorie.php?name=\(name)"
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching total calorie: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(TotalCalorieResponse.self, from: data)
                DispatchQueue.main.async {
                    self?.calorie.text = "\(response.total_calorie)"
                }
            } catch {
                print("Error decoding response: \(error.localizedDescription)")
            }
        }
        task.resume()
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
            "date": dayText,
            "calories_taken": calorieText,
            "exercise_duration": exerciseDurationText,
            "todays_feedback": feedbackText,
            "no_of_steps": stepsText
        ]
        
        APIHandler().postAPIValues(type: progressModel.self, apiUrl: ServiceAPI.todaysprogress, method: "POST", formData: progress) { [weak self] result in
            switch result {
            case .success(let data):
                if data.success {
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "Success", message: "Progress recorded successfully.", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                            self?.navigateToPatientPlanVC()
                        }
                        alertController.addAction(okAction)
                        self?.present(alertController, animated: true, completion: nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.showAlert(message: "Failed to record progress.")
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
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
