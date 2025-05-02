//
//  String+Ext.swift
//  Shopping
//
//

import SwiftUI

extension String {
    
    ///Tính CGRect của một String
    func estimatedTextRect(width: CGFloat = CGFloat.greatestFiniteMagnitude, font: UIFont) -> CGRect {
        let height = CGFloat.greatestFiniteMagnitude
        let size = CGSize(width: width, height: height)
        let options: NSStringDrawingOptions = [
            .usesLineFragmentOrigin//.union(.usesFontLeading)
        ]
        let attributes: [NSAttributedString.Key: Any] = [
            .font : font
        ]
        
        return NSString(string: self).boundingRect(
            with: size,
            options: options,
            attributes: attributes,
            context: nil
        )
    }
}
