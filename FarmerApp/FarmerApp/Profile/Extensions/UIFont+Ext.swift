//
//  UIFont+Ext.swift
//  Shopping
//
//

import SwiftUI
import UIKit

struct CustomFontName {
    static let montBold = "Montserrat-Bold"
    static let montExtraBold = "Montserrat-ExtraBold"
    static let montLight = "Montserrat-Light"
    static let montMedium = "Montserrat-Medium"
    static let montMediumItalic = "Montserrat-MediumItalic"
    static let montRegular = "Montserrat-Regular"
    static let montSemiBold = "Montserrat-SemiBold"
}

extension UIFont {
    
    static func montBold(size: CGFloat) -> UIFont {
        UIFont(name: CustomFontName.montBold, size: size) ?? UIFont.systemFont(ofSize: size, weight: .bold)
    }
    
    static func montExtraBold(size: CGFloat) -> UIFont {
        UIFont(name: CustomFontName.montExtraBold, size: size) ?? UIFont.systemFont(ofSize: size, weight: .heavy)
    }

    static func montLight(size: CGFloat) -> UIFont {
        UIFont(name: CustomFontName.montLight, size: size) ?? UIFont.systemFont(ofSize: size, weight: .light)
    }

    static func montMedium(size: CGFloat) -> UIFont {
        UIFont(name: CustomFontName.montMedium, size: size) ?? UIFont.systemFont(ofSize: size, weight: .medium)
    }

    static func montMediumItalic(size: CGFloat) -> UIFont {
        UIFont(name: CustomFontName.montMediumItalic, size: size) ?? UIFont.italicSystemFont(ofSize: size)
    }

    static func montRegular(size: CGFloat) -> UIFont {
        UIFont(name: CustomFontName.montRegular, size: size) ?? UIFont.systemFont(ofSize: size, weight: .regular)
    }

    static func montSemiBold(size: CGFloat) -> UIFont {
        UIFont(name: CustomFontName.montSemiBold, size: size) ?? UIFont.systemFont(ofSize: size, weight: .semibold)
    }
}
