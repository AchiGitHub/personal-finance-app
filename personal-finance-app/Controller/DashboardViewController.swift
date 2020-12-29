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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<Account> = Account.fetchRequest()
        
        do {
            accountsArray = try managedContext.fetch(request)
            for account in accountsArray {
                print(account.account_name)
            }
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
