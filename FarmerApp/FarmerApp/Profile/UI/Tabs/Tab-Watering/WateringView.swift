//
//  WateringView.swift
//  FarmerApp
//
//  Created by Aryan Mathur on 5/1/25.
//

import SwiftUI

struct WateringView: View {
    @State private var location: String = ""
    @State private var latitude: Double? = nil
    @State private var longitude: Double? = nil
    
    @State private var rainfallLast48Hours: Double = 0.0 // in mm
    @State private var recommendedWatering: Double = 0.0 // in liters per m²
    @State private var lastWatered: Date? = nil
    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Watering Recommendation")
                .font(.title)
                .bold()
            
            TextField("Enter Location (e.g., New York)", text: $location)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                .padding(.horizontal)
            
            Button(action: fetchRainfall) {
                Text("Check Watering Need")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            .disabled(isLoading)
            
            if isLoading {
                ProgressView()
            } else if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
            } else if recommendedWatering > 0 {
                Text("Water **\(String(format: "%.1f", recommendedWatering)) L/m²**")
                    .font(.title2)
                    .padding(.top, 10)
            } else if rainfallLast48Hours > 0 {
                Text("No watering needed 🌧️")
                    .font(.title2)
                    .padding(.top, 10)
            }
            
            Spacer()
            
            Button(action: {
                lastWatered = Date()
            }) {
                HStack {
                    Image(systemName: "drop.fill")
                    Text(lastWatered != nil ? "Last Watered: \(formattedDate(lastWatered!))" : "Mark as Watered")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .padding(.top)
    }

    func fetchRainfall() {
        guard !location.isEmpty else {
            errorMessage = "Please enter a location"
            return
        }
        errorMessage = nil
        isLoading = true
        
        geocodeLocation(location) { lat, lon in
            guard let lat = lat, let lon = lon else {
                DispatchQueue.main.async {
                    self.errorMessage = "Location not found"
                    self.isLoading = false
                }
                return
            }
            self.latitude = lat
            self.longitude = lon
            self.fetchRainfallData(lat: lat, lon: lon)
        }
    }
    
    func fetchRainfallData(lat: Double, lon: Double) {
        let now = Date()
        let past48h = Calendar.current.date(byAdding: .hour, value: -48, to: now)!
        
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime]
        let startDate = isoFormatter.string(from: past48h)
        let endDate = isoFormatter.string(from: now)

        let urlString = "https://api.open-meteo.com/v1/forecast?latitude=\(lat)&longitude=\(lon)&hourly=precipitation&start_date=\(startDate.prefix(10))&end_date=\(endDate.prefix(10))&timezone=auto"
        
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid URL"
                self.isLoading = false
            }
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
            }
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Error: \(error.localizedDescription)"
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "No data received"
                }
                return
            }
            do {
                let decoded = try JSONDecoder().decode(MeteoResponse.self, from: data)
                let rainfall = decoded.hourly.precipitation.prefix(48).reduce(0, +) // sum of last 48 hours
                DispatchQueue.main.async {
                    self.rainfallLast48Hours = rainfall
                    self.calculateWatering()
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to parse data"
                }
            }
        }.resume()
    }

    func calculateWatering() {
        let idealPer48h = 2.86 // L/m² per 48 hours
        let toWater = max(idealPer48h - rainfallLast48Hours, 0)
        recommendedWatering = toWater
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    func geocodeLocation(_ location: String, completion: @escaping (Double?, Double?) -> Void) {
        // Use Open-Meteo's geocoding API
        let urlString = "https://geocoding-api.open-meteo.com/v1/search?name=\(location.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        guard let url = URL(string: urlString) else {
            completion(nil, nil)
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let decoded = try? JSONDecoder().decode(GeoResponse.self, from: data),
                   let first = decoded.results?.first {
                    completion(first.latitude, first.longitude)
                    return
                }
            }
            completion(nil, nil)
        }.resume()
    }
}

// MARK: - JSON Models

struct MeteoResponse: Codable {
    struct Hourly: Codable {
        let precipitation: [Double]
    }
    let hourly: Hourly
}

struct GeoResponse: Codable {
    struct Result: Codable {
        let latitude: Double
        let longitude: Double
    }
    let results: [Result]?
}

#Preview {
    WateringView()
}
