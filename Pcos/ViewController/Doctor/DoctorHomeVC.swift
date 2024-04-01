import UIKit

class DoctorHomeVC: UIViewController {
    @IBOutlet weak var patientList: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    @IBOutlet weak var logout: UIImageView!
    
    var allPatients: [String] = []
    var filteredPatients: [String] = []
    var selectedName: String?
    func reloadData() {
        GetUserNameAPI()
        }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        patientList.delegate = self
        patientList.dataSource = self
        searchBar.delegate = self
        setupLogoutTapGesture()
        GetUserNameAPI()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    func setupLogoutTapGesture() {
           logout.isUserInteractionEnabled = true
           let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleLogoutTap))
           logout.addGestureRecognizer(tapGesture)
       }
    @objc func handleLogoutTap() {
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { action in
            self.clearUserDefaults()
            self.navigationController?.popToRootViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "PatientListTabCell", for: indexPath) as! PatientListTabCell
        cell.selectionStyle = .none
        selectedName = filteredPatients[indexPath.row]

        let doctorCatInstructionVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DoctorCatInstructionVC") as! DoctorCatInstructionVC
        doctorCatInstructionVC.selectedPatientName = selectedName
        self.navigationController?.pushViewController(doctorCatInstructionVC, animated: true)
    }
}

extension DoctorHomeVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterPatients(with: searchText)
    }
    func clearUserDefaults() {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
    }
    func filterPatients(with searchText: String) {
        if searchText.isEmpty {
            filteredPatients = allPatients
        } else {
            filteredPatients = allPatients.filter { $0.lowercased().contains(searchText.lowercased()) }
        }

        patientList.reloadData()

        if filteredPatients.isEmpty && !searchText.isEmpty {
            showAlertForNoPatientFound()
        }
    }

    func showAlertForNoPatientFound() {
        let alert = UIAlertController(title: "No Patient Found", message: "No patient matches the search.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}

