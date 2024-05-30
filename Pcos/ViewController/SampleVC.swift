import UIKit

class SampleVC: UIViewController {
    var username2: String = ""
    
    var mainMild = 0
    var mainModerate = 0
    var mainSevere = 0
    var didSelect = false
    var isAnswerSelected = false
  
    var selectedIndexPath: IndexPath? = nil

    @IBOutlet weak var qnsAnsList: UITableView! {
        didSet {
            qnsAnsList.delegate = self
            qnsAnsList.dataSource = self
        }
    }
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var next_Ot: UIButton!
    @IBOutlet weak var qnsLbl: UILabel!
    
    var qnsAnsData: QnsAnsModel?
    var currentQuestionIndex: Int = 0
    var optionModelData: [OptionSubModel] = [OptionSubModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topView.layer.cornerRadius = topView.frame.size.width / 2
        let maskedCorners: CACornerMask = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        topView.layer.maskedCorners = maskedCorners
        view.addSubview(topView)
        GetQnsAnsList()
    }
    
    @IBAction func nextAc(_ sender: Any) {

    }
    func qnsValue(mild: Int, moderate: Int, severe: Int) {
        
    }
    
    @IBAction func previous(_ sender: Any) {
    }
    
   
    
    func GetQnsAnsList() {
        APIHandler().getAPIValues(type: QnsAnsModel.self, apiUrl: ServiceAPI.qnsAnsUrl, method: "GET") { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let data):
                self.qnsAnsData = data
                DispatchQueue.main.async {
                    self.nextQnsLoad()
                    self.qnsAnsList.reloadData()
                }
            }
        }
    }
    
    func nextQnsLoad() {
        if self.currentQuestionIndex < (self.qnsAnsData?.questions.count ?? 0) {

            let qnsAnsData = self.qnsAnsData!.questions[self.currentQuestionIndex]
            self.qnsLbl.text = qnsAnsData.question
            self.optionModelData = qnsAnsData.options
            self.qnsAnsList.reloadData()
        } else {
            postScoresToAPI()

            let story = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "Gifloader") as! Gifloader
            story.usernamee = username2
            self.navigationController?.pushViewController(story, animated: true)
        }
    }
    
    func previousQnsLoad() {
        if self.currentQuestionIndex > 0 {
            self.currentQuestionIndex -= 1
            let qnsAnsData = self.qnsAnsData!.questions[self.currentQuestionIndex]
            self.qnsLbl.text = qnsAnsData.question
            self.optionModelData = qnsAnsData.options
            self.qnsAnsList.reloadData()
        } else {
            
        }
    }
}

extension SampleVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return optionModelData.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = qnsAnsList.dequeueReusableCell(withIdentifier: "QnsAnsTabCell", for: indexPath) as! QnsAnsTabCell
        isAnswerSelected = false
        cell.ansLbl.text = optionModelData[indexPath.row].optionText
        next_Ot.isHidden = true
        return cell
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var mild = 0
        var moderate = 0
        var severe = 0
        qnsAnsList.deselectRow(at: indexPath, animated: true)
          if let cell = tableView.cellForRow(at: indexPath) {
              cell.contentView.backgroundColor = .white // Set your desired background color
          }
        let cell = qnsAnsList.dequeueReusableCell(withIdentifier: "QnsAnsTabCell", for: indexPath) as! QnsAnsTabCell
        
        if let cell = tableView.cellForRow(at: indexPath) as? QnsAnsTabCell {
            next_Ot.isHidden = false
            let isSelected = indexPath == selectedIndexPath
            if isSelected {
                cell.checkBtn.setImage(UIImage(named: "unselected"), for: .normal)
                selectedIndexPath = nil
                isAnswerSelected = false
            } else {
                if let previousIndexPath = selectedIndexPath, let previousCell = tableView.cellForRow(at: previousIndexPath) as? QnsAnsTabCell {
                    previousCell.checkBtn.setImage(UIImage(named: "unselected"), for: .normal)
                    isAnswerSelected = false
                }
                cell.checkBtn.setImage(UIImage(named: "selected"), for: .normal)
                selectedIndexPath = indexPath
                isAnswerSelected = true
            }
        }
        switch indexPath.row {
        case 0..<3:
            mild += 1
        case 3..<6:
            moderate += 1
        case 6..<8:
            severe += 1
        default:
            break
        }
        self.next_Ot.addAction(for: .tap) {
            if !self.isAnswerSelected {
                self.popUpAlert(title: "", message: "Please select any option", actionTitles: ["OK"], actionStyle: [.cancel]) { _ in
                    
                }
            } else {
                self.currentQuestionIndex = self.currentQuestionIndex + 1
                self.mainMild += mild
                self.mainModerate += moderate
                self.mainSevere += severe
                self.selectedIndexPath = nil
                print("mainMild",self.mainMild,"mainModerate",self.mainModerate,"mainSevere",self.mainSevere)
                UserDB.shared.setValue(self.mainMild, forKey: "mainMild")
                UserDB.shared.setValue(self.mainModerate, forKey: "mainModerate")
                UserDB.shared.setValue(self.mainSevere, forKey: "mainSevere")
                
                for cell in self.qnsAnsList.visibleCells as! [QnsAnsTabCell] {
                    cell.checkBtn.setImage(UIImage(named: "unselected"), for: .normal)
                }
                self.nextQnsLoad()
                self.qnsAnsList.reloadData()
                
            }
            _ = self.optionModelData[indexPath.row].optionText
        }
    }
}

class QnsAnsTabCell : UITableViewCell {
    @IBOutlet weak var ansLbl : UILabel!
    @IBOutlet weak var checkBtn : UIButton!
}

// MARK: - Networking
extension SampleVC {
    func postScoresToAPI() {
        guard let url = URL(string: "\(ServiceAPI.baseURL)ans.php") else {
            print("Invalid URL")
            return
        }

        let parameters: [String: Any] = [
            "name": self.username2,
            "mild": self.mainMild,
            "moderate": self.mainModerate,
            "severe": self.mainSevere
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = parameters.percentEncoded()

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Server Error")
                return
            }
            if let mimeType = httpResponse.mimeType, mimeType == "application/json",
               let data = data,
               let string = String(data: data, encoding: .utf8) {
                print("Response: \(string)")
            }
        }

        task.resume()
    }
}

extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}
