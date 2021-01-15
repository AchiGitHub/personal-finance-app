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

    var from : String?
    var startDate: Date = Date()
    var endDate: Date = Date()

    var pieChart = PieChartView()
    var entries =  [PieChartDataEntry]()
    var sortedArray = [SortArray]()
    
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
            orderIncome()
        } catch let error as NSError {
            print("\(error)")
        }
    }
    
    func orderIncome() {
        for e in transactionsArray {
            if(e.date_added! > startDate && e.date_added! < endDate){
                var alreadyExist = false
                for s in sortedArray{
                    if s.account_name == e.account_name {
                        if(from == "income"){
                            if(e.amount > 0){
                                s.amount = s.amount + e.amount
                                alreadyExist = true
                                break
                            }
                        } else {
                            if(e.amount < 0){
                                s.amount += e.amount*(-1)
                                alreadyExist = true
                                break
                            }
                        }
                    }
                }
                if alreadyExist != true {
                    let newItem = SortArray()
                    if(from == "income"){
                        if(e.amount > 0){
                            newItem.account_name = e.account_name!
                            newItem.amount = e.amount
                            sortedArray.append(newItem)
                        }
                    } else {
                        if(e.amount < 0){
                            newItem.account_name = e.account_name!
                            newItem.amount = e.amount*(-1)
                            sortedArray.append(newItem)
                        }
                    }
                    
                }
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
      //  pieChart.frame =  CGRect(x: 0 , y: 0 ,width: self.view.frame.size.width , height: self.view.frame.size.height)
        
        pieChart.frame =  CGRect(x: 0 , y: 0 ,width: 300 , height: 300)
        
        pieChart.center = view.center
        view.addSubview(pieChart)
        
        for i in 0..<sortedArray.count {
            entries.append(PieChartDataEntry(value: Double(sortedArray[i].amount), label: sortedArray[i].account_name))
        }
        
        let set  = PieChartDataSet (entries: entries)
        
        set.colors =  ChartColorTemplates.joyful()
        
        let data = PieChartData(dataSet: set)
        
        if sortedArray.count != 0 {
            pieChart.data =  data
        }
//        pieChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0 )
        sortedArray.removeAll()
    }
    
}


class SortArray {
    var account_name: String = ""
    var amount: Double = 0.0
}
