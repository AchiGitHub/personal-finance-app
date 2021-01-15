//
//  IncomeTableViewController.swift
//  personal-finance-app
//
//  Created by Achintha Ikiriwatte on 2021-01-15.
//

import UIKit
import CoreData

class TransactionsTableViewCell: UITableViewCell {
    @IBOutlet weak var transactionTitle: UILabel!
    @IBOutlet weak var transactionAmount: UILabel!
    @IBOutlet weak var transactionAccount: UILabel!
    @IBOutlet weak var transactionDate: UILabel!
    
}

class IncomeTableViewController: UITableViewController {

    @IBOutlet var IncomeTableView: UITableView!
    
    let calendar = Calendar.current
    
    var totalIncome = [TotalPayments]()
    var transactionsArray = [Income]()
    
    override func viewDidLoad() {
        loadTransactions()
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }
    
    //MARK: Trggered before view appears
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadTransactions()
    }
    
    func loadTransactions(){
     
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<Income> = Income.fetchRequest()
            
        
        do {
            transactionsArray = try managedContext.fetch(request)
        } catch let error as NSError {
            print("\(error)")
        }
    }
    
    func deleteTransactions(_ index: Int) {

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        managedContext.delete(transactionsArray[index])
        
        do {
            try managedContext.save()
            print("deleted Successfully")
        } catch let error as NSError {
            print("Could not Save \(error), \(error.userInfo)")
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return transactionsArray.count

    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "incomeCell", for: indexPath) as! TransactionsTableViewCell

        // Configure the cell...
        cell.transactionTitle.text = transactionsArray[indexPath.row].title
        cell.transactionAmount.text = "Rs. \(transactionsArray[indexPath.row].amount)"
        cell.transactionDate.text = convertDateToString(transactionsArray[indexPath.row].date_added!)
        cell.transactionAccount.text = transactionsArray[indexPath.row].account_name

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            deleteTransactions(indexPath.row)
            transactionsArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
