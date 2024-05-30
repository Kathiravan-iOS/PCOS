import UIKit

class ForgotPasswordVC: UIViewController {
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var password: UILabel!
    @IBOutlet weak var changePassword: UILabel!
    
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPwd: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameTF.delegate = TextFieldHelper.shared
        emailTF.delegate = TextFieldHelper.shared
        passwordTF.delegate = TextFieldHelper.shared
        confirmPwd.delegate = TextFieldHelper.shared
        
        customizeNavigationBar(title: "ForgotPassword")
        if UserDefaultsManager.shared.getUserName() == "Doctor" {
            userName.text = "Doctor ID"
        } else if UserDefaultsManager.shared.getUserName() == "Patient" {
            userName.text = "User Name"
        }
    }
    
    
    @IBAction func forgotPasswordAction(_ sender: Any) {
        GetforgotAPI()
    }
    
    func GetforgotAPI() {
        let forgotPasswordModel: [String: String] = [
            "username": userNameTF.text ?? "",
            "email": emailTF.text ?? "",
            "newpassword": passwordTF.text ?? "",
            "confirmpassword": confirmPwd.text ?? ""
        ]
        
        print("Raw data before decoding: \(forgotPasswordModel)")
        
        
        APIHandler().postAPIValues(type: ForgotPasswordModel.self, apiUrl: ServiceAPI.forgotPasswordURL, method: "POST", formData: forgotPasswordModel) { result in
            switch result {
            case .success(let data):
                if data.status != "success" {
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "Alert", message: data.message, preferredStyle: .alert)
                        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(cancelAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "Alert", message: data.message, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .cancel) { action in
                            self.LoginVC()
                        }
                        
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            case .failure(let error):
                print("Decoding error: \(error)")
            }
        }
    }
        func LoginVC() {
            
            if let navigationController = self.navigationController {
                for controller in navigationController.viewControllers {
                    if controller is LoginVC {
                        navigationController.popToViewController(controller, animated: true)
                        break
                    }
                }
            }
         
        }
    }
    
