//
//  TransactionsReportViewController.swift
//  personal-finance-app
//
//  Created by ra on 2021-01-15.
//

import UIKit
import CoreData
import Charts

class TransactionsReportViewController: UIViewController , ChartViewDelegate {

    var from : String?
    var pieChart = PieChartView()
    var entries =  [PieChartDataEntry]()
    
    var incomingArray = [SortArray]()

    override func viewDidLoad() {
        super.viewDidLoad()
        pieChart.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
      //  pieChart.frame =  CGRect(x: 0 , y: 0 ,width: self.view.frame.size.width , height: self.view.frame.size.height)
        
        pieChart.frame =  CGRect(x: 0 , y: 0 ,width: 300 , height: 300)
        
        pieChart.center = view.center
        view.addSubview(pieChart)
        
        for i in 0..<incomingArray.count {
            entries.append(PieChartDataEntry(value: Double(incomingArray[i].amount), label: incomingArray[i].account_name))
        }
        
        let set  = PieChartDataSet (entries: entries)
        
        set.colors =  ChartColorTemplates.joyful()
        
        let data = PieChartData(dataSet: set)
        
        if incomingArray.count != 0 {
            pieChart.data =  data
        }
        pieChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0 )
        incomingArray.removeAll()
    }
    
}


class SortArray {
    var account_name: String = ""
    var amount: Double = 0.0
}
