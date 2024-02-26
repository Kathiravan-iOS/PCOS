import UIKit

class SignupVC: UIViewController {
    @IBOutlet weak var Suername: UILabel!
    @IBOutlet weak var Sconfirmpassword: UILabel!
    @IBOutlet weak var Spassword: UILabel!
    @IBOutlet weak var SEmail: UILabel!
    
    @IBOutlet weak var usertxt: UITextField!
    @IBOutlet weak var emailtxt: UITextField!
    @IBOutlet weak var passwordtxt: UITextField!
    @IBOutlet weak var confirmtxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeNavigationBar(title: "Add Patient")
    }
    
    @IBAction func signupbt(_ sender: Any) {
        validateSignup()
    }
    
    func validateSignup() {
        guard let username = usertxt.text, !username.isEmpty,
              let email = emailtxt.text, !email.isEmpty,
              let password = passwordtxt.text, !password.isEmpty,
              let confirmPassword = confirmtxt.text, !confirmPassword.isEmpty else {
            showAlert(message: "Please fill in all fields.")
            return
        }
        
        guard email.hasSuffix("@gmail.com") else {
            showAlert(message: "Please enter a valid Gmail address.")
            return
        }
        
        let requiredPasswordLength = 8 // Set your required password length here
        guard password.count == requiredPasswordLength else {
            showAlert(message: "Password should be \(requiredPasswordLength) characters long.")
            return
        }
        
        guard password == confirmPassword else {
            showAlert(message: "Password and confirm password do not match.")
            return
        }

        // If all validations pass, proceed with API call
        GetSignupAPI()
    }
    
    func showAlert(message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func GetSignupAPI() {
        let SignupModel: [String:String]=[
            "username": usertxt.text ?? "",
            "email": emailtxt.text ?? "",
            "password": passwordtxt.text ?? "",
            "confirm_password": confirmtxt.text ?? ""
        ]
        
        APIHandler().postAPIValues(type: SignupResponse.self, apiUrl: ServiceAPI.SignupURL, method: "POST", formData: SignupModel){
            result in switch result{
            case .success(let data):
                if data.success {
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "Success", message: "Patient added successfully", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                            self.detailsVC(username: self.usertxt.text ?? "")
                        }
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "Alert", message: data.message, preferredStyle: .alert)
                        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(cancelAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            case .failure(let error):
                print("Decoding error: \(error)")
            }
        }
    }

    
    func detailsVC(username : String) {
        let signup = UIStoryboard(name: "Main", bundle: nil)
        let vc = signup.instantiateViewController(withIdentifier: "DoctorHomeVC") as! DoctorHomeVC
//        vc.username = username
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
