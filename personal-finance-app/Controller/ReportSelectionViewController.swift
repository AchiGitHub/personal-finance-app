//
//  ReportSelectionViewController.swift
//  personal-finance-app
//
//  Created by Achintha Ikiriwatte on 2021-01-16.
//

import UIKit

class ReportSelectionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "incomeReport" {
            let destinationViewController = segue.destination as? IncomeFilterReportViewController
            
            destinationViewController?.segueName = "income"
        }
        
        if segue.identifier == "expenseReport" {
            let destinationViewController = segue.destination as? IncomeFilterReportViewController
            
            destinationViewController?.segueName = "expense"
        }
        
    }

}
