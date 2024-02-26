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
        
        customizeNavigationBar(title: "ForgotPassword")
        if UserDefaultsManager.shared.getUserName() == "Doctor" {
            userName.text = "Doctor ID"
        } else if UserDefaultsManager.shared.getUserName() == "Patient" {
            userName.text = "User Name"
        }
    }
    
    // Function to handle the forgot password action
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
        
        // Print or log the raw data before decoding
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
            let forgotvc = UIStoryboard(name: "Main", bundle: nil)
            let vc = forgotvc.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
