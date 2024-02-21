//
//  CaloriesCell.swift
//  Pcos
//
//  Created by Karthik Babu on 16/10/23.
//

import UIKit
//import Charts

class CaloriesCell: UITableViewCell {

    @IBOutlet weak var chartView: UIView!
//    var lineChartView: LineChartView!

    override func awakeFromNib() {
        super.awakeFromNib()
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Create a LineChartView and add it to the chartView
//               lineChartView = LineChartView()
//               lineChartView.frame = chartView.bounds
//               chartView.addSubview(lineChartView)
    }
    
}

//class LineChartView: UIView {
//
//    var dataPoints: [CGFloat] = [10, 15, 12, 18, 20] // Replace with your data points
//
//    override func draw(_ rect: CGRect) {
//        super.draw(rect)
//
//        guard let context = UIGraphicsGetCurrentContext() else {
//            return
//        }
//
//        context.setStrokeColor(UIColor.blue.cgColor)
//        context.setLineWidth(2.0)
//
//        let chartHeight = rect.size.height
//        let chartWidth = rect.size.width
//        let pointSpacing = chartWidth / CGFloat(dataPoints.count - 1)
//
//        for (index, value) in dataPoints.enumerated() {
//            let x = pointSpacing * CGFloat(index)
//            let y = chartHeight - (value / 20.0) * chartHeight // Scale your data accordingly
//
//            if index == 0 {
//                context.move(to: CGPoint(x: x, y: y))
//            } else {
//                context.addLine(to: CGPoint(x: x, y: y))
//            }
//            let circleRect = CGRect(x: x - 5, y: y - 5, width: 10, height: 10)
//            context.addEllipse(in: circleRect)
//        }
//        context.strokePath()
//    }
//}
