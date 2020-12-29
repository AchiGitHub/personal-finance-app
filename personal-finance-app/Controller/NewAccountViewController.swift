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
    
    var selectedAccountType: String = ""
    
    var pickerData: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        accountType.dataSource = self;
        accountType.delegate = self;
        
        pickerData = ["Cash", "Savings Account", "Credit Card Account", "Current Account"]
    }
    @IBAction func addNewAccount(_ sender: Any) {
        let account_name = accountName.text ?? "Name"
        let bank_account_number = accountNumber.text ?? "000"
        let initial_amount = Double(initialAmount.text!) ?? 0.0
        let credit_limit = Double(creditLimit.text!) ?? 0.0
        let accountDetails = AccountDetails(accountName: account_name, accountType: selectedAccountType, bankAccountNumber: bank_account_number, initialAmount: initial_amount, creditLimit: credit_limit)
        save(accountDetails: accountDetails)
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
        selectedAccountType = selectedValue
    }
}

extension NewAccountViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
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
    
    do {
        try managedContext.save()
        print("details saved successfully")
    } catch let error as NSError {
        print("Could not Save \(error), \(error.userInfo)")
    }
}

struct AccountDetails {
    var accountName: String = ""
    var accountType: String = ""
    var bankAccountNumber: String? = ""
    var initialAmount: Double = 0.0
    var creditLimit: Double? = 0.0
}
