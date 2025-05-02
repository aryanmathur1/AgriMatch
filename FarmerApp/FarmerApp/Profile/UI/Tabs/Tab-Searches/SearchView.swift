//
//  SearchView.swift
//  FarmerApp
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = PlantCardViewModel()
    @State private var searchText = ""
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var selectedPlantID: UUID?
    
    var filteredPlants: [PlantCard] {
        if searchText.isEmpty {
            return viewModel.cards
        } else {
            return viewModel.cards.filter { plant in
                plant.plantName.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Search for a plant...", text: $searchText)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                
                List {
                    ForEach(filteredPlants) { plant in
                        HStack {
                            AsyncImage(url: URL(string: plant.imageURL)) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(8)
                                } else {
                                    Color.gray
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(8)
                                }
                            }
                            
                            Text(plant.plantName)
                                .font(.headline)
                        }
                        .padding(.vertical, 4)
                        .scaleEffect(selectedPlantID == plant.id ? 0.95 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: selectedPlantID)
                        .onTapGesture {
                            withAnimation {
                                selectedPlantID = plant.id
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                selectedPlantID = nil
                                acceptPlant(plant: plant)
                                searchText = "" // Clear search
                                hideKeyboard()  // Hide keyboard (custom extension below)
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Search Plants")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color("AgriCream").opacity(0.1))
        }
    }
    
    private func acceptPlant(plant: PlantCard) {
        authViewModel.savePlant(plant: plant, to: "acceptedPlants")
        print("Accepted plant from search: \(plant.plantName)")
    }
}

// Helper extension to hide keyboard
#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

#Preview {
    SearchView().environmentObject(AuthViewModel())
}
