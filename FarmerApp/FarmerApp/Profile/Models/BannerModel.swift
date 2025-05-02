import SwiftUI

struct BannerModel: Identifiable, Hashable, Codable {
    let id: String
    let title: String
    let description: String
    let relatedPlants: [String]
    let imageURL: String  // or change to imageURL: String if using AsyncImage

    static func sampleTips() -> [BannerModel] {
        return [
            BannerModel(
                id: UUID().uuidString,
                title: "Tomato + Basil = Dream Team",
                description: "Basil boosts tomato flavor and repels pests.",
                relatedPlants: ["Tomato", "Basil"],
                imageURL: "logo"
            ),
            BannerModel(
                id: UUID().uuidString,
                title: "Carrot + Onion Combo",
                description: "Carrots and onions protect each other from root flies.",
                relatedPlants: ["Carrot", "Onion"],
                imageURL: "logo"
            ),
            BannerModel(
                id: UUID().uuidString,
                title: "Three Sisters Method",
                description: "Corn supports beans, beans fix nitrogen, squash protects soil. Ancient wisdom!",
                relatedPlants: ["Corn", "Beans", "Squash"],
                imageURL: "logo"
            )
        ]
    }
}
