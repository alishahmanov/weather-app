//
//  NetworkService.swift
//  WeatherApp
//
//  Created by Alihan on 29.06.2025.
//


import Foundation

final class NetworkService{
    private let apiKey = Config.apiKey
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    
    func fetchData(city: String) async throws -> WeatherData {
        let urlString = "\(baseURL)?q=\(city)&appid=\(apiKey)&units=metric&lang=en"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data,response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return try decoder.decode(WeatherData.self, from: data)
    }
}
