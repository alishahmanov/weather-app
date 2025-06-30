//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Alihan on 29.06.2025.
//



import Foundation
import SwiftUI

@MainActor
final class WeatherViewModel: ObservableObject {
    @Published var cityName: String = ""
    @Published var temperature: Double = 0
    @Published var description: String = ""
    @Published var feelsLike: Double = 0
    @Published var pressureText: Double = 0
    @Published var humidityText: Double = 0
    @Published var visibilityText: Double = 0
    
    private let service = NetworkService()
    
    func fetchWeather(city: String) async {
        do {
            let weather = try await service.fetchData(city: city)
            cityName = weather.name
            temperature = weather.main.temp
            feelsLike = weather.main.feelsLike
            description = weather.weather.first?.description.uppercased() ?? "N/A"
            pressureText = weather.main.pressure
            humidityText = weather.main.humidity
            visibilityText = weather.visibility
            
        } catch {
            cityName = "Error"
            temperature = 0
            description = "To see the weather, please enter a valid city name"
        }
        
    }
    
}
