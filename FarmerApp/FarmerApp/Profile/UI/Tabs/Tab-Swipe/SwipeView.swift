//
//  SwipeView.swift
//  FarmerApp
//
//  Created by vibhun naredla on 4/27/25.
//

import SwiftUI

struct SwipeView: View {
    @StateObject private var viewModel = PlantCardViewModel()
    @State private var topCardIndex = 0
    
    
    var body: some View {
        ZStack {
            ForEach(viewModel.cards.indices.reversed(), id: \.self) { index in
                if index >= topCardIndex {
                    SwipeCard(
                        card: viewModel.cards[index],
                        onRemove: {
                            topCardIndex += 1
                        }
                    )
                    .padding()
                }
            }
        }
        .navigationTitle("Swipe Plants")
        .navigationBarTitleDisplayMode(.inline)
        //.background(Color("AgriCream").opacity(0.15))
        .background(Color.black)
    }
}

struct SwipeCard: View {
    var card: PlantCard
    var onRemove: () -> Void
    
    @State private var offset = CGSize.zero
    @State private var isSwiped = false
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        SwipeCardView(
            title: card.plantName,
            description: "",
            imageName: card.imageURL,
            offset: $offset,
            isSwiped: $isSwiped
        )
        .onChange(of: isSwiped) { swiped in
            if swiped {
                if offset.width > 0 {
                    authViewModel.savePlant(plant: card, to: "acceptedPlants") // Use authViewModel
                } else if offset.width < 0 {
                    print("Swiped left - rejecting plant")
                    authViewModel.savePlant(plant: card, to: "rejectedPlants")
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    onRemove()
                }
            }
        }
    }
}

