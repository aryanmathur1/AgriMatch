//
//  UIView+Ext.swift
//  Shopping
//
//

import UIKit

internal extension UIView {
    
    var tabController: UITabBarController? {
        if let controller = sequence(
            first: self,
            next: { $0.next }
        )
            .first(where: { $0 is UITabBarController }) as? UITabBarController
        {
            return controller
        }
        
        return nil
    }
}
