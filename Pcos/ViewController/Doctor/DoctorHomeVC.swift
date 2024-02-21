import UIKit

class DoctorHomeVC: UIViewController {
    @IBOutlet weak var patientList: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    var allPatients: [String] = [] // Full list of patients
    var filteredPatients: [String] = [] // Filtered list based on search
    var selectedName: String? // Property to store the selected patient's name

    override func viewDidLoad() {
        super.viewDidLoad()
        patientList.delegate = self
        patientList.dataSource = self
        searchBar.delegate = self
        GetUserNameAPI()
    }
    @IBAction func addpatinet(_ sender: Any) {
        let addpatinet = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignupVC") as! SignupVC
        self.navigationController?.pushViewController(addpatinet, animated: true)
    }
    
    func GetUserNameAPI() {
        APIHandler().getAPIValues(type: PaitientListModel.self, apiUrl: ServiceAPI.patientlistURL, method: "GET") { result in
            switch result {
            case .success(let data):
                print(data)
                self.allPatients = data.usernames
                self.filteredPatients = data.usernames
                DispatchQueue.main.async {
                    self.patientList.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension DoctorHomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPatients.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PatientListTabCell", for: indexPath) as! PatientListTabCell
        cell.patientName.text = filteredPatients[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        patientList.deselectRow(at: indexPath, animated: true)
          if let cell = tableView.cellForRow(at: indexPath) {
              cell.contentView.backgroundColor = .white // Set your desired background color
          }
        // Store the selected patient's name
        selectedName = filteredPatients[indexPath.row]

        // Navigate to DoctorCatInstructionVC
        let doctorCatInstructionVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DoctorCatInstructionVC") as! DoctorCatInstructionVC
        doctorCatInstructionVC.selectedPatientName = selectedName
        self.navigationController?.pushViewController(doctorCatInstructionVC, animated: true)
    }
}

extension DoctorHomeVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterPatients(with: searchText)
    }

    func filterPatients(with searchText: String) {
        if searchText.isEmpty {
            filteredPatients = allPatients
        } else {
            filteredPatients = allPatients.filter { $0.lowercased().contains(searchText.lowercased()) }
        }
        patientList.reloadData()
    }
    
}
