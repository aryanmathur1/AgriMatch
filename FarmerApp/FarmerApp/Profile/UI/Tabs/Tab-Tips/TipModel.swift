//
//  TipModel.swift
//  FarmerApp
//
//  Created by vibhun naredla on 4/28/25.
//

import Foundation

struct Tip: Identifiable {
    let id = UUID()
    let title: String
    let description: String
}

// Sample farming tips
let sampleTips: [Tip] = [
    Tip(title: "Companion Planting", description: "Pair basil with tomatoes to repel pests and boost growth."),
    Tip(title: "Crop Rotation", description: "Rotate your crops each season to maintain healthy soil."),
    Tip(title: "Mulching Magic", description: "Apply mulch to conserve water and prevent weed growth."),
    Tip(title: "Pollinator Friendly", description: "Plant wildflowers nearby to attract bees and improve pollination."),
    Tip(title: "Deep Watering", description: "Water deeply but less frequently to encourage stronger roots."),
    Tip(title: "Seasonal Planning", description: "Plan crops based on seasons to maximize yield and reduce waste."),
    Tip(title: "Natural Fertilizers", description: "Use compost and manure to enrich soil health organically."),
    Tip(title: "Sunlight Optimization", description: "Group sun-loving plants together and shade-tolerant plants elsewhere.")
]

// Picks a daily rotating tip based on the date
var dailyTip: Tip {
    let calendar = Calendar.current
    let dayOfYear = calendar.ordinality(of: .day, in: .year, for: Date()) ?? 1
    let index = dayOfYear % sampleTips.count
    return sampleTips[index]
}
