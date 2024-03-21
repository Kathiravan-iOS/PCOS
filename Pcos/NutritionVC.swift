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
    //var calorieLimit: Double = 500
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nutritionTable.dataSource = self
        nutritionTable.delegate = self
        nutritionTable.allowsMultipleSelection = true
        nutritionTable.register(UITableViewCell.self, forCellReuseIdentifier: "NutritionCell")
        
        parseCSV()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nutritionData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NutritionCell", for: indexPath)
        let nutritionInfo = nutritionData[indexPath.row]
        
        cell.textLabel?.text = "\(nutritionInfo.name) - Calories: \(nutritionInfo.calories)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRows.insert(indexPath)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedRows.remove(indexPath)
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
        let alert = UIAlertController(title: "Selection Required", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func proceedWithSelectedItems() {
        let selectedNutritionInfos = selectedRows.map { nutritionData[$0.row] }

        var postData = [String: Any]()
        postData["nameLabel"] = namef1

        var foodsData = [[String: Any]]()
        for nutritionInfo in selectedNutritionInfos {
            var foodData = [String: Any]()
            foodData["name"] = nutritionInfo.name
            foodData["calories"] = nutritionInfo.calories
            foodsData.append(foodData)
        }
        postData["foods"] = foodsData

        guard let jsonData = try? JSONSerialization.data(withJSONObject: postData) else {
            print("Error converting data to JSON")
            return
        }

        guard let url = URL(string: "\(ServiceAPI.baseURL)/insertFood.php") else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        // Send the request
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Unexpected response status code")
                return
            }
            
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("Response from server: \(responseString)")
                if responseString.lowercased().contains("successfully") {
                    DispatchQueue.main.async {
                        self.navigateToMealDetailsVC()
                    }
                }
            }
        }
        task.resume()
    }

    func navigateToMealDetailsVC() {
        let selectedNutritionInfos = selectedRows.map { nutritionData[$0.row] }
           let totalCalories = calculateTotalCalories()

           if let mealPlanVC = storyboard?.instantiateViewController(withIdentifier: "MealsDetailsVC") as? MealsDetailsVC {
               mealPlanVC.namelabel = namef1
               mealPlanVC.nutritionInfos = selectedNutritionInfos
               mealPlanVC.totalCalories = Double((totalCalories))
               mealPlanVC.nameLabelText = namelabel
               navigationController?.pushViewController(mealPlanVC, animated: true)
           }
       }

}
