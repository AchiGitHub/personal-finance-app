//
//  IncomeFilterReportViewController.swift
//  personal-finance-app
//
//  Created by Achintha Ikiriwatte on 2021-01-16.
//

import UIKit

class IncomeFilterReportViewController: UIViewController {

    @IBOutlet weak var reportStartDate: UIDatePicker!
    @IBOutlet weak var reportEndDate: UIDatePicker!
    
    var selectedStartDate: Date?
    var selectedEndDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func startDateOnChange(_ sender: UIDatePicker) {
        selectedStartDate = sender.date
    }
    
    @IBAction func endDateOnChange(_ sender: UIDatePicker) {
        selectedEndDate = sender.date
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "incomeSegue" {
            let destinationViewController = segue.destination as! TransactionsReportViewController
            destinationViewController.from = "income"
            destinationViewController.startDate = selectedStartDate ?? Date()
            destinationViewController.endDate = selectedEndDate ?? Date()
        }
        
        if segue.identifier == "expenseSegue" {
            let destinationViewController = segue.destination as! TransactionsReportViewController
            destinationViewController.from = "expense"
            destinationViewController.startDate = selectedStartDate ?? Date()
            destinationViewController.endDate = selectedEndDate ?? Date()
        }
    }

}
