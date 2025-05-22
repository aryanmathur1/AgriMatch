import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct TipsView: View {
    private var tipOfTheDay: Tip = dailyTip

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Tip of the Day")
                        .font(.largeTitle)
                        .bold()
                        .padding(.top)

                    VStack(alignment: .leading, spacing: 12) {
                        Text(tipOfTheDay.title)
                            .font(.title2)
                            .fontWeight(.semibold)

                        Text(tipOfTheDay.description)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true) // Allow wrapping
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color("AgriCream").opacity(0.3))
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                    .padding()
                }
                .frame(maxWidth: .infinity, alignment: .top)
            }
        }
    }
}
