import SwiftUI
import CoreLocation
import Combine

struct WeatherView: View {
    @StateObject var weatherViewModel = WeatherViewModel()

    var body: some View {
        NavigationView {
            VStack(spacing: 10) {

                Text("Watering")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(Color.primary)
                    .padding(.top, 20)

                HStack {
                    Text("City: \(weatherViewModel.city)")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color.secondary)
                    Spacer()
                }
                .padding(.horizontal)

                VStack {
                    Text("Current Temp")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color.secondary)
                    Text("\(weatherViewModel.temperature)°F")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color.primary)
                }
                .padding()
                .frame(maxWidth: 350)
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(12)
                .shadow(radius: 2)

                VStack {
                    Text("Past 48h Rainfall")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color.secondary)
                    Text(String(format: "%.1f", weatherViewModel.totalRainfall) + " mm")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color.primary)
                }
                .padding()
                .frame(maxWidth: 350)
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(12)
                .shadow(radius: 2)

                VStack {
                    Text("Water Recommendation")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color.secondary)
                    Text(weatherViewModel.waterRecommendation)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color.primary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
                .padding()
                .frame(maxWidth: 350)
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(12)
                .shadow(radius: 2)

                VStack {
                    Text("Water Amount (per m²)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color.secondary)
                    Text(weatherViewModel.waterAmount)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color.primary)
                }
                .padding()
                .frame(maxWidth: 350)
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(12)
                .shadow(radius: 2)

                Spacer()

                Button(action: {
                    weatherViewModel.lastWatered = Date()
                }) {
                    Text("Watered Today")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(12)
                        .shadow(radius: 3)
                }
                .padding(.horizontal)

                if let wateredDate = weatherViewModel.lastWatered {
                    Text("Last watered: \(formattedDate(wateredDate))")
                        .font(.footnote)
                        .foregroundColor(Color.secondary)
                }

                Spacer()
            }
            .padding()
            .background(Color(UIColor.systemBackground).edgesIgnoringSafeArea(.all))
            .navigationBarHidden(true)
        }
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
            .preferredColorScheme(.dark)  // 👈 Preview in Dark Mode
    }
}
