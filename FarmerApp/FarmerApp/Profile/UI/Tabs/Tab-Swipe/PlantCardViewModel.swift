//
//  PlantCardViewModel.swift
//  FarmerApp
//
//  Created by vibhun naredla on 4/28/25.
//

//
//  PlantCardViewModel.swift
//  AgriMatch
//

import Foundation

class PlantCardViewModel: ObservableObject {
    @Published var cards: [PlantCard] = []
    
    init() {
        loadPlantCards()
    }
    
    func loadPlantCards() {
        if let url = Bundle.main.url(forResource: "PlantCardsData", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decodedCards = try JSONDecoder().decode([PlantCard].self, from: data)
                self.cards = decodedCards
            } catch {
                print("DEBUG: Failed to load plant cards: \(error)")
            }
        } else {
            print("DEBUG: PlantCardsData.json not found!")
        }
    }
}
