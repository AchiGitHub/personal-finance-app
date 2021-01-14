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
    var totalBalance: Double = 0.0
    
    @IBOutlet weak var AccountsCollectionView: UICollectionView!
    @IBOutlet weak var balanceLbl: UILabel!
    @IBOutlet weak var totalBalanceLbl: UILabel!
    @IBOutlet weak var RecentTransactions: UICollectionView!
    
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
    }
    
    //MARK: Trggered before view appears
    override func viewWillAppear(_ animated: Bool) {
        
        AccountsCollectionView.delegate = self
        AccountsCollectionView.dataSource = self
        
        super.viewWillAppear(animated)
        
        loadTransactions()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<Account> = Account.fetchRequest()
        
        do {
            accountsArray = try managedContext.fetch(request)
            for account in accountsArray {
                totalBalance += account.current_amount
            }
            totalBalanceLbl.text = String(totalBalance)
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
            expensesArray = try managedContext.fetch(request)
        } catch let error as NSError {
            print("\(error)")
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
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView == self.AccountsCollectionView){
            let cell = AccountsCollectionView.dequeueReusableCell(withReuseIdentifier: "AccountCell", for: indexPath) as! AccountCollectionViewCell
            cell.accountName.text = accountsArray[indexPath.row].account_name
            cell.accountType.text = accountsArray[indexPath.row].account_type
            cell.initialAmount.text = String(accountsArray[indexPath.row].initial_amount)
            cell.amount.text = String(accountsArray[indexPath.row].current_amount)
            return cell
        } else {
            let cell = RecentTransactions.dequeueReusableCell(withReuseIdentifier: "TransactionCell", for: indexPath) as! RecentTransactionsCollectionViewCell
            cell.transactionTypeName.text = expensesArray[indexPath.row].title
            cell.transactionAmount.text = String(expensesArray[indexPath.row].amount)
            return cell
        }
    }
    
    
}
