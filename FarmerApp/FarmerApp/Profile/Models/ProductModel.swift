//
//  ProductModel.swift
//  Shopping
//
//

import SwiftUI

struct Product: Identifiable, Hashable {
    
    let id: String = UUID().uuidString
    let name: String
    let price: Double
    let oldPrice: Double
    var imageLinks: [String]
    var sizes: [String]
    var colors: [String]
    var description: String
    var isFav: Bool
    
    var rating1: Int
    var rating2: Int
    var rating3: Int
    var rating4: Int
    var rating5: Int
    
    static func shared() -> Product {
        let description = """
PRODUCT DETAILS
Classic fitted women's crew neck T-shirt, made sustainably with care for people and planet.
        
- 100% Cotton, Organic and Fairtrade-certified
- Standard fit
- Ribbed neckline
        
SIZE & FIT
Studio model is 179 cm tall and wearing size Small.
        
FABRIC
100% Organic and Fairtrade-certified Cotton, single jersey knit, 160 gsm.
"""
        
        return Product(
            name: "T-shirt Mysen Woodstock Grey Melange",
            price: 31.99,
            oldPrice: 45.99,
            imageLinks: ["tshirt_1", "tshirt_2", "tshirt_3", "tshirt_4"],
            sizes: ["S", "M", "L", "XL", "XXL", "ONE SIZE"],
            colors: ["000000", "FFFFFF"],
            description: description,
            isFav: true,
            rating1: 10,
            rating2: 20,
            rating3: 30,
            rating4: 40,
            rating5: 90
        )
    }
}
