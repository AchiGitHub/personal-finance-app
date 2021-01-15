//
//  DebtsViewController.swift
//  personal-finance-app
//
//  Created by Achintha Ikiriwatte on 2021-01-14.
//

import UIKit
import CoreData

class DebtsViewController: UIViewController {
    @IBOutlet weak var DebtCollectionView: UICollectionView!
    var debtArray = [Debt]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        DebtCollectionView.delegate = self
        DebtCollectionView.dataSource = self
    }
    
    // MARK: Triggered when tab view appears
    override func viewDidAppear(_ animated: Bool) {
        DebtCollectionView.reloadData()
    }
    
    //MARK: Trggered before view appears
    override func viewWillAppear(_ animated: Bool) {
        loadDebts()
    }
    

    func loadDebts (){
     
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<Debt> = Debt.fetchRequest()
            
        
        do {
            debtArray = try managedContext.fetch(request)
        } catch let error as NSError {
            print("\(error)")
        }
    }
}


extension DebtsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return debtArray.count
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 400 , height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = DebtCollectionView.dequeueReusableCell(withReuseIdentifier: "DebtCell", for: indexPath) as! DebtCollectionViewCell
        
        cell.burrowerName.text = debtArray[indexPath.row].burrowed_from
        cell.burrowDescription.text = debtArray[indexPath.row].burrow_description
        cell.burrowedDate.text = convertDateToString(debtArray[indexPath.row].burrow_date!)
        cell.burrowedAmount.text = String(debtArray[indexPath.row].burrow_amount)
        
        return cell
    }
    
    
}
