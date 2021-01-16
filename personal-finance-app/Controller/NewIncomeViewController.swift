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
    
    var accountsArray = [Account]();
    
    override func viewDidAppear(_ animated: Bool) {
        viewDidLoad()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accountName.dataSource = self;
        accountName.delegate = self;
        pickerData.removeAll()
        loadAccounts()
        let row = accountName.selectedRow(inComponent: 0)
        pickerView(accountName, didSelectRow: row, inComponent: 0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        
        view.addGestureRecognizer(tap)
        
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
            accountsArray = try managedContext.fetch(request)
            for account in accountsArray {
                pickerData.append(account.account_name ?? "")
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

        navigationController?.popToRootViewController(animated: true)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func dateChange(_ sender: UIDatePicker) {
        selectedDate = sender.date
    }
    
    func save(title: String , date : Date , note : String , amount : Double , accountName :String){
        
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
            updateAccounts()
        } catch let error as NSError {
            print("Could not Save \(error), \(error.userInfo)")
        }
    }
    
    func updateAccounts(){
        
        let incomeValue: Double? = Double(amount.text!)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        for account in accountsArray {
            if(account.account_name == selectedAccountName){
                account.current_amount += incomeValue ?? 0
                return
            }
        }
        
        do {
            try managedContext.save()
            print("details saved successfully")
        } catch let error as NSError {
            print("Could not Save \(error), \(error.userInfo)")
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    	
}




