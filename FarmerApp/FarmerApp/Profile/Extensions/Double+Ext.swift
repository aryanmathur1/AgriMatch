//
//  Double+Ext.swift
//  Shopping
//
//

import Foundation

extension Formatter {
    
    static let usdCurrency: NumberFormatter = {
        var numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale.current
        numberFormatter.groupingSeparator = "," //Dollar
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 2
        return numberFormatter
    }()
    
    static let vnCurrency: NumberFormatter = {
        var numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale.current
        numberFormatter.groupingSeparator = "." //VND
        numberFormatter.numberStyle = .decimal
        return numberFormatter
    }()
}

extension Double {
    
    func formatter(_ fractionDigits: Int = 2) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "en_US")
        numberFormatter.numberStyle = .currency
        numberFormatter.maximumFractionDigits = fractionDigits
        
        return numberFormatter.string(from: NSNumber(value: self)) ?? "0"
    }
    
    func percent() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        numberFormatter.maximumFractionDigits = 2
        
        return numberFormatter.string(from: NSNumber(value: self)) ?? "0"
    }
    
    ///Dollar
    var formattedWithCurrency: String {
        guard let currency = Formatter.usdCurrency.string(for: self) else { return "" }
        return "$" + currency
    }
    
    ///VND
    var formattedWithDecimal: String {
        guard let currency = Formatter.vnCurrency.string(for: self) else { return "" }
        return currency + "đ"
    }
}
