//
//  utilities.swift
//  personal-finance-app
//
//  Created by Achintha Ikiriwatte on 2021-01-14.
//

import Foundation

func convertDateToString(_ incomingDate: Date) -> String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "YY/MM/dd"
    
    return dateFormatter.string(from: incomingDate)
}


class MonthlyPayment {
    var name = ""
    var value = ""
    
    init(name: String, value:String) {
        self.name = name
        self.value = value
    }
}

class TotalPayments {
    var period: String?
    var payments: [MonthlyPayment]?
    
    init(period: String, payments: [MonthlyPayment]) {
        self.period = period
        self.payments = payments
    }
}

