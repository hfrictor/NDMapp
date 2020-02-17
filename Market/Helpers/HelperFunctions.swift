//
//  HelperFunctions.swift
//  Market
//
//  Created by Hayden Frea on 21/07/2019.
//  Copyright © 2019 Hayden Frea. All rights reserved.
//

import Foundation


func convertToCurrency(_ number: Double) -> String {
    
    let currencyFormatter = NumberFormatter()
    currencyFormatter.usesGroupingSeparator = true
    currencyFormatter.numberStyle = .currency
    currencyFormatter.locale = Locale.current
    
    return currencyFormatter.string(from: NSNumber(value: number))!
}
