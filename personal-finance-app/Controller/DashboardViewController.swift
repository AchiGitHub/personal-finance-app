//
//  DashboardViewController.swift
//  personal-finance-app
//
//  Created by Achintha Ikiriwatte on 2020-12-29.
//

import UIKit
import CoreData

class DashboardViewController: UIViewController {

    var accountsArray = [Account]();
    @IBOutlet weak var AccountsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        AccountsCollectionView.delegate = self
        AccountsCollectionView.dataSource = self
        
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
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<Account> = Account.fetchRequest()
        
        do {
            accountsArray = try managedContext.fetch(request)
//            for account in accountsArray {
//                print(account.account_name)
//            }
        } catch let error as NSError {
            print("\(error)")
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return accountsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = AccountsCollectionView.dequeueReusableCell(withReuseIdentifier: "AccountCell", for: indexPath) as! AccountCollectionViewCell
        cell.accountName.text = accountsArray[indexPath.row].account_name
        cell.accountType.text = accountsArray[indexPath.row].account_type
        cell.amount.text = String(accountsArray[indexPath.row].initial_amount)
        return cell
    }
    
    
}
