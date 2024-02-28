//
//  PatientPlanVC.swift
//  Pcos
//
//  Created by Karthik Babu on 04/11/23.
//

import UIKit

class PatientPlanVC: UIViewController {
    var username5 : String = ""
    var headerTitles = ["Start your routine", "Stay Hydrated Drink Water!"]
        var currentHeaderTitle: String = "Select Your Routine"
    @IBOutlet weak var homename: UILabel!
    
    @IBOutlet weak var patientTable: UITableView!{
        didSet {
            patientTable.delegate = self
            patientTable.dataSource = self
        }
    }
    var mealItems = ["Meal Plan", "Exercise", "Track Your Moment"]
    var imageName = ["girl1", "girl2", "girls3"]
    var sideMenu: SideMenuViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        startHeaderTitleRotation()
        homename.text = "Welcome, \(username5)"
        self.sideMenu?.view.frame.origin.x = -self.view.frame.size.width

        let secNib = UINib(nibName: "SectionTitleCell", bundle: nil)
        let planNib = UINib(nibName: "MealPlanCell", bundle: nil)
        let calenderNib = UINib(nibName: "CalendarCell", bundle: nil)

        
        patientTable.register(secNib, forCellReuseIdentifier: "SectionTitleCell")
        patientTable.register(planNib, forCellReuseIdentifier: "MealPlanCell")
        patientTable.register(calenderNib, forCellReuseIdentifier: "CalendarCell")

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "profile 2"), style: .plain, target: self, action: #selector(profilePage))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .plain, target: self, action: #selector(openSideMenu))
        
        sideMenu = SideMenuViewController()
        
        sideMenu?.username6 = username5
        
        addChild(sideMenu!)
        view.addSubview(sideMenu!.view)
        sideMenu!.didMove(toParent: self)
        sideMenu!.view.frame = CGRect(x: view.frame.size.width, y: 0, width: view.frame.size.width, height: view.frame.size.height)
    }
    func startHeaderTitleRotation() {
           Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] timer in
               guard let self = self else { return }
               self.currentHeaderTitle = self.headerTitles.randomElement() ?? "Select Your Routine"
               DispatchQueue.main.async {
                   self.patientTable.reloadSections([0], with: .none)
               }
           }
       }
    
    @objc func profilePage(){
        let patientVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "PatientProfileVC") as! PatientProfileVC
        patientVC.shouldHideeditButton = true
        patientVC.selectedPatientName = username5
        self.navigationController?.pushViewController(patientVC, animated: true)
    }
    @objc func openSideMenu() {
        UIView.animate(withDuration: 0.5) {
            self.sideMenu?.view.frame.origin.x = 0
            self.sideMenu?.navigationController?.navigationItem.rightBarButtonItem?.tintColor = UIColor(hex: "#FF89C0")
        }
    }
}

extension PatientPlanVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }
        else if section == 1 {
            return 1
        }
        else if section == 2 {
            return 1
        }
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let label = UILabel()
            label.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 50)
            label.textAlignment = .center
            label.text = currentHeaderTitle
            //label.textColor = UIColor(red: 212/255.0, green: 89/255.0, blue: 143/255.0, alpha: 1.0)
            label.font = UIFont(name: "TimesNewRoman", size: 21.0)
            return label
        }
        else if section == 1 {
            let label = UILabel()
            label.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 50)
            label.textAlignment = .center
            label.text = "Strengthen your positive thoughts with gratitude"
            //label.textColor = UIColor(red: 212/255.0, green: 89/255.0, blue: 143/255.0, alpha: 1.0)
            label.font = UIFont(name: "TimesNewRoman", size: 21.0)
            return label
        }
        else if section == 2 {
            // Create a container view to hold the label and the image
            let containerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 50))
            containerView.backgroundColor = UIColor(red: 255/255.0, green: 162/255.0, blue: 207/255.0, alpha: 1)

            // Create the label
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: containerView.bounds.width - 50, height: 50))
            label.textAlignment = .center
            label.text = "RECORD DAILY PROGRESS"
            label.clipsToBounds = true
            label.backgroundColor = .clear // Set label's background color to be transparent
            label.layer.shadowColor = UIColor.black.cgColor
            label.layer.shadowOffset = CGSize(width: 0, height: 2)
            label.layer.shadowOpacity = 0.5
            label.layer.shadowRadius = 2
            containerView.addSubview(label)

            // Create the image view
            let imageView = UIImageView(frame: CGRect(x: containerView.bounds.width - 50, y: 0, width: 50, height: 50))
            imageView.contentMode = .center
            imageView.image = UIImage(named: "Right")
            containerView.addSubview(imageView)

            // Add tap gesture to the container view
            containerView.addAction(for: .tap) {
                let dailyVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "recorddailyprogreeVC") as! recorddailyprogreeVC
                dailyVC.recordname = self.username5
                self.navigationController?.pushViewController(dailyVC, animated: true)
            }

            return containerView
        }



    return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            let cell = patientTable.dequeueReusableCell(withIdentifier: "MealPlanCell") as! MealPlanCell
            cell.planName.text = mealItems[indexPath.row]
            cell.images.image = UIImage(named: imageName[indexPath.row])
            return cell
        }
        else if (indexPath.section == 1) {
            let cell = patientTable.dequeueReusableCell(withIdentifier: "CalendarCell") as! CalendarCell
            cell.usernameForCalendar = username5
            return cell
        }
        else if (indexPath.section == 2) {
            let cell = patientTable.dequeueReusableCell(withIdentifier: "MealPlanCell") as! MealPlanCell
            cell.planName.text = "Meditation"
            cell.images.image = UIImage(named: "meditation")
            return cell
        }
        return UITableViewCell(frame: .zero)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        patientTable.deselectRow(at: indexPath, animated: true)
          if let cell = tableView.cellForRow(at: indexPath) {
              cell.contentView.backgroundColor = .white 
          }
        if (indexPath.section == 0) {
            if indexPath.row == 0 {
                let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WeightGoalListVC") as! WeightGoalListVC
                self.navigationController?.pushViewController(nextVC, animated: true)
                
            }
            else if indexPath.row == 1 {
                let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ExerciseListVC") as! ExerciseListVC
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
            
            else if indexPath.row == 2 {
                let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PaitentTrackMomentVC") as! PaitentTrackMomentVC
                nextVC.name2 = username5
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
           
       }
        if (indexPath.section == 2) {
            let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MeditationHomeVC") as! MeditationHomeVC
            self.navigationController?.pushViewController(nextVC, animated: true)
          
       }
    }
}
