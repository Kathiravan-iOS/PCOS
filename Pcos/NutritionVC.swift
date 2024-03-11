//
//  NutritionVC.swift
//  Pcos
//
//  Created by SAIL on 07/03/24.
//
struct NutritionInfo {
    var name: String
    var emoji: String
    var calories: Double
    var carbohydrates: Double
    var protein: Double
    var fat: Double
}

import UIKit

class NutritionVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var namelabel:String = ""
    @IBOutlet weak var nutritionTable: UITableView!
    var selectedRows = Set<IndexPath>()
    var nutritionData: [NutritionInfo] = []
    var namef1 : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nutritionTable.dataSource = self
        nutritionTable.delegate = self
        nutritionTable.allowsMultipleSelection = true
        nutritionTable.register(UITableViewCell.self, forCellReuseIdentifier: "NutritionCell")
        
        parseCSV()
    }
    
    
    // UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nutritionData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NutritionCell", for: indexPath)
        let nutritionInfo = nutritionData[indexPath.row]
        
        // Updated to include protein and fat in the displayed text
        cell.textLabel?.text = "\(nutritionInfo.name) \(nutritionInfo.emoji) - Calories: \(nutritionInfo.calories), Carbs: \(nutritionInfo.carbohydrates)g, Protein: \(nutritionInfo.protein)g, Fat: \(nutritionInfo.fat)g"
        
        return cell
    }
    
    
    // UITableViewDelegate Methods
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
                if index == 0 || row.isEmpty { continue } // Skipping header row and any empty row
                
                let columns = row.components(separatedBy: ",")
                if columns.count >= 6 { // Adjusted to check for at least 6 columns
                    let nutritionInfo = NutritionInfo(
                        name: columns[0],
                        emoji: columns[1],
                        calories: Double(columns[2]) ?? 0.0,
                        carbohydrates: Double(columns[3]) ?? 0.0,
                        protein: Double(columns[4]) ?? 0.0,
                        fat: Double(columns[5]) ?? 0.0
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
        
        let selectedNutritionInfos = selectedRows.map { nutritionData[$0.row] }

            var postData = [String: Any]()
            postData["nameLabel"] = namef1

            var foodsData = [[String: Any]]()
            for nutritionInfo in selectedNutritionInfos {
                var foodData = [String: Any]()
                foodData["calories"] = nutritionInfo.calories
                foodData["protein"] = nutritionInfo.protein
                foodData["carbohydrates"] = nutritionInfo.carbohydrates
                foodData["fat"] = nutritionInfo.fat
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
                
                // Assuming the responseString that indicates a successful insertion contains "successfully"
                if responseString.lowercased().contains("successfully") {
                    DispatchQueue.main.async {
                        // Navigate to the next view controller
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
               mealPlanVC.nutritionInfos = selectedNutritionInfos
               mealPlanVC.totalCalories = Double((totalCalories))
               mealPlanVC.nameLabelText = namelabel
               navigationController?.pushViewController(mealPlanVC, animated: true)
           }
       }

}
