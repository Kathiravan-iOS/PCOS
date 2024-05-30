import UIKit

class WeeklyProgressVC: UIViewController {

    @IBOutlet weak var from: UIDatePicker!
    @IBOutlet weak var to_date: UIDatePicker!
    var name: String = ""
    @IBOutlet weak var weeklyTableView: UITableView!{
        didSet{
            weeklyTableView.delegate = self
            weeklyTableView.dataSource = self
        }
    }

    var weeklyData: [WeeklyProgress] = []

    override func viewDidLoad() {
        super.viewDidLoad()
      
    }

    @IBAction func viewData(_ sender: Any) {
        fetchData(fromDate: from.date, toDate: to_date.date, name: name)
    }
    
    func fetchData(fromDate: Date, toDate: Date, name: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let fromDateString = dateFormatter.string(from: fromDate)
        let toDateString = dateFormatter.string(from: toDate)
        
        let parameters = ["from_date": fromDateString, "to_date": toDateString, "name": name]

        APIHandler.shared.postAPIValues(type: WeeklyModel.self, apiUrl: ServiceAPI.weeklyProgress, method: "POST", formData: parameters) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                if !data.data.isEmpty {
                    self.weeklyData = data.data
                    DispatchQueue.main.async {
                        self.weeklyTableView.reloadData()
                    }
                } else {
                    self.showAlert(title: "No Records", message: "No records recorded for the selected period.")
                }
            case .failure(let error):
                print(error)
                self.showAlert(title: "Error", message: "No Records Found \(error.localizedDescription)")
            }
        }
    }

    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(okAction)
        DispatchQueue.main.async { [weak self] in
            self?.present(alertController, animated: true)
        }
    }

}

extension WeeklyProgressVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weeklyData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeeklyProgressTableCell", for: indexPath) as! WeeklyProgressTableCell
        let item = weeklyData[indexPath.row]
        cell.configure(with: item)
        return cell
    }
}
