//
//  IncomeFilterReportViewController.swift
//  personal-finance-app
//
//  Created by Achintha Ikiriwatte on 2021-01-16.
//

import UIKit
import CoreData

class IncomeFilterReportViewController: UIViewController {
    
    
    @IBOutlet weak var tableData: UITableView!
    
    var selectedStartDate: Date = Date()
    var selectedEndDate: Date = Date()
    
    var segueName: String?
    
    var transactionsArray = [Income]()
    var sortedArray = [SortArray]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableData.delegate = self
        self.tableData.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    //MARK: Trggered before view appears
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadTransactions()
    }
    
    @IBAction func startDateOnChange(_ sender: UIDatePicker) {
        selectedStartDate = sender.date
    }
    
    @IBAction func endDateOnChange(_ sender: UIDatePicker) {
        selectedEndDate = sender.date
    }
    
    @IBAction func calculateOnClick(_ sender: UIButton) {
        orderIncome()
        tableData.reloadData()
    }
    
    
    func loadTransactions(){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<Income> = Income.fetchRequest()
        
        do {
            transactionsArray = try managedContext.fetch(request)
            orderIncome()
        } catch let error as NSError {
            print("\(error)")
        }
    }
    
    func orderIncome() {
        for e in transactionsArray {
            if(e.date_added! > selectedStartDate && e.date_added! < selectedEndDate){
                var alreadyExist = false
                for s in sortedArray{
                    if s.account_name == e.account_name {
                        if(segueName == "income"){
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
                    if(segueName == "income"){
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
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "transactionSegue" {
            let destinationViewController = segue.destination as! TransactionsReportViewController
            destinationViewController.incomingArray = sortedArray
        }
    }
}


extension IncomeFilterReportViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sortedArray.count

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "transactionCell", for: indexPath) as! TransactionReportTableViewCell
        // Configure the cell...
        cell.transactionTitle.text = sortedArray[indexPath.row].account_name
        cell.transactionAmount.text = "Rs. \(sortedArray[indexPath.row].amount)"

        return cell
    }


}
