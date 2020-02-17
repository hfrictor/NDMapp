//
//  HelperFunctions.swift
//  Market
//
//  Created by David Kababyan on 21/07/2019.
//  Copyright © 2019 David Kababyan. All rights reserved.
//

import Foundation


func convertToCurrency(_ number: Double) -> String {
    
    let currencyFormatter = NumberFormatter()
    currencyFormatter.usesGroupingSeparator = true
    currencyFormatter.numberStyle = .currency
    currencyFormatter.locale = Locale.current
    
    return currencyFormatter.string(from: NSNumber(value: number))!
}
