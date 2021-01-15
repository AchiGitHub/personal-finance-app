//
//  DashboardViewController.swift
//  personal-finance-app
//
//  Created by Achintha Ikiriwatte on 2020-12-29.
//

import UIKit
import CoreData

class DashboardViewController: UIViewController {

    var accountsArray = [Account]()
    var expensesArray = [Income]()
    
    @IBOutlet weak var AccountsCollectionView: UICollectionView!
    @IBOutlet weak var balanceLbl: UILabel!
    @IBOutlet weak var totalBalanceLbl: UILabel!
    @IBOutlet weak var RecentTransactions: UICollectionView!
    @IBOutlet weak var AccountsRootCollectionView: UIView!
    @IBOutlet weak var RecentTransactionsRootView: UIView!
    @IBOutlet weak var NoRecentTransactionsUI: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        AccountsCollectionView.delegate = self
        AccountsCollectionView.dataSource = self
        
        RecentTransactions.delegate = self
        RecentTransactions.dataSource = self
        
        
        
    }
    
    // MARK: Triggered when tab view appears
    override func viewDidAppear(_ animated: Bool) {
        AccountsCollectionView.reloadData()
        RecentTransactions.reloadData()
        
        hideAccountsViewIfEmpty()
        hideTransactionsViewIfEmpty()
    }
    
    //MARK: Trggered before view appears
    override func viewWillAppear(_ animated: Bool) {
        
        AccountsCollectionView.delegate = self
        AccountsCollectionView.dataSource = self
        
        super.viewWillAppear(animated)
        
        loadTransactions()
        loadAccounts()
    }
    
    func loadAccounts(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<Account> = Account.fetchRequest()
        
        do {
            accountsArray = try managedContext.fetch(request)
            var totalBalance: Double = 0.0
            for account in accountsArray {
                totalBalance += account.current_amount
            }
            totalBalanceLbl.text = "Rs. \(totalBalance)"
        } catch let error as NSError {
            print("\(error)")
        }
    }
    
    func loadTransactions(){
     
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<Income> = Income.fetchRequest()
            
        
        do {
            expensesArray = try managedContext.fetch(request).reversed()
        } catch let error as NSError {
            print("\(error)")
        }
    }
    
    func hideAccountsViewIfEmpty(){
        if(accountsArray.count == 0){
            AccountsRootCollectionView.isHidden = true
        } else {
            AccountsRootCollectionView.isHidden = false
        }
    }
    
    func hideTransactionsViewIfEmpty(){
        if(expensesArray.count == 0){
            RecentTransactionsRootView.isHidden = true
        } else {
            RecentTransactionsRootView.isHidden = false
            NoRecentTransactionsUI.isHidden = true
        }
    }

}

extension DashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if(collectionView == self.RecentTransactions){
            return CGSize(width: collectionView.frame.width - 20 , height: 150)
        }
        return CGSize(width: collectionView.frame.width , height: 170)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == self.AccountsCollectionView){
            return accountsArray.count
        }
        return expensesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView == self.AccountsCollectionView){
            let cell = AccountsCollectionView.dequeueReusableCell(withReuseIdentifier: "AccountCell", for: indexPath) as! AccountCollectionViewCell
            cell.accountName.text = accountsArray[indexPath.row].account_name
            cell.accountType.text = accountsArray[indexPath.row].account_type
            cell.initialAmount.text = "Initial Rs. \(accountsArray[indexPath.row].initial_amount)"
            cell.amount.text = "Rs. \(accountsArray[indexPath.row].current_amount)"
            return cell
        } else {
            let cell = RecentTransactions.dequeueReusableCell(withReuseIdentifier: "TransactionCell", for: indexPath) as! RecentTransactionsCollectionViewCell
            cell.transactionTypeName.text = expensesArray[indexPath.row].title
            cell.transactionAmount.text = "Rs. \(expensesArray[indexPath.row].amount)"
            return cell
        }
    }
}
