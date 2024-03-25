import UIKit
//import LiquidLoader
class LoginVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userNameView: UIView!
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var forgotBtn: UIButton!

    var loginModel: LoginModel?
//    let red: CGFloat = 255 / 255.0 // Example red value (0 to 1)
//    let green: CGFloat = 172 / 255.0 // Example green value (0 to 1)
//    let blue: CGFloat = 211 / 255.0 // Example blue value (0 to 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTF.text = "shobana"
        passwordTF.text = "123456789"
        userNameTF.delegate = self
        passwordTF.delegate = self
        passwordTF.isSecureTextEntry = true
        Didload()

        forgotBtn.addAction(for: .tap) {
            let doctorVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
            self.navigationController?.pushViewController(doctorVC, animated: true)
        }
    }

    @IBAction func loginAction(_ sender: Any) {
        self.getLoginAPI()
    }

    func getLoginAPI() {
        let userInfo: [String: String] = [
            "username": userNameTF.text ?? "",
            "password": passwordTF.text ?? ""
        ]
        self.view.startLoader()
        APIHandler.shared.postAPIValues(type: LoginModel.self, apiUrl: ServiceAPI.loginURL, method: "POST", formData: userInfo) { result in
            DispatchQueue.main.async {
                self.view.stopLoader()
            }
            switch result {
            case .success(let data):
                if !data.success! {
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "Alert", message: data.message, preferredStyle: .alert)
                        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(cancelAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                } else {
                    self.loginModel = data
                    DispatchQueue.main.async {
                        self.navigateToNextScreen()
                    }
                }

            case .failure(let error):
                print(error)
            }
        }
    }


    func navigateToNextScreen() {
        guard let role = loginModel?.role else { return }

        let expectedRole = UserDefaultsManager.shared.getUserName()?.lowercased()

        if role.lowercased() != expectedRole {
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: "Role Mismatch", message: "Your user role does not match the expected role. Please select the correct profile.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                    let selectProfileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectProfileVC") as! SelectProfileVC
                    self.navigationController?.pushViewController(selectProfileVC, animated: true)
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        } else {
            switch role.lowercased() {
            case "doctor":
                let doctorVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DoctorHomeVC") as! DoctorHomeVC
                self.navigationController?.pushViewController(doctorVC, animated: true)
            case "patient":
                if loginModel?.existingUser == true {
                    let patientPlanVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PatientPlanVC") as! PatientPlanVC
                    patientPlanVC.username5 = self.userNameTF.text ?? ""
                    self.navigationController?.pushViewController(patientPlanVC, animated: true)
                } else {
                    let enterPatientDetailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EnterPatientDetails") as! EnterPatientDetails
                    enterPatientDetailsVC.receivedUsername = self.userNameTF.text ?? ""
                    self.navigationController?.pushViewController(enterPatientDetailsVC, animated: true)
                }
            default:
                print("Unknown role: \(role)")
            }
        }
    }



    func Didload() {
        if UserDefaultsManager.shared.getUserName() == "Doctor" {
            forgotBtn.isHidden = false
            userNameTF.placeholder = "DOCTOR ID"
            passwordTF.placeholder = "PASSWORD"
        } else if UserDefaultsManager.shared.getUserName() == "Patient" {
            forgotBtn.isHidden = false
            userNameTF.placeholder = "USERNAME"
            passwordTF.placeholder = "PASSWORD"
        }
    }
}

extension UITextField {
    func setGradient(startColor: UIColor, endColor: UIColor) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.frame = self.bounds
        gradient.cornerRadius = 6
        self.layer.addSublayer(gradient)
    }
}
