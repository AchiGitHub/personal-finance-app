//
//  NewAccountViewController.swift
//  personal-finance-app
//
//  Created by Achintha Ikiriwatte on 2020-12-26.
//

import UIKit
import CoreData

class NewAccountViewController: UIViewController {

    @IBOutlet weak var accountName: UITextField!
    @IBOutlet weak var accountType: UIPickerView!
    @IBOutlet weak var accountNumber: UITextField!
    @IBOutlet weak var initialAmount: UITextField!
    @IBOutlet weak var creditLimit: UITextField!
    @IBOutlet weak var bankAccountNumberLbl: UILabel!
    @IBOutlet weak var creditLimitLbl: UILabel!
    @IBOutlet weak var creditCardCyleEndDateLbl: UILabel!
    @IBOutlet weak var creditCardCycleEndDate: UIDatePicker!
    
    var selectedAccountType: String = ""
    
    var selectedDate: Date = Date()
    
    var pickerData: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        accountType.dataSource = self;
        accountType.delegate = self;
        accountNumber.isHidden = true;
        creditLimit.isHidden = true;
        bankAccountNumberLbl.isHidden = true;
        creditLimitLbl.isHidden = true;
        
        pickerData = ["Cash", "Savings Account", "Credit Card Account", "Current Account"]
        let row = accountType.selectedRow(inComponent: 0)
        pickerView(accountType, didSelectRow: row, inComponent: 0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func saveAccount(_ sender: Any) {
        let account_name = accountName.text ?? "Name"
        let bank_account_number = accountNumber.text ?? "000"
        let initial_amount = Double(initialAmount.text!) ?? 0.0
        let credit_limit = Double(creditLimit.text!) ?? 0.0
        let accountDetails = AccountDetails(accountName: account_name, accountType: selectedAccountType, bankAccountNumber: bank_account_number, initialAmount: initial_amount, creditLimit: credit_limit, cycleDate: selectedDate)
        save(accountDetails: accountDetails)
        navigationController?.popToRootViewController(animated: true)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func creditCycleEndDate(_ sender: UIDatePicker) {
        selectedDate = sender.date
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

func save(accountDetails: AccountDetails){
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return
    }
    
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let newAccount = Account(context: managedContext)
    newAccount.account_name = accountDetails.accountName
    newAccount.account_type = accountDetails.accountType
    newAccount.initial_amount = accountDetails.initialAmount
    newAccount.bank_account_number = accountDetails.bankAccountNumber
    newAccount.credit_limit = accountDetails.creditLimit!
    newAccount.current_amount = accountDetails.initialAmount
    newAccount.credit_cycle = accountDetails.cycleDate
    
    do {
        try managedContext.save()
        print("details saved successfully")
    } catch let error as NSError {
        print("Could not Save \(error), \(error.userInfo)")
    }
}

extension NewAccountViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedValue = pickerData[row] as String
        
        if(selectedValue == "Cash"){
            accountNumber.isHidden = true
            creditLimit.isHidden = true
            bankAccountNumberLbl.isHidden = true
            creditLimitLbl.isHidden = true
            creditCardCyleEndDateLbl.isHidden = true
            creditCardCycleEndDate.isHidden = true
        } else if(selectedValue == "Savings Account") {
            accountNumber.isHidden = false
            creditLimit.isHidden = true
            bankAccountNumberLbl.isHidden = false
            creditLimitLbl.isHidden = true
            creditCardCyleEndDateLbl.isHidden = true
            creditCardCycleEndDate.isHidden = true
        } else {
            accountNumber.isHidden = false
            creditLimit.isHidden = false
            bankAccountNumberLbl.isHidden = false
            creditLimitLbl.isHidden = false
            creditCardCyleEndDateLbl.isHidden = false
            creditCardCycleEndDate.isHidden = false
        }
        selectedAccountType = selectedValue
    }
}

extension NewAccountViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
}

struct AccountDetails {
    var accountName: String = ""
    var accountType: String = ""
    var bankAccountNumber: String? = ""
    var initialAmount: Double = 0.0
    var creditLimit: Double? = 0.0
    var cycleDate: Date?
}
