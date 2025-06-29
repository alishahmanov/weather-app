//
//  Config.swift
//  WeatherApp
//
//  Created by Alihan on 30.06.2025.
//

import Foundation

enum Config {
    private static let plist: [String: Any] = {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path) as? [String: Any] else {
            fatalError("Config.plist не найден!")
        }
        return dict
    }()
    
    static let apiKey: String = {
        guard let key = plist["apiWeatherKey"] as? String else {
            fatalError("API ключ не найден в Config.plist")
        }
        return key
    }()
}
