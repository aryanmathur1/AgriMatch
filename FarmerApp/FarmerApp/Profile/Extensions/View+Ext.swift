//
//  View+Ext.swift
//  Shopping
//
//

import SwiftUI

//MARK: - Extension View

extension View {
    
    func setupNavigationBar(
        title: String,
        displayMode: NavigationBarItem.TitleDisplayMode = .inline,
        setBG: Bool = false,
        colorScheme: ColorScheme,
        leftNavBar: () -> some View,
        rightNavBar: () -> some View
    ) -> some View {
        navigationTitle(title)
            .navigationBarTitleDisplayMode(displayMode)
            .navigationBarBackButtonHidden()
            .toolbarBackground(
                setBG
                ? DarkMode.shared.black_whiteColor(colorScheme)
                : DarkMode.shared.backgroundColor(colorScheme),
                for: .navigationBar
            )
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    leftNavBar()
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    rightNavBar()
                }
            }
    }
}
