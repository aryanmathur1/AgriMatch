import SwiftUI

struct SwipeCardView: View {
    var title: String
    var description: String
    var imageName: String
    
    @Binding var offset: CGSize
    @Binding var isSwiped: Bool
    
    @State private var showSearchSheet = false
    
    let maxDrag: CGFloat = 150.0
    let swipeThreshold: CGFloat = 120.0
    
    var body: some View {
        VStack (spacing: 10, content: {
            ZStack {
                // Full background image
                AsyncImage(url: URL(string: imageName), transaction: Transaction(animation: .easeInOut)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 300, height: 400)
                            .clipped()
                            .cornerRadius(20)
                            .overlay(
                                ZStack {
                                    Color.green.opacity(clampedGreenOpacity)
                                    Color.red.opacity(clampedRedOpacity)
                                }
                                .cornerRadius(20)
                            )
                    case .failure(_):
                        Color.gray
                            .frame(width: 300, height: 400)
                            .cornerRadius(20)
                    @unknown default:
                        EmptyView()
                    }
                }

                
                // Text content with glass effect
                VStack(spacing: 12) {
                    Spacer()
                    
                    VStack(spacing: 8) {
                        Text(title)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text(description)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(16)
                    .padding()
                }
                
                // Floating checkmark
                if offset.width > 0 {
                    VStack {
                        HStack {
                            Spacer()
                            Text("✅")
                                .font(.system(size: 50))
                                .rotationEffect(.degrees(Double(offset.width / 10)))
                                .opacity(min(Double(offset.width / 100), 1))
                                .padding()
                        }
                        Spacer()
                    }
                }
                
                // Floating cross
                if offset.width < 0 {
                    VStack {
                        HStack {
                            Text("❌")
                                .font(.system(size: 50))
                                .rotationEffect(.degrees(Double(offset.width / 10)))
                                .opacity(min(Double(-offset.width / 100), 1))
                                .padding()
                            Spacer()
                        }
                        Spacer()
                    }
                }
            }
            .frame(width: 300, height: 400)
            .cornerRadius(20)
            .shadow(radius: 8)
            .rotationEffect(.degrees(Double(offset.width / 20)))
            .offset(x: offset.width, y: offset.height)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        offset = gesture.translation
                    }
                    .onEnded { _ in
                        withAnimation(.easeInOut) {
                            if offset.width > swipeThreshold {
                                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                offset = CGSize(width: 1000, height: 0)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    isSwiped = true
                                }
                            } else if offset.width < -swipeThreshold {
                                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                offset = CGSize(width: -1000, height: 0)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    isSwiped = true
                                }
                            } else {
                                offset = .zero
                            }
                        }
                    }
            )
            .animation(.spring(response: 0.35, dampingFraction: 0.7), value: offset)
            
            // Search button
            Button(action: {
                showSearchSheet.toggle()
            }) {
                Text("Search 🔎")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding()
            }
            .sheet(isPresented: $showSearchSheet) {
                SearchView()
                    .environmentObject(AuthViewModel())
            }
            
        })
        
    }
    
    // Tint opacities
    private var clampedGreenOpacity: Double {
        let value = offset.width / maxDrag
        return Double(max(0, min(value, 1)))
    }
    
    private var clampedRedOpacity: Double {
        let value = -offset.width / maxDrag
        return Double(max(0, min(value, 1)))
    }
}

