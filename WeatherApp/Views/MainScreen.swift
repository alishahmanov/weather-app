//
//  MainScreen.swift
//  WeatherApp
//
//  Created by Alihan on 29.06.2025.
//


import SwiftUI

struct MainScreen: View {
    @StateObject private var weather = WeatherViewModel()
    @State var city: String = "Astana"
    @State var showMenu: Bool = false
    
    var textColor: Color {
        switch weather.description {
        case "SCATTERED CLOUDS", "FEW CLOUDS", "BROKEN CLOUDS":
            return .white
        case "CLEAR SKY":
            return .lightYellow
        case "MODERATE RAIN", "LIGHT RAIN":
            return .lightBlue
        default:
            return .black
        }
    }
    var mainTextColor: Color {
        switch weather.description {
        case "SCATTERED CLOUDS", "FEW CLOUDS", "BROKEN CLOUDS":
            return .black
        case "CLEAR SKY":
            return .orange
        case "MODERATE RAIN", "LIGHT RAIN":
            return .darkBlue
            
        default:
            return .black
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                Rectangle()
                    .fill(styleForBackground("\(weather.description)")
                    )
                    .ignoresSafeArea()
            }
            VStack {
                HStack {
                    Button {
                        withAnimation {
                            showMenu.toggle()
                        }
                    } label: {
                        Text("\(city)")
                            .foregroundColor(textColor)
                            .fontWeight(.bold)
                    }
                    .padding()
                    Spacer()
                }
                Spacer()
                switch weather.description {
                case "SCATTERED CLOUDS", "FEW CLOUDS":
                    Text("\u{26C5}")
                        .frame(width: 200, height: 150)
                        .font(.system(size: 150))
                        .shadow(color: .black, radius: 50)
                case "BROKEN CLOUDS":
                    Text("\u{2601}")
                        .frame(width: 200, height: 150)
                        .font(.system(size: 150))
                        .shadow(color: .black, radius: 50)
                case "CLEAR SKY":
                    Text("\u{2600}")
                        .frame(width: 200, height: 150)
                        .font(.system(size: 150))
                        .shadow(color: .yellow, radius: 100)
                case "MODERATE RAIN", "LIGHT RAIN":
                    Text("\u{1F327}")
                        .frame(width: 200, height: 150)
                        .font(.system(size: 150))
                        .shadow(color: .blue, radius: 100)
                default:
                    Text("None")
                }
                Text("\(weather.description)")
                    .padding(.top, 20)
                    .transition(.opacity)
                    .font(.system(size: 25, weight: .bold))
                    .foregroundColor(mainTextColor)
                    .animation(.easeInOut, value: weather.description)
                Text("\(weather.temperature, specifier:"%.1f") °C")
                    .padding(.top, 20)
                    .transition(.opacity)
                    .font(.system(size: 50, weight: .bold))
                    .foregroundColor(mainTextColor)
                    .animation(.easeInOut, value: weather.temperature)
                Text("Feels like \(weather.feelsLike, specifier:"%.1f") °C")
                    .fontWeight(.bold)
                    .foregroundColor(mainTextColor)
                    .transition(.opacity)
                    .animation(.easeInOut, value: weather.feelsLike)
                Text(currentWeekday())
                    .font(.title)
                    .foregroundColor(.black)
                    .fontWeight(.heavy)
                    .padding(.bottom, 1)
                    .padding(.top, 4)
                Spacer()
                HStack {
                    VStack {
                        Text("Pressure")
                            .font(.system(size: 20))
                            .fontWeight(.medium)
                            .padding(.bottom,10)
                        Text("\(weather.pressureText, specifier: "%.1f")")
                            .font(.system(size: 24))
                            .foregroundColor(textColor)
                            .fontWeight(.bold)
                            .transition(.opacity)
                            .animation(.easeInOut, value: weather.feelsLike)
                    }
                    .padding(.horizontal)
                    Spacer()
                    VStack {
                        Text("Humidity")
                            .font(.system(size: 20))
                            .fontWeight(.medium)
                            .padding(.bottom,10)
                        Text("\(weather.humidityText, specifier: "%.1f")")
                            .font(.system(size: 24))
                            .foregroundColor(textColor)
                            .fontWeight(.bold)
                            .transition(.opacity)
                            .animation(.easeInOut, value: weather.feelsLike)
                    }
                    .padding(.horizontal)
                    Spacer()
                    VStack {
                        Text("Visibility")
                            .font(.system(size: 20))
                            .fontWeight(.medium)
                            .padding(.bottom,10)
                        Text("\(Int(weather.visibilityText))")
                            .font(.system(size: 24))
                            .fontWeight(.bold)
                            .foregroundColor(textColor)
                            .transition(.opacity)
                            .animation(.easeInOut, value: weather.visibilityText)
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 50)
                Spacer()
                
                
            }
            if showMenu {
                Group {
                    CityMenuView(city: $city)
                        .frame(width: 150, height: 150)
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
            
        }
        .onAppear {
            Task {
                await weather.fetchWeather(city: "\(city)")
            }
        }
        .onChange(of: city) { newCity in
            Task {
                await weather.fetchWeather(city: newCity)
            }
        }
    }
    func styleForBackground(_ type: String) -> RadialGradient {
        switch type {
        case "CLEAR SKY":
            return RadialGradient(
                gradient: Gradient(colors: [.yellow.opacity(0.7), .lightYellow.opacity(0.3), .orange]),
                center: .center,
                startRadius: 150,
                endRadius: 300
            )
        case "BROKEN CLOUDS":
            return RadialGradient(
                gradient: Gradient(colors: [.gray.opacity(0.5), .white.opacity(0.9), .darkGray.opacity(0.7)]),
                center: .center,
                startRadius: 150,
                endRadius: 300
            )
        case "SCATTERED CLOUDS", "FEW CLOUDS":
            return RadialGradient(
                gradient: Gradient(colors: [.white.opacity(0.9), .lightYellow.opacity(1), .gray]),
                center: .center,
                startRadius: 150,
                endRadius: 300
            )
        case "MODERATE RAIN", "LIGHT RAIN":
            return RadialGradient(
                gradient: Gradient(colors: [.blue.opacity(0.5), .lightBlue, .darkBlue.opacity(0.8)]),
                center: .center,
                startRadius: 150,
                endRadius: 300
            )
        default:
            return RadialGradient(
                gradient: Gradient(colors: [.white, .white, .white]),
                center: .center,
                startRadius: 150,
                endRadius: 300
            )
        }
    }
    func currentWeekday() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "EEEE"
        return formatter.string(from: Date()).capitalized
    }
}

#Preview {
    MainScreen()
}
