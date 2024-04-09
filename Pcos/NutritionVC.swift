//
//  NutritionVC.swift
//  Pcos
//
//  Created by SAIL on 07/03/24.
//
struct NutritionInfo {
    var name: String
    var calories: Double
}

import UIKit

class NutritionVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var namelabel:String = ""
    @IBOutlet weak var nutritionTable: UITableView!
    var selectedRows = Set<IndexPath>()
    var nutritionData: [NutritionInfo] = []
    var namef1 : String = ""
    var type: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nutritionTable.dataSource = self
        nutritionTable.delegate = self
        nutritionTable.allowsMultipleSelection = true
        nutritionTable.register(UITableViewCell.self, forCellReuseIdentifier: "NutritionCell")
        
        parseCSV()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nutritionData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NutritionCell", for: indexPath)
        let nutritionInfo = nutritionData[indexPath.row]
        
        cell.textLabel?.text = "\(nutritionInfo.name) - Calories: \(nutritionInfo.calories)"
        cell.selectionStyle = .none
        if selectedRows.contains(indexPath) {
            cell.backgroundColor = UIColor(red: 255/255.0, green: 162/255.0, blue: 207/255.0, alpha: 1.0)
        } else {
            cell.backgroundColor = .white
        }
        
        return cell
    }


    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRows.insert(indexPath)
        tableView.cellForRow(at: indexPath)?.backgroundColor = UIColor(red: 255/255.0, green: 162/255.0, blue: 207/255.0, alpha: 1.0)
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedRows.remove(indexPath)
        tableView.cellForRow(at: indexPath)?.backgroundColor = .white
    }
    
    func parseCSV() {
        guard let filepath = Bundle.main.path(forResource: "nutrition", ofType: "csv") else {
            print("CSV file not found")
            return
        }
        
        do {
            let data = try String(contentsOfFile: filepath, encoding: .utf8)
            let rows = data.components(separatedBy: "\n")
            
            for (index, row) in rows.enumerated() {
                if index == 0 || row.isEmpty { continue }
                
                let columns = row.components(separatedBy: ",")
                if columns.count >= 2 {
                    let nutritionInfo = NutritionInfo(
                        name: columns[0],
                        calories: Double(columns[1].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0.0
                    )
                    nutritionData.append(nutritionInfo)
                }
            }
            
            DispatchQueue.main.async {
                self.nutritionTable.reloadData()
            }
        } catch {
            print("Error reading CSV file: \(error)")
        }
    }

    
    func calculateTotalCalories()  -> Int {
        var totalCalories: Double = 0
        for indexPath in selectedRows {
            totalCalories += nutritionData[indexPath.row].calories
        }
        return Int(totalCalories)
    }
    @IBAction func backmeal(_ sender: Any) {
        let totalCalories = Double(calculateTotalCalories())

                if totalCalories <= 500 {
                    proceedWithSelectedItems()
                } else {
                    showAlertWith(message: "Your calorie value exceeds the limit.")
                }
            }
    func showAlertWith(message: String) {
        let alert = UIAlertController(title: "Limit Your Calorie Intake", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func proceedWithSelectedItems() {
        let selectedNutritionInfos = selectedRows.map { nutritionData[$0.row] }
        let totalCalories = calculateTotalCalories()

        var request = URLRequest(url: URL(string: "\(ServiceAPI.baseURL)/insertFood.php")!)
        request.httpMethod = "POST"
        let postData = "name=\(namef1)&type=\(type)&calorie=\(totalCalories)"
        request.httpBody = postData.data(using: .utf8)

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseString = String(data: data, encoding: .utf8) ?? ""
            if responseString.contains("successfully") {
                DispatchQueue.main.async {
                    self.navigateToMealDetailsVC()
                }
            } else {
                print("Server response: \(responseString)")
            }
        }.resume()
    }
    func navigateToMealDetailsVC() {
        let selectedNutritionInfos = selectedRows.map { nutritionData[$0.row] }
           let totalCalories = calculateTotalCalories()

           if let mealPlanVC = storyboard?.instantiateViewController(withIdentifier: "MealsDetailsVC") as? MealsDetailsVC {
               mealPlanVC.namelabel = namef1
               mealPlanVC.type1 = type
               mealPlanVC.nutritionInfos = selectedNutritionInfos
               mealPlanVC.totalCalories = Double((totalCalories))
               mealPlanVC.nameLabelText = namelabel
               navigationController?.pushViewController(mealPlanVC, animated: true)
           }
       }

}
