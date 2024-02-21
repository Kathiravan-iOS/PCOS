import UIKit

class WeightGoalListVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var currentweight: UITextField!
    @IBOutlet weak var goalweight: UITextField!
    @IBOutlet weak var activitylevel: UITextField!
    @IBOutlet weak var weightgoal: UITextField!
    @IBOutlet weak var calorie: UITextField!
    
    let activityLevels = ["Sedentary", "Highly Active", "Less Active", "Moderate"]
        
    var pickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeNavigationBar(title: "Set Your Nutrition Plan")
        pickerView.delegate = self
        pickerView.dataSource = self
        
        activitylevel.inputView = pickerView
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return activityLevels.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return activityLevels[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        activitylevel.text = activityLevels[row]
    }

    @IBAction func Done(_ sender: Any) {
        if validateFields() {
            self.getweightgoalAPI()
        }
    }
    
    func validateFields() -> Bool {
        guard
            let currentWeightValue = Int(currentweight.text ?? ""),
            let goalWeightValue = Int(goalweight.text ?? ""),
            let weightGoalValue = Int(weightgoal.text ?? ""),
            let calorieValue = Int(calorie.text ?? "")
        else {
            showAlert(message: "Invalid values for numeric fields.")
            return false
        }

        if currentWeightValue <= 0 {
            showAlert(message: "Please enter a valid Current Weight.")
            return false
        }

        if goalWeightValue <= 0 {
            showAlert(message: "Please enter a valid Goal Weight.")
            return false
        }

        if (weightGoalValue == 0)  {
            showAlert(message: "Please enter a valid Weight Goal.")
            return false
        }

        if activitylevel.text?.isEmpty ?? true {
            showAlert(message: "Please enter Activity Level.")
            return false
        }

        if calorieValue <= 0 {
            showAlert(message: "Please enter a valid Daily Calorie Budget.")
            return false
        }

        return true
    }

    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }

    func getweightgoalAPI() {
        guard
            let currentWeightValue = Int(currentweight.text ?? ""),
            let goalWeightValue = Int(goalweight.text ?? ""),
            let weightGoalValue = Int(weightgoal.text ?? ""),
            let calorieValue = Int(calorie.text ?? "")
        else {
            showAlert(message: "Invalid values for numeric fields.")
            return
        }

        // Convert [String: Any] to [String: String]
        let weightgoal: [String: String] = [
            "CurrentWeight": "\(currentWeightValue)",
            "GoalWeight": "\(goalWeightValue)",
            "WeightGoal": "\(weightGoalValue)",
            "ActivityLevel": activitylevel.text ?? "",
            "DailyCalorieBudget": "\(calorieValue)"
        ]

        APIHandler().postAPIValues(type: weightgoalModel.self, apiUrl: ServiceAPI.weightgoalURL, method: "POST", formData: weightgoal) { result in
            switch result {
            case .success(let data):
                if !data.success {
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "Alert", message: data.message, preferredStyle: .alert)
                        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(cancelAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.meal()
                    }
                }

            case .failure(let error):
                print(error)
            }
        }
    }

    func meal() {
        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MealsShceduleVC") as! MealsShceduleVC
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}
