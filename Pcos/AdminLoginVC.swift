//
//  AdminLoginVC.swift
//  
//
//  Created by SAIL on 12/04/24.
//

import UIKit
struct adminl: Codable {
    let success: Bool
    let message: String
}

class AdminLoginVC: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var password: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func loginadmin(_ sender: Any) {
        getLoginAPI()
        
    }
    func getLoginAPI() {
        let userInfo: [String: String] = [
            "username": username.text ?? "",
            "password": password.text ?? ""
        ]
        self.view.startLoader()
        APIHandler.shared.postAPIValues(type: adminl.self, apiUrl: ServiceAPI.admin, method: "POST", formData: userInfo) { result in
            DispatchQueue.main.async {
                self.view.stopLoader()
            }
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
                        self.navigateToNextScreen()
                    }
                }

            case .failure(let error):
                print(error)
            }
        }
    }
    func navigateToNextScreen(){
        if let viewControllers = navigationController?.viewControllers {
        for viewController in viewControllers {
            if viewController.isKind(of: AddDoctorVC.self) {
                self.navigationController?.popToViewController(viewController, animated: true)
                return
            }
        }
    }
    if let selectProfileVC = storyboard?.instantiateViewController(withIdentifier: "AddDoctorVC") as? AddDoctorVC {
        navigationController?.pushViewController(selectProfileVC, animated: true)
    }
}
}
