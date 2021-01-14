//
//  AddDebtViewController.swift
//  personal-finance-app
//
//  Created by Achintha Ikiriwatte on 2021-01-14.
//

import UIKit
import CoreData
class AddDebtViewController: UIViewController {

    @IBOutlet weak var burrowedFrom: UITextField!
    @IBOutlet weak var burrowDescription: UITextField!
    @IBOutlet weak var burrowedDate: UIDatePicker!
    @IBOutlet weak var burrowedAmount: UITextField!
    
    var burrowedDateVar :  Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func burrowedDateChange(_ sender: UIDatePicker) {
        burrowedDateVar = sender.date
    }
    
    @IBAction func saveDebt(_ sender: UIBarButtonItem) {
        let name = burrowedFrom.text ?? ""
        let amount = Double(self.burrowedAmount.text!) ?? 0.0
        let description = burrowDescription.text ?? ""
        
        save(name, amount, description, burrowedDateVar)
    }
    
    func save(_ name: String, _ amount: Double, _ description: String, _ burrowedDate: Date){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
    
        let managedContext = appDelegate.persistentContainer.viewContext
        let newDebt = Debt(context: managedContext)
        
        newDebt.burrowed_from = name
        newDebt.burrow_description = description
        newDebt.burrow_date = burrowedDate
        newDebt.burrow_amount = amount
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not Save \(error)")
        }
    }
}
