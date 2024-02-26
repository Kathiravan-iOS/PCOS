import UIKit

struct MedicalRecordResponse: Codable {
    let success: Bool
    let message: String?
    let records: [Record]
}

struct Record: Codable {
    let recordPath: String

    enum CodingKeys: String, CodingKey {
        case recordPath = "record_path"
    }
}

class PatientMedicalRecordVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var reportName: String = ""
    var records: [Record] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        fetchMedicalRecords()
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 10
            layout.minimumInteritemSpacing = 10 
        }

    }
    
    func fetchMedicalRecords() {
            let urlString = "\(ServiceAPI.baseURL)view_reports.php"
            guard let url = URL(string: urlString) else { return }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

            let postData = "name=\(reportName)".data(using: .utf8)
            request.httpBody = postData

            let session = URLSession.shared
            session.dataTask(with: request) { [weak self] (data, response, error) in
                guard let data = data, error == nil else {
                    print("Failed to fetch data: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                do {
                    let decodedResponse = try JSONDecoder().decode(MedicalRecordResponse.self, from: data)
                    if decodedResponse.success {
                        DispatchQueue.main.async {
                            self?.records = decodedResponse.records
                            self?.collectionView.reloadData()
                        }
                    } else {
                        DispatchQueue.main.async {
                            self?.showAlertWith(message: decodedResponse.message ?? "No record found")
                        }
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }.resume()
        }

    func showAlertWith(message: String) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if UserDefaultsManager.shared.getUserName() == "Doctor" {
                if let doctorHomeVC = storyboard.instantiateViewController(withIdentifier: "DoctorCatInstructionVC") as? DoctorCatInstructionVC {
                    doctorHomeVC.selectedPatientName = self.reportName
                    self.navigationController?.pushViewController(doctorHomeVC, animated: true)
                }
            } else if UserDefaultsManager.shared.getUserName() == "Patient" {
                if let patientPlanVC = storyboard.instantiateViewController(withIdentifier: "PatientPlanVC") as? PatientPlanVC {
                    patientPlanVC.username5 = self.reportName
                    self.navigationController?.pushViewController(patientPlanVC, animated: true)
                }
            }
        }
        alertController.addAction(action)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }


    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return records.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? MedicalRecordCell else {
            fatalError("Unable to dequeue MedicalRecordCell")
        }
        let record = records[indexPath.row]
        cell.loadImage(from: record.recordPath)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfColumns: CGFloat = 2
        let spacingBetweenCells: CGFloat = 10
        let totalSpacing = (2 * spacingBetweenCells) + ((numberOfColumns - 1) * spacingBetweenCells)
        
        let width = (collectionView.bounds.width - totalSpacing) / numberOfColumns
        let height = width
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let record = records[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "view_reportVC") as? view_reportVC {
            viewController.imageUrl = record.recordPath
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}


