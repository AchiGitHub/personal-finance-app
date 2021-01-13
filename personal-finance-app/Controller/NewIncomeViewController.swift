//
//  NewIncomeViewController.swift
//  personal-finance-app
//
//  Created by ra on 1/13/21.
//

import UIKit
import CoreData

class NewIncomeViewController: UIViewController ,UIPickerViewDataSource, UIPickerViewDelegate  {
    
    

    @IBOutlet weak var accountName: UIPickerView!
    @IBOutlet weak var incomeTitle: UITextField!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var note: UITextField!
    @IBOutlet weak var dateAdded: UIDatePicker!
    
    var selectedAccountName: String = ""
    var selectedDate :  Date = Date()
    var pickerData: [String] = [String]()
    
    override func viewDidAppear(_ animated: Bool) {
        viewDidLoad()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accountName.dataSource = self;
        accountName.delegate = self;
        pickerData.removeAll()
        loadAccounts()
//        loadIncome() // testing
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return  1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
         return pickerData.count
    }
    

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let selectedValue = pickerData[row] as String 
        selectedAccountName = selectedValue
    }
    
    func loadAccounts (){
     
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<Account> = Account.fetchRequest()
        
        do {
            var accountsArray = [Account]();
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
                print(income.account_name)
            }
            
        } catch let error as NSError {
            print("\(error)")
        }
       
    }
    
    @IBAction func saveIncome(_ sender: Any) {
        // let account_name = selectedAccountName
         let title = incomeTitle.text ?? ""
         let noteText = note.text ?? ""
         let amountValue = Double(amount.text!) ?? 0.0
         
         save(title: title, date: selectedDate, note: noteText, amount: amountValue, accountName: selectedAccountName)

         tabBarController?.selectedIndex = 0
    }
    
    @IBAction func dateChange(_ sender: UIDatePicker) {
        selectedDate = sender.date
    }
    
    func save(title: String , date : Date , note : String , amount : Double , accountName :String){
        print("rwerwerw \(title)")
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
    
        let managedContext = appDelegate.persistentContainer.viewContext
        let newIncome = Income(context: managedContext)
        newIncome.account_name = accountName
        newIncome.amount =  amount
        newIncome.date_added = date
        newIncome.note = note
        newIncome.title = title
        
        
        do {
            try managedContext.save()
            print("details saved successfully")
        } catch let error as NSError {
            print("Could not Save \(error), \(error.userInfo)")
        }
    }
    
   
    	
}




