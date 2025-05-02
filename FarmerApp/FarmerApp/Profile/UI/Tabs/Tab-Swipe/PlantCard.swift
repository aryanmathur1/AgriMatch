//
//  PlantCard.swift
//  FarmerApp
//
//  Created by vibhun naredla on 4/28/25.
//

import Foundation

struct PlantCard: Identifiable, Codable {
    var id = UUID()
    let plantName: String
    let imageURL: String
    
    private enum CodingKeys: String, CodingKey {
        case plantName
        case imageURL
    }
}

