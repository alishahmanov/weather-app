//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Alihan on 29.06.2025.
//


import SwiftUI

struct WeatherData: Codable {
    let main: Main
    let name: String
    let wind: Wind
    let sys: Sys
    let weather: [Weather]
    let visibility: Double
}

struct Sys: Codable {
    let country: String
}

struct Wind: Codable {
    let speed: Double
}



struct Main: Codable {
    let temp: Double
    let feelsLike: Double
    let pressure: Double
    let humidity: Double
}

struct Weather: Codable {
    let icon: String
    let description: String
}