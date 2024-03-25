//
//  SideMenu.swift
//  Sidemenu
//
//  Created by Haris Madhavan on 07/11/23.
//

import Foundation
import UIKit

class SideMenuViewController: UIViewController {
    
    var username6 : String = ""
    let admingMenuTitle = ["Home", "Edit Profile", "About PCOS", "Reports", "Logout"]


    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        view.backgroundColor = .clear
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(hex: "#FF89C0")
        let BaseView = UIView()
        BaseView.backgroundColor = .white
        BaseView.layer.borderColor = UIColor(hex: "#FF89C0").cgColor//CGColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
        BaseView.layer.borderWidth = 1
        BaseView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(BaseView)
        
        let imageView = UIImageView()
            imageView.image = UIImage(named: "pcos1 1") // Set the image for the UIImageView
            imageView.translatesAutoresizingMaskIntoConstraints = false
            BaseView.addSubview(imageView)
        
        let MenuTableView = UITableView()
        MenuTableView.delegate = self
        MenuTableView.dataSource = self
        MenuTableView.translatesAutoresizingMaskIntoConstraints = false
        BaseView.addSubview(MenuTableView)
        
        NSLayoutConstraint.activate([
            BaseView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            BaseView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            BaseView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            BaseView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            
            imageView.topAnchor.constraint(equalTo: BaseView.topAnchor, constant: 75),
            imageView.centerXAnchor.constraint(equalTo: BaseView.centerXAnchor), // Center horizontally
            imageView.widthAnchor.constraint(equalTo: BaseView.widthAnchor, multiplier: 0.5),
            imageView.heightAnchor.constraint(equalTo: BaseView.heightAnchor, multiplier: 0.15),
            
            MenuTableView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 0),
            MenuTableView.leadingAnchor.constraint(equalTo: BaseView.leadingAnchor, constant: 0),
            MenuTableView.bottomAnchor.constraint(equalTo: BaseView.bottomAnchor, constant: 0),
            MenuTableView.trailingAnchor.constraint(equalTo: BaseView.trailingAnchor, constant: 0)
        ])

    }
    override func viewDidDisappear(_ animated: Bool) {
        self.view.frame.origin.x = self.view.frame.size.width
        self.navigationController?.navigationBar.isHidden = false

    }
    

}

extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return admingMenuTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.contentView.layer.borderColor = UIColor(hex: "#FF89C0").cgColor//CGColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
        cell.contentView.layer.borderWidth = 1
        
        cell.textLabel?.text = admingMenuTitle[indexPath.row]
        if indexPath.row % 2 == 0 {
            cell.textLabel?.textColor = UIColor(hex: "#FF89C0")//UIColor(red: 255/255, green: 172/255, blue: 211/255, alpha: 1.0)
         } else {
             // Set a different text color for odd rows
             cell.textLabel?.textColor =  UIColor(hex: "#FF89C0") //UIColor(red: 255/255, green: 172/255, blue: 211/255, alpha: 1.0)
         }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
          if let cell = tableView.cellForRow(at: indexPath) {
              cell.contentView.backgroundColor = .white // Set your desired background color
          }
        
        let nameListIndex = admingMenuTitle[indexPath.row]
        switch nameListIndex {
        case "Home":
            UIView.animate(withDuration: 0.5) {
                self.view.frame.origin.x = self.view.frame.size.width
            }
        case "Edit Profile" :
            let profileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "PatientProfileVC") as! PatientProfileVC
            profileVC.selectedPatientName = username6
            self.navigationController?.pushViewController(profileVC, animated: true)
            print("Profile")
        case "About PCOS":
            let Animation = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Animation") as! Animation
            self.navigationController?.pushViewController(Animation, animated: true)
            print("About PCOS")
        case "Reports":
            let reports = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MedicalrepothomeViewController") as! MedicalrepothomeViewController
            reports.name = username6
            self.navigationController?.pushViewController(reports, animated: true)
            print("Reports")
        case "Logout":
            let logoutVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SelectProfileVC") as! SelectProfileVC
            self.navigationController?.pushViewController(logoutVC, animated: true)
            print("Logout")
//            if let navigationController = self.navigationController {
//                for controller in navigationController.viewControllers {
//                    if controller is SelectProfileVC {
//                        navigationController.popToViewController(controller, animated: true)
//                        break
//                    }
//                }
//            }
        default:
            break
        }
    }
}
