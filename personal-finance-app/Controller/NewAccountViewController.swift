//
//  NewAccountViewController.swift
//  personal-finance-app
//
//  Created by Achintha Ikiriwatte on 2020-12-26.
//

import UIKit

class NewAccountViewController: UIViewController {

    @IBOutlet weak var accountType: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        accountType.dataSource = self;
        accountType.delegate = self;
    }
}

extension NewAccountViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }
}

extension NewAccountViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "test"
    }
}
