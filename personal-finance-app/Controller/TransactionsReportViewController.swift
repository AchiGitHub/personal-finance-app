//
//  TransactionsReportViewController.swift
//  personal-finance-app
//
//  Created by Achintha Ikiriwatte on 2021-01-15.
//

import UIKit
import CoreData
import Charts

class TransactionsReportViewController: UIViewController , ChartViewDelegate {
    

    var pieChart = PieChartView()
    var entries =  [PieChartDataEntry]()
    
    var totalIncome: Double = 0.0
    var totalExpense: Double = 0.0
    
    var transactionsArray = [Income]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pieChart.delegate = self
        // Do any additional setup after loading the view.
    }
    
    //MARK: Trggered before view appears
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadTransactions()
    }
    
    func loadTransactions(){
     
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<Income> = Income.fetchRequest()
            
        do {
            transactionsArray = try managedContext.fetch(request)
            for record in transactionsArray {
                if(record.amount > 0){
                    totalIncome += record.amount
                } else {
                    totalExpense += record.amount
                }
            }
        } catch let error as NSError {
            print("\(error)")
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
      //  pieChart.frame =  CGRect(x: 0 , y: 0 ,width: self.view.frame.size.width , height: self.view.frame.size.height)
        
        pieChart.frame =  CGRect(x: 0 , y: 0 ,width: 300 , height: 300)
        
        pieChart.center = view.center
        view.addSubview(pieChart)
        
        entries.append(PieChartDataEntry(value: Double(totalIncome), label: "Total Income"))
        entries.append(PieChartDataEntry(value: Double(totalExpense*(-1)), label: "Total Expense"))
        
        let set  = PieChartDataSet (entries: entries)
        
        set.colors =  ChartColorTemplates.joyful()
        
        let data = PieChartData(dataSet: set)
        
        pieChart.data =  data
        pieChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0 )
        
    }
    
}
