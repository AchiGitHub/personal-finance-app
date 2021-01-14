//
//  ExpensesViewController.swift
//  personal-finance-app
//
//  Created by Achintha Ikiriwatte on 2021-01-13.
//

import UIKit
import CoreData

class ExpensesViewController: UIViewController {

    @IBOutlet weak var expenseName: UITextField!
    @IBOutlet weak var paymentAccount: UIPickerView!
    @IBOutlet weak var expenseAmount: UITextField!
    @IBOutlet weak var note: UITextField!
    @IBOutlet weak var expenseDate: UIDatePicker!
    
    
    var selectedAccountType: String = ""
    var selectedDate :  Date = Date()
    var pickerData: [String] = [String]()
    
    var accountsArray = [Account]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        paymentAccount.dataSource = self;
        paymentAccount.delegate = self;
        loadAccounts()
        loadIncome()
        // Do any additional setup after loading the view.
    }
    

    func loadAccounts (){
     
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<Account> = Account.fetchRequest()
        
        do {
            accountsArray = try managedContext.fetch(request)
            for account in accountsArray {
                pickerData.append(account.account_name ?? "")
            }
            
        } catch let error as NSError {
            print("\(error)")
        }
       
    }
    
    func loadIncome (){
     
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<Income> = Income.fetchRequest()
            
        
        do {
            var incomeArray = [Income]();
            incomeArray = try managedContext.fetch(request)
            
            for income in incomeArray {
                print(income.amount)
            }
            
        } catch let error as NSError {
            print("\(error)")
        }
       
    }
    
    @IBAction func dateChange(_ sender: UIDatePicker) {
        selectedDate = sender.date
    }
    
    @IBAction func saveExpense(_ sender: Any) {
        // let account_name = selectedAccountName
         let title = expenseName.text ?? ""
         let noteText = note.text ?? ""
         let amountValue = Double(expenseAmount.text!) ?? 0.0
         
         save(title: title, date: selectedDate, note: noteText, amount: amountValue, accountName: selectedAccountType)

//         tabBarController?.selectedIndex = 0
    }
    
    
    func save(title: String , date : Date , note : String , amount : Double , accountName :String){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
    
        let managedContext = appDelegate.persistentContainer.viewContext
        let newIncome = Income(context: managedContext)
        newIncome.account_name = accountName
        newIncome.amount =  amount*(-1)
        newIncome.date_added = date
        newIncome.note = note
        newIncome.title = title
        
        
        do {
            try managedContext.save()
            updateAccounts()
        } catch let error as NSError {
            print("Could not Save \(error)")
        }
    }
    
    func updateAccounts(){
        
        let expenseValue: Double? = Double(expenseAmount.text!)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        for account in accountsArray {
            if(account.account_name == selectedAccountType){
                account.current_amount -= expenseValue ?? 0
                return
            }
        }
        
        do {
            try managedContext.save()
            print("details saved successfully")
        } catch let error as NSError {
            print("Could not Save \(error)")
        }
    }
    

}



extension ExpensesViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedValue = pickerData[row] as String
        selectedAccountType = selectedValue
    }
}

extension ExpensesViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
}
