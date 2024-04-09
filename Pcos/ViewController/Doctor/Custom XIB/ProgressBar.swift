import UIKit

struct ApiResponse: Codable {
    let success: Bool
    let message: String
    let percentages: Percentages
}

struct Percentages: Codable {
    let calories_percentage: CGFloat
    let steps_percentage: CGFloat
    let feedback_percentage: CGFloat
}

class ProgressBar: UITableViewCell {

    @IBOutlet weak var carbView: UIView!
    @IBOutlet weak var proView: UIView!
    @IBOutlet weak var fatView: UIView!

    private var fatProgressBar: PercentageProgressBarView?
    private var sleepProgressBar: PercentageProgressBarView?
    private var exerciseProgressBar: PercentageProgressBarView?

    var name24: String = "" {
        didSet {
            loadData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupProgressBarViews()
    }

    func loadData() {
        let urlString = "ServiceAPI.baseURpercentage.php"
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let parameters: [String: Any] = ["name": name24]
        request.httpBody = parameters.percentEncoded()

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, error == nil else { return }
            do {
                let apiResponse = try JSONDecoder().decode(ApiResponse.self, from: data)
                DispatchQueue.main.async {
                    self?.updateProgressBar(percentages: apiResponse.percentages)
                }
            } catch {
                print(error)
            }
        }

        task.resume()
    }

    private func setupProgressBarViews() {
        fatProgressBar = createAndAddProgressBar(to: fatView, colorHex: "#FEC635", defaultPercentage: 0, label: "Fat")
        sleepProgressBar = createAndAddProgressBar(to: proView, colorHex: "#3585FE", defaultPercentage: 0, label: "Sleep")
        exerciseProgressBar = createAndAddProgressBar(to: carbView, colorHex: "#8076F5", defaultPercentage: 0, label: "Exercise")
    }

    private func updateProgressBar(percentages: Percentages) {
        fatProgressBar?.setPercentage(percentages.calories_percentage, customText: "Fat")
        sleepProgressBar?.setPercentage(percentages.steps_percentage, customText: "Sleep")
        exerciseProgressBar?.setPercentage(percentages.feedback_percentage, customText: "Exercise")
    }

    private func createAndAddProgressBar(to view: UIView, colorHex: String, defaultPercentage: CGFloat, label: String) -> PercentageProgressBarView {
        let progressBar = PercentageProgressBarView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        progressBar.progressBarColor = UIColor(hex: colorHex) 
        addCenteredView(to: view, viewToAdd: progressBar, width: 80, height: 80)
        progressBar.setPercentage(defaultPercentage, customText: label)
        return progressBar
    }

    func addCenteredView(to parentView: UIView, viewToAdd: UIView, width: CGFloat?, height: CGFloat?) {
        viewToAdd.translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(viewToAdd)

        NSLayoutConstraint.activate([
            viewToAdd.centerXAnchor.constraint(equalTo: parentView.centerXAnchor),
            viewToAdd.centerYAnchor.constraint(equalTo: parentView.centerYAnchor),
            viewToAdd.widthAnchor.constraint(equalToConstant: width ?? viewToAdd.frame.width),
            viewToAdd.heightAnchor.constraint(equalToConstant: height ?? viewToAdd.frame.height)
        ])
    }
}

class PercentageProgressBarView: UIView {
    
    private let progressLayer = CAShapeLayer()
    private let percentageLabel = UILabel()
    private let customLabel = UILabel()
    
    var progressBarColor: UIColor = .blue {
        didSet {
            progressLayer.strokeColor = progressBarColor.cgColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .clear
        
        let lineWidth: CGFloat = 10
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2, y: frame.size.height / 2),
                                        radius: (min(frame.size.width, frame.size.height) - lineWidth) / 2,
                                        startAngle: -CGFloat.pi / 2,
                                        endAngle: 2 * CGFloat.pi - CGFloat.pi / 2,
                                        clockwise: true)
        progressLayer.path = circularPath.cgPath
        progressLayer.strokeColor = progressBarColor.cgColor
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = lineWidth
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = 0
        layer.addSublayer(progressLayer)
        
        percentageLabel.textAlignment = .center
        percentageLabel.font = UIFont.boldSystemFont(ofSize: 18)
        percentageLabel.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        addSubview(percentageLabel)
        
        customLabel.textAlignment = .center
        customLabel.font = UIFont.systemFont(ofSize: 12)
        customLabel.frame = CGRect(x: 0, y: frame.size.height + 5, width: frame.size.width, height: 20)
        addSubview(customLabel)
    }
    
    func setPercentage(_ percentage: CGFloat, customText: String) {
        DispatchQueue.main.async {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.toValue = percentage / 100
            animation.duration = 1
            animation.fillMode = .forwards
            animation.isRemovedOnCompletion = false
            self.progressLayer.add(animation, forKey: "progressAnim")
            
            self.percentageLabel.text = "\(Int(percentage))%"
            self.customLabel.text = customText
        }
    }
}

extension Dictionary {
    func percentEncoded1() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

//extension UIColor {
//    convenience init?(hex: String) {
//        let r, g, b, a: CGFloat
//
//        if hex.hasPrefix("#") {
//            let start = hex.index(hex.startIndex, offsetBy: 1)
//            let hexColor = String(hex[start...])
//
//            if hexColor.count == 8 {
//                let scanner = Scanner(string: hexColor)
//                var hexNumber: UInt64 = 0
//
//                if scanner.scanHexInt64(&hexNumber) {
//                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
//                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
//                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
//                    a = CGFloat(hexNumber & 0x000000ff) / 255
//
//                    self.init(red: r, green: g, blue: b, alpha: a)
//                    return
//                }
//            }
//        }
//
//        return nil
//    }
//}
