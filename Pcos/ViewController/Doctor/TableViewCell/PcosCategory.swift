//
//  PcosCategory.swift
//  Pcos
//
//  Created by Karthik Babu on 05/10/23.
//

import UIKit

class PcosCategory: UIViewController {
    @IBOutlet weak var startButton: UIButton!
    
    var  username4 : String = ""
    var shouldHideStartButton: Bool = false
    var hideBackButton: Bool = false
    var patientScoreData : PaitentScoreModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.patientScoreAPI()
        if shouldHideStartButton {
            startButton.isHidden = true
            //self.navigationController?.navigationBar.isHidden = true
            if hideBackButton {
                       navigationItem.hidesBackButton = true
                   }
                   
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func progressBar() {
        let ringPieChartSize: CGFloat = 200
        let ringPieChartX = (view.bounds.width - ringPieChartSize) / 2
        let ringPieChartY = (view.bounds.height - ringPieChartSize) / 2

        let ringPieChartView = UIView(frame: CGRect(x: ringPieChartX, y: ringPieChartY, width: ringPieChartSize, height: ringPieChartSize))
        view.addSubview(ringPieChartView)
        
        // Retrieve the scores, assuming patientScoreData and its 'data' property have 'mild', 'moderate', and 'severe' fields.
        let scores = [Double(patientScoreData?.data?.mild ?? 0), Double(patientScoreData?.data?.moderate ?? 0), Double(patientScoreData?.data?.severe ?? 0)]
        let colors = [UIColor(hex: "#6610F2"), UIColor(hex: "#FF865B"), UIColor(hex: "#34D89A")]

        // Filter out any scores that are 0
        let filteredDataPoints = scores.enumerated().filter { $0.element > 0 }
        let dataPoints = filteredDataPoints.map { $0.element }
        let filteredColors = filteredDataPoints.map { colors[$0.offset] }

        // Calculate the total value of dataPoints
        let total = dataPoints.reduce(0, +)

        // Set up the starting angle for the sectors
        var startAngle: CGFloat = -CGFloat.pi / 2

        for (index, value) in dataPoints.enumerated() {
            let angle = 2 * CGFloat.pi * CGFloat(value / total)
            let gap: CGFloat = 0.05 // Adjust the gap size as needed
            let outerPath = UIBezierPath(arcCenter: CGPoint(x: ringPieChartView.bounds.midX, y: ringPieChartView.bounds.midY), radius: ringPieChartView.bounds.width / 2, startAngle: startAngle + gap / 2, endAngle: startAngle + angle - gap / 2, clockwise: true)
            
            let innerRadius = ringPieChartView.bounds.width / 4 // Adjust the inner radius as needed
            let innerPath = UIBezierPath(arcCenter: CGPoint(x: ringPieChartView.bounds.midX, y: ringPieChartView.bounds.midY), radius: innerRadius, startAngle: startAngle + angle - gap / 2, endAngle: startAngle + gap / 2, clockwise: false)
            outerPath.append(innerPath)

            let sectorLayer = CAShapeLayer()
            sectorLayer.path = outerPath.cgPath
            sectorLayer.strokeColor = filteredColors[index].cgColor
            sectorLayer.fillColor = UIColor.clear.cgColor
            sectorLayer.lineWidth = ringPieChartView.bounds.width / 2 - innerRadius
            
            ringPieChartView.layer.addSublayer(sectorLayer)

            startAngle += angle
        }

        // Center Circle Configuration
        let centerCircleSize: CGFloat = 100 // Adjust the size of the center circle
        let centerCircle = UIView(frame: CGRect(x: (ringPieChartView.bounds.width - centerCircleSize) / 2, y: (ringPieChartView.bounds.height - centerCircleSize) / 2, width: centerCircleSize, height: centerCircleSize))
        centerCircle.backgroundColor = UIColor(hex: "#FFC0DE")
        centerCircle.layer.cornerRadius = centerCircleSize / 2
        ringPieChartView.addSubview(centerCircle)
    }

    @IBAction func start(_ sender: Any) {
        if let patientVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PatientPlanVC") as? PatientPlanVC {
            patientVC.username5 = username4
            self.navigationController?.pushViewController(patientVC, animated: true)
        } else {
            print("Error: Unable to instantiate PatientPlanVC")
        }
    }
    
    func patientScoreAPI() {
        let urlString = "\(ServiceAPI.baseURL)category.php"
        postPatientScores(urlString: urlString, username: ["name": username4]) { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.patientScoreData = data
                    self?.progressBar()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension PcosCategory {
    func postPatientScores(urlString: String, username: [String: String], completion: @escaping (Result<PaitentScoreModel, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let parameters = username.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
        request.httpBody = parameters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? NSError(domain: "DataError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unknown data error"])))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(PaitentScoreModel.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
