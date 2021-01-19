//
//  BudgetViewController.swift
//  personal-finance-app
//
//  Created by ra on 2021-01-14.
//

import UIKit
import CoreData

class BudgetViewController: UIViewController {

    @IBOutlet weak var budgetName: UITextField!
    @IBOutlet weak var startDate: UIDatePicker!
    @IBOutlet weak var endDate: UIDatePicker!
    @IBOutlet weak var amount: UITextField!
    
    var selectedStartDate :  Date = Date()
    var selectedEndDate :  Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func onChangeStartDate(_ sender: UIDatePicker) {
        selectedStartDate = sender.date
    }
    
    @IBAction func onChangeEndDate(_ sender: UIDatePicker) {
        selectedEndDate = sender.date
    }
    
    @IBAction func saveBudget(_ sender: UIBarButtonItem) {
        let name = budgetName.text ?? ""
        let amount = Double(self.amount.text!) ?? 0.0
        
        save(name, selectedStartDate, selectedEndDate, amount)
        
        navigationController?.popToRootViewController(animated: true)
        navigationController?.popViewController(animated: true)
    }
    
    func save(_ budgetName: String, _ startDate: Date, _ endDate: Date, _ amount: Double){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
    
        let managedContext = appDelegate.persistentContainer.viewContext
        let newBudget = Budget(context: managedContext)
        
        newBudget.amount = amount
        newBudget.title = budgetName
        newBudget.start_date = startDate
        newBudget.end_date = endDate
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not Save \(error)")
        }
    }
}
