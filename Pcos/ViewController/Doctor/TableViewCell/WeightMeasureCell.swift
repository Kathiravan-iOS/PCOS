import UIKit

class WeightMeasureCell: UITableViewCell {
    @IBOutlet weak var chartView: UIView!
    var name: String = ""
    var lineChartView: LineChartView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupLineChartView()
        fetchData()
    }

    private func setupLineChartView() {
        lineChartView = LineChartView()
        chartView.addSubview(lineChartView)
        lineChartView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lineChartView.topAnchor.constraint(equalTo: chartView.topAnchor),
            lineChartView.trailingAnchor.constraint(equalTo: chartView.trailingAnchor),
            lineChartView.leadingAnchor.constraint(equalTo: chartView.leadingAnchor),
            lineChartView.bottomAnchor.constraint(equalTo: chartView.bottomAnchor)
        ])
    }

    private func fetchData() {
        guard let url = URL(string: "\(ServiceAPI.baseURL)weight_graph.php") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let parameters = "name=\(name)"
        request.httpBody = parameters.data(using: .utf8)

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                print("Network error:", error ?? "Unknown error")
                return
            }

            do {
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                   let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let dataArray = json["data"] as? [[String: Any]] {
                    let weightValues = dataArray.map { dataPoint -> CGFloat in
                        if let weightString = dataPoint["weight_value"] as? String, let weight = Double(weightString) {
                            return CGFloat(weight)
                        }
                        return 0.0
                    }
                    DispatchQueue.main.async {
                        self?.lineChartView.dataPoints = weightValues
                        self?.lineChartView.setNeedsDisplay()
                    }
                } else {
                    print("Error: HTTP Status Code: \((response as? HTTPURLResponse)?.statusCode ?? 0) or JSON data is incorrect")
                }
            } catch {
                print("Failed to decode JSON:", error)
            }
        }.resume()
    }




    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

class LineChartView: UIView {
    var dataPoints: [CGFloat] = []
    let circleFillColor = UIColor(hex: "FFC0CB")  // Light Pink
    let circleRadius: CGFloat = 5.0
    let lineColor = UIColor(hex: "FF69B4")       // Brighter Pink

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.white
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext(), !dataPoints.isEmpty else {
            return
        }

        context.setStrokeColor(lineColor.cgColor)
        context.setLineWidth(2.0)

        let maxValue = dataPoints.max() ?? 1
        let chartHeight = rect.size.height
        let chartWidth = rect.size.width
        let pointSpacing = chartWidth / CGFloat(max(dataPoints.count - 1, 1))

        var previousPoint: CGPoint?

        for (index, value) in dataPoints.enumerated() {
            let x = pointSpacing * CGFloat(index)
            let y = chartHeight - (value / maxValue * chartHeight)

            if let prev = previousPoint {
                context.move(to: prev)
                context.addLine(to: CGPoint(x: x, y: y))
                context.strokePath()
            }

            let circleRect = CGRect(x: x - circleRadius, y: y - circleRadius, width: circleRadius * 2, height: circleRadius * 2)
            context.setFillColor(circleFillColor.cgColor)
            context.fillEllipse(in: circleRect)

            previousPoint = CGPoint(x: x, y: y)
        }
    }
}

extension UIColor {
    convenience init(hex: String) {
        let hexSanitized = hex.replacingOccurrences(of: "#", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
        var rgb: UInt32 = 0
        Scanner(string: hexSanitized).scanHexInt32(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
