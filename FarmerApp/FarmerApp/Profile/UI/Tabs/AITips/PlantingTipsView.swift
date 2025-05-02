import SwiftUI

struct PlantingTipsView: View {
    
    var acceptedPlants: [Product]
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var aiTips: [String] = UserDefaults.standard.stringArray(forKey: "aiTips") ?? []
    @State private var isLoading: Bool = false
    @State private var rotation: Double = 0
    @State private var isExpanded: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                Text("🌿 AI Planting Tips")
                    .font(.title3.bold())
                    .foregroundStyle(DarkMode.shared.defaultColor(colorScheme))
                
                Spacer()
                
                Button {
                    refreshTips()
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .font(.title3)
                        .foregroundStyle(DarkMode.shared.defaultColor(colorScheme))
                        .rotationEffect(.degrees(rotation))
                }
                .buttonStyle(.plain)
                .disabled(isLoading)

            }
            
            if isLoading {
                loadingAnimation()
            } else if aiTips.isEmpty {
                Text("No tips available. Try adding more plants!")
                    .foregroundStyle(.secondary)
            } else {
                // If collapsed show only 1 tip
                ForEach(displayedTips, id: \.self) { tip in
                    Text(tip)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 12).fill(colorScheme == .dark ? Color.black.opacity(0.2) : Color.gray.opacity(0.1)))
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                
                Button {
                    withAnimation {
                        isExpanded.toggle()
                    }
                } label: {
                    Text(isExpanded ? "See Less" : "See More")
                        .font(.subheadline.bold())
                        .foregroundColor(Color.accentColor)
                }
                .buttonStyle(.plain)
                .padding(.top, 8)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 20).fill(DarkMode.shared.backgroundColor(colorScheme).opacity(0.5)))
        .padding(.horizontal)
        .onAppear {
            if aiTips.isEmpty {
                fetchAITips()
            }
        }
    }
    
    private var displayedTips: [String] {
        isExpanded ? aiTips : Array(aiTips.prefix(1))
    }
    
    private func fetchAITips() {
        isLoading = true
        rotation = 0
        withAnimation {
            rotation = 360
        }
        
        let plantNames = acceptedPlants.map { $0.name }
        guard !plantNames.isEmpty else {
            isLoading = false
            return
        }
        
        AITipsService().generatePlantingTips(from: plantNames) { tips in
            DispatchQueue.main.async {
                withAnimation {
                    self.aiTips = tips
                    self.isLoading = false
                    // Store the fetched tips in UserDefaults
                    UserDefaults.standard.set(tips, forKey: "aiTips")
                }
            }
        }
    }
    
    private func refreshTips() {
        fetchAITips()
    }
    
    @ViewBuilder
    private func loadingAnimation() -> some View {
        VStack(spacing: 12) {
            // Leaf spinning icon
            Image(systemName: "leaf.circle.fill")
                .font(.system(size: 40))
                .foregroundStyle(.green)
                .rotationEffect(.degrees(rotation))
                .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: rotation)
                .onAppear {
                    rotation = 360
                }
            
            Text("Generating smart tips...")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
    }
}
