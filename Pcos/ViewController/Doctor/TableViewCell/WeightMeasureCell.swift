//
//  WeightMeasureCell.swift
//  Pcos
//
//  Created by Karthik Babu on 16/10/23.
//

import UIKit

class WeightMeasureCell: UITableViewCell {
    var name : String = ""
    @IBOutlet weak var chartView: UIView!
    var lineChartView: LineChartView!
    override func awakeFromNib() {
        super.awakeFromNib()
        lineChartView = LineChartView()
           chartView.addSubview(lineChartView)
           // Set Auto Layout constraints for lineChartView
           lineChartView.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               lineChartView.topAnchor.constraint(equalTo: chartView.topAnchor),
               lineChartView.trailingAnchor.constraint(equalTo: chartView.trailingAnchor),
               lineChartView.leadingAnchor.constraint(equalTo: chartView.leadingAnchor),
               lineChartView.bottomAnchor.constraint(equalTo: chartView.bottomAnchor)
           ])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

 
    }
    
}
class LineChartView: UIView {
    var dataPoints: [CGFloat] = [10, 15, 12, 18, 20] // Replace with your data points

    // Customizable properties
    let circleFillColor = UIColor(hex: "A0DBFD")
    let circleRadius: CGFloat = 5.0
    let lineColor = UIColor(hex: "7876F5")

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white // Set the background color to white
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.white // Set the background color to white
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }

        context.setStrokeColor(lineColor.cgColor) // Set line color
        context.setLineWidth(2.0)

        let chartHeight = rect.size.height
        let chartWidth = rect.size.width
        let pointSpacing = chartWidth / CGFloat(dataPoints.count - 1)

        var previousPoint: CGPoint?

        for (index, value) in dataPoints.enumerated() {
            let x = pointSpacing * CGFloat(index)
            let y = chartHeight - (value / 20.0) * chartHeight // Scale your data accordingly

            if let previousPoint = previousPoint {
                // Draw a line connecting the current and previous points
                context.move(to: previousPoint)
                context.addLine(to: CGPoint(x: x, y: y))
                context.strokePath()

                // Draw a filled circle at the current point
                let circleRect = CGRect(x: x - circleRadius, y: y - circleRadius, width: circleRadius * 2, height: circleRadius * 2)
                context.setFillColor(circleFillColor.cgColor)
                context.fillEllipse(in: circleRect)
            }

            previousPoint = CGPoint(x: x, y: y)
        }
    }
}

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex
        hexSanitized = hexSanitized.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
