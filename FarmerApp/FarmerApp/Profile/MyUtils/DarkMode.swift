//
//  DarkMode.swift
//  Shopping
//
//

import SwiftUI

class DarkMode: NSObject {
    
    static let shared = DarkMode()
}

//MARK: - Default Color

extension DarkMode {
    
    func defaultColor(_ colorScheme: ColorScheme) -> Color {
        return Color(hex: colorScheme == .dark ? 0xFFFFFF : 0x121212)
    }
}

//MARK: - Background Color

extension DarkMode {
    
    func backgroundColor(_ colorScheme: ColorScheme) -> Color {
        return Color(hex: colorScheme == .dark ? 0x000000 : 0xFFFFFF)
    }
}

//MARK: - Black/White Color

extension DarkMode {
    
    ///isDark ? .black : .white
    func black_whiteColor(_ colorScheme: ColorScheme) -> Color {
        return colorScheme == .dark ? Color.black : Color.white
    }
    
    ///isDark ? .white : .black
    func white_blackColor(_ colorScheme: ColorScheme) -> Color {
        return colorScheme == .dark ? Color.white : Color.black
    }
}
