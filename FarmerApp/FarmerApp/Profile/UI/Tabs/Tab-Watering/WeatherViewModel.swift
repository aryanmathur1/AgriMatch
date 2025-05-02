//
//  WeatherViewModel.swift
//  FarmerApp
//
//  Created by Aryan Mathur on 4/30/25.
//

import SwiftUI
import CoreLocation
import Combine

class WeatherViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var temperature: String = "--"
    @Published var totalRainfall: Double = 0.0
    @Published var shouldWater: Bool = true
    @Published var lastWatered: Date? {
        didSet {
            if let lastWatered = lastWatered {
                UserDefaults.standard.set(lastWatered, forKey: "lastWatered")
            }
        }
    } 
    @Published var city: String = "Loading..."
    @Published var waterRecommendation: String = "--"
    @Published var waterAmount: String = "--"

    private var locationManager = LocationManager()
    private var userLatitude: Double?
    private var userLongitude: Double?

    private var cancellables: Set<AnyCancellable> = []

    override init() {
        super.init()
        setupLocationManager()
        loadLastWatered()
    }

    func setupLocationManager() {
        locationManager.requestLocation()
        locationManager.$location
            .sink { [weak self] location in
                if let location = location {
                    self?.userLatitude = location.latitude
                    self?.userLongitude = location.longitude
                    self?.fetchCityAndWeather()
                }
            }
            .store(in: &cancellables)
    }

    func loadLastWatered() {
        if let savedDate = UserDefaults.standard.object(forKey: "lastWatered") as? Date {
            self.lastWatered = savedDate
        }
    }

    func fetchCityAndWeather() {
        guard let latitude = userLatitude, let longitude = userLongitude else { return }

        // Fetch city name
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let placemark = placemarks?.first, let city = placemark.locality {
                self.city = city
            }
        }

        fetchWeather(latitude: latitude, longitude: longitude)
    }

    func fetchWeather(latitude: Double, longitude: Double) {
        let urlString = "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&past_days=2&hourly=temperature_2m,precipitation"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }

            do {
                let decoded = try JSONDecoder().decode(OpenMeteoResponse.self, from: data)
                DispatchQueue.main.async {
                    self.processWeatherData(response: decoded)
                }
            } catch {
                print("Failed to decode: \(error)")
            }
        }.resume()
    }

    func processWeatherData(response: OpenMeteoResponse) {
        guard let lastTemperature = response.hourly.temperature_2m.last else { return }
        self.temperature = String(format: "%.1f", lastTemperature * 9/5 + 32)

        let totalRain = response.hourly.precipitation.reduce(0, +)
        self.totalRainfall = totalRain

        self.shouldWater = totalRain < 5.0
        self.waterRecommendation = self.calculateWaterRecommendation(totalRain)
        self.waterAmount = self.calculateWaterAmount(totalRain)
    }

    func calculateWaterRecommendation(_ rainfall: Double) -> String {
        if rainfall > 10 {
            return "No watering needed. It's been a very rainy 2 days!"
        } else if rainfall > 5 {
            return "Moderate watering needed."
        } else {
            return "Water your plants thoroughly!"
        }
    }

    func calculateWaterAmount(_ rainfall: Double) -> String {
        // 6 mm/day evapotranspiration is about 6 liters/m²/day
        // Over 2 days: 12 liters/m² total needed
        let evapotranspiration = 12.0 // mm (2 days)
        let waterDeficit = evapotranspiration - rainfall

        if waterDeficit > 0 {
            return "\(Int(waterDeficit)) liters per square meter needed"
        } else {
            return "No additional watering needed"
        }
    }
}

// MARK: - Models

struct OpenMeteoResponse: Codable {
    let hourly: HourlyData

    struct HourlyData: Codable {
        let temperature_2m: [Double]
        let precipitation: [Double]
    }
}
