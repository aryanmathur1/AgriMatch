//
//  Page.swift
//  FarmerApp
//
//  Created by vibhun naredla on 3/22/25.
//

import SwiftUI

enum Page: String, CaseIterable {
    case page1 = "leaf.fill"
    case page2 = "heart.fill"
    case page3 = "chart.bar.fill"
    case page4 = "person.2.fill"
    
    var title: String {
        switch self {
        case .page1: "Welcome to AgriMatch"
        case .page2: "Find the Perfect Plant Pairings"
        case .page3: "Grow Smarter, Save More"
        case .page4: "Join the Farming Revolution"
        }
    }
    
    var subTitle: String {
        switch self {
        case .page1: "The app that helps farmers grow smarter with the power of companion planting."
        case .page2: "Swipe through the best crop combinations to boost your farm’s health and yield."
        case .page3: "Smart suggestions based on user data for a better yield."
        case .page4: "Join us and contribute to a sustainable, smarter future for agriculture."
        }
    }
    
    var index: CGFloat {
        switch self {
        case .page1: 0
        case .page2: 1
        case .page3: 2
        case .page4: 3
        }
    }
    
    /// fetches the next page, if its not the last page
    var nextPage: Page {
        let index = Int(self.index) + 1
        if index < 4 {
            return Page.allCases[index]
        }
        
        return self
    }
    
    // Fetches the previous page, if its not the first page
    var previousPage: Page {
        let index = Int(self.index) - 1
        if index >= 0 {
            return Page.allCases[index]
        }
        
        return self
    }
}
