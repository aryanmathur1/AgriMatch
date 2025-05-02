//
//  TabModel.swift
//  Shopping
//
//

import SwiftUI

enum TabModel: String, CaseIterable {
    
    case home = "Home"
    case tips = "Tips"
    case swipe = "Swipe"
    case search = "Water"
    case profile = "Profile"
    
    var image: Image {
        switch self {
        case .home: return Image(uiImage: .tabBarHome)
        case .tips: return Image(uiImage: .tabBarTips)
        case .swipe: return Image(uiImage: .tabBarSwipe)
        case .search: return Image(uiImage: .tabBarSearch)
        case .profile: return Image(uiImage: .tabBarUser)
        }
    }
    
    var index: Int {
        return TabModel.allCases.firstIndex(of: self) ?? 0
    }
}
