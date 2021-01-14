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
