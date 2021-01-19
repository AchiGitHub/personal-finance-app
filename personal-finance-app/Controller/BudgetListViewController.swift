//
//  BudgetListViewController.swift
//  personal-finance-app
//
//  Created by ra on 2021-01-14.
//

import UIKit
import CoreData

class BudgetListViewController: UIViewController {

    @IBOutlet weak var BudgetCollectionView: UICollectionView!
    var totalExpensesInRange: Double = 0.0
    var expensesArray = [Income]()
    var budgetArray = [Budget]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        BudgetCollectionView.delegate = self
        BudgetCollectionView.dataSource = self
    }
    
    // MARK: Triggered when tab view appears
    override func viewDidAppear(_ animated: Bool) {
        BudgetCollectionView.reloadData()
    }
    
    //MARK: Trggered before view appears
    override func viewWillAppear(_ animated: Bool) {
        loadBudget()
        loadExpenses()
    }
    
    func loadBudget (){
     
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<Budget> = Budget.fetchRequest()
            
        
        do {
            budgetArray = try managedContext.fetch(request)
        } catch let error as NSError {
            print("\(error)")
        }
    }
    
    func loadExpenses (){
     
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


extension BudgetListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return budgetArray.count
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: collectionView.frame.width - 20 , height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = BudgetCollectionView.dequeueReusableCell(withReuseIdentifier: "BudgetListCell", for: indexPath) as! BudgetCollectionViewCell
        
        //variable to store total
        var totalExpenses: Double = -0.0;
        for expense in expensesArray {
            if(budgetArray[indexPath.row].start_date! < expense.date_added! && budgetArray[indexPath.row].end_date! > expense.date_added! ){
                if(expense.amount < 0){
                    totalExpenses += expense.amount
                }
            }
        }
        cell.budgetName.text = budgetArray[indexPath.row].title
        cell.totalBudget.text = "Rs. \(budgetArray[indexPath.row].amount)"
        cell.currentExpenses.text = "Rs. \(totalExpenses*(-1))"
        cell.budgetProgressBar.progress = Float((totalExpenses*(-1)/budgetArray[indexPath.row].amount))
        return cell
    }
    
    
}
