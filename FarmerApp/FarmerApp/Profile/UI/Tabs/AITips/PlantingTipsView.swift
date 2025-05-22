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
                ForEach(displayedTips, id: \.self) { tip in
                    formattedTip(tip)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 12).fill(colorScheme == .dark ? Color.white.opacity(0.1) : Color.gray.opacity(0.1)))
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

    // MARK: - Markdown-style Text Formatter

    private func formattedTip(_ tip: String) -> Text {
        let lines = tip.components(separatedBy: .newlines)
        var result = Text("")

        for (i, line) in lines.enumerated() {
            if line.trimmingCharacters(in: .whitespaces).hasPrefix("* ") {
                let bulletContent = String(line.dropFirst(2))
                result = result + Text("• ") + parseInlineStyles(bulletContent) + Text("\n")
            } else {
                result = result + parseInlineStyles(line) + Text("\n")
            }
        }

        return result
            .font(.body)
            .foregroundColor(.secondary)
    }

    private func parseInlineStyles(_ input: String) -> Text {
        var result = Text("")
        var current = input
        var isBold = false
        var isItalic = false

        while !current.isEmpty {
            if let boldRange = current.range(of: "**") {
                let prefix = String(current[..<boldRange.lowerBound])
                result = result + applyStyle(to: prefix, bold: isBold, italic: isItalic)
                current = String(current[boldRange.upperBound...])
                isBold.toggle()
            } else if let italicRange = current.range(of: "*") {
                let prefix = String(current[..<italicRange.lowerBound])
                result = result + applyStyle(to: prefix, bold: isBold, italic: isItalic)
                current = String(current[italicRange.upperBound...])
                isItalic.toggle()
            } else {
                result = result + applyStyle(to: current, bold: isBold, italic: isItalic)
                break
            }
        }

        return result
    }

    private func applyStyle(to text: String, bold: Bool, italic: Bool) -> Text {
        var styledText = Text(text)
        if bold && italic {
            styledText = styledText.bold().italic()
        } else if bold {
            styledText = styledText.bold()
        } else if italic {
            styledText = styledText.italic()
        }
        return styledText
    }
}

