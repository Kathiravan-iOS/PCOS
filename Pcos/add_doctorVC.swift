import UIKit

struct AddDoctorResponse: Codable {
    let success: Bool
    let message: String
}

class AddDoctorVC: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        submit()
    }
    
    func submit() {
        guard let username = nameTextField.text, !username.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            presentAlert(title: "Error", message: "Please fill all fields before submitting.")
            return
        }
        
        let addModel: [String: String] = [
            "username": username,
            "email": email,
            "password": password
        ]
        
        addDoctorAPI(with: addModel)
    }
    
    func addDoctorAPI(with formData: [String: String]) {
        APIHandler().postAPIValues(type: AddDoctorResponse.self, apiUrl: ServiceAPI.add, method: "POST", formData: formData) { result in
            switch result {
            case .success(let data):
                if data.success {
                    self.presentAlert(title: "Success", message: "Doctor added successfully") {
                        self.navigateToSelectProfileVC()
                    }
                } else {
                    self.presentAlert(title: "Failed", message: data.message)
                }
            case .failure(let error):
                self.presentAlert(title: "Error", message: "Failed to connect to the service: \(error.localizedDescription)")
            }
        }
    }
    
    func presentAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                completion?()  // Call completion handler if there is one
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func navigateToSelectProfileVC() {
        if let viewControllers = navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController.isKind(of: SelectProfileVC.self) {
                    self.navigationController?.popToViewController(viewController, animated: true)
                    return
                }
            }
        }
        if let selectProfileVC = storyboard?.instantiateViewController(withIdentifier: "SelectProfileVC") as? SelectProfileVC {
            navigationController?.pushViewController(selectProfileVC, animated: true)
        }
    }

}
