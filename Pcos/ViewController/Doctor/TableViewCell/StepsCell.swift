//
//  StepsCell.swift
//  Pcos
//
//  Created by Karthik Babu on 16/10/23.
//
import UIKit
import Charts

class StepsCell: UITableViewCell {
    var nn = 0

    @IBOutlet weak var barChart: BarChartView!
    @IBOutlet weak var stepsGraph : UILabel! {
        didSet {
            stepsGraph.text = "Steps  1000 Casual, 4000 Regular, 10000 Serious"
        }
    }
    var lineChartView: LineChartView!

    func configure(with data: [Int: Double]) {
        var dataEntries: [BarChartDataEntry] = []
        var labels: [String] = []
        let sortedData = data.sorted { $0.key < $1.key }
        for (day, steps) in sortedData {
            let dataEntry = BarChartDataEntry(x: Double(day - 1), y: steps)
            dataEntries.append(dataEntry)
            labels.append(String(day))
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Steps")
        let chartData = BarChartData(dataSet: chartDataSet)
        barChart.data = chartData
        
        
        let xAxis = barChart.xAxis
        xAxis.valueFormatter = IndexAxisValueFormatter(values: labels)
        xAxis.granularity = 1.0
        
        barChart.notifyDataSetChanged()
    }


}
