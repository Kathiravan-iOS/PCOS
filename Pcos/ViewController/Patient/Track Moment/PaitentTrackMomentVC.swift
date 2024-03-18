//
//  PaitentTrackMomentVC.swift
//  Pcos
//
//  Created by Karthik Babu on 06/11/23.
//

import UIKit

class PaitentTrackMomentVC: UIViewController {
    
    @IBOutlet weak var activityTable: UITableView!{
        didSet{
            activityTable.delegate = self
            activityTable.dataSource = self
        }
    }
    var name2 :String = ""
    var stepsData : StepsDataModel?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "ProgressBar", bundle: nil)
        let trackNib = UINib(nibName: "TrackViewTabCell", bundle: nil)
        let leader = UINib(nibName: "LeaderBoardCell", bundle: nil)
        let weightNib = UINib(nibName: "WeightMeasureCell", bundle: nil)
        let calories = UINib(nibName: "CaloriesCell", bundle: nil)
        let stepsnib = UINib(nibName: "StepsCell", bundle: nil)
        activityTable.register(nib, forCellReuseIdentifier: "ProgressBar")
        activityTable.register(trackNib.self, forCellReuseIdentifier: "TrackViewTabCell")
        activityTable.register(leader, forCellReuseIdentifier: "LeaderBoardCell")
        activityTable.register(weightNib, forCellReuseIdentifier: "WeightMeasureCell")
        activityTable.register(calories, forCellReuseIdentifier: "CaloriesCell")
        activityTable.register(stepsnib, forCellReuseIdentifier: "StepsCell")
        
        self.getStepsGraph { [weak self] success in
            guard let `self` = self else {return}
            if success {
                DispatchQueue.main.async {
                    self.activityTable.reloadData()
                }
            }
        }
    }
    
    func getStepsGraph(_ completionHandler : @escaping (Bool)-> Void) {
        let name = ["name": name2]
        APIHandler().postAPIValues(type: StepsDataModel.self, apiUrl: ServiceAPI.stepsGraph, method: "POST", formData: name) { result in
            switch result{
            case.success(let data):
                self.stepsData = data
                print(data)
                completionHandler(true)
            case.failure(let error):
                completionHandler(false)
                print(error)
            }
        }
    }
    
}


extension PaitentTrackMomentVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0) {
            let cell = activityTable.dequeueReusableCell(withIdentifier: "ProgressBar") as! ProgressBar
            cell.name24 = name2
            return cell
        }
        else if(indexPath.section == 1) {
            let cell = activityTable.dequeueReusableCell(withIdentifier: "TrackViewTabCell") as! TrackViewTabCell
            
            cell.viewPatientCatButton?.addAction(for: .tap) {
                
                let catVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "PcosCategory") as! PcosCategory
                catVC.shouldHideStartButton = true
                catVC.username4 = self.name2
                self.navigationController?.pushViewController(catVC, animated: true)
                
            }
            cell.assessmentButton?.addAction(UIAction(handler: { [weak self] _ in
                    guard let self = self else { return }
                    let urlString = "\(ServiceAPI.baseURL)assessment.php?username=\(self.name2)"
                    
                    guard let encodedURLString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                          let url = URL(string: encodedURLString) else {
                        return
                    }
                
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let data = data, error == nil else {
                        print("Error: \(error?.localizedDescription ?? "Unknown error")")
                        return
                    }
                    if let responseString = String(data: data, encoding: .utf8), responseString.contains("eligible") {
                        DispatchQueue.main.async {
                            guard let sampleVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SampleVC") as? SampleVC else { return }
                            self.navigationController?.pushViewController(sampleVC, animated: true)
                        }
                    } else {
                        DispatchQueue.main.async {
                            // Show alert for waiting
                            let alert = UIAlertController(title: "wait for the Assessment", message: "You can take the assessment every 2 weeks. Please wait a little longer.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default))
                            self.present(alert, animated: true)
                        }
                    }
                }
                task.resume()
            }), for: .touchUpInside)

            return cell

        }
        else if (indexPath.section == 2){
            let weightCell = activityTable.dequeueReusableCell(withIdentifier: "WeightMeasureCell") as! WeightMeasureCell
            return weightCell
        }
        else if (indexPath.section == 3){
            let leaderCell = activityTable.dequeueReusableCell(withIdentifier: "LeaderBoardCell") as! LeaderBoardCell
            // Usage example:
            UserDB.shared.setValue("LeaderBoardCell", forKey: "LeaderBoardCell")
            
            
            if let userName: String? = UserDB.shared.getValue(forKey: "LeaderBoardCell") {
                print("User Name: \(userName ?? "N/A")")
            }
            
            if let userAge: Int? = UserDB.shared.getValue(forKey: "LeaderBoardCell") {
                print("User Age: \(userAge ?? 0)")
            }
            
            return leaderCell
        }
        else if (indexPath.section == 4) {
            let stepsCell = activityTable.dequeueReusableCell(withIdentifier: "StepsCell") as! StepsCell
            
            
            if let stepsDataDays = stepsData?.days, let stepsCounts = self.stepsData?.stepsCounts {
                let doubleArray = stepsDataDays.map { Int($0) ?? 0 }
                let chartData = Dictionary(uniqueKeysWithValues: zip(doubleArray, stepsCounts))
                stepsCell.configure(with: chartData)
            }
            return stepsCell
        }
        
        return UITableViewCell(frame: .zero)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 3 {
            let leaderVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "LeaderShipBoardVC") as! LeaderShipBoardVC
            self.navigationController?.pushViewController(leaderVC, animated: true)
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    
}
