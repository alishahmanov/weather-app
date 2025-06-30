//
//  MainScreen.swift
//  WeatherApp
//
//  Created by Alihan on 29.06.2025.
//


import SwiftUI

struct MainScreen: View {
    @StateObject private var weather = WeatherViewModel()
    @State var city: String = "Сhoose a city"
    @State var showMenu: Bool = false
    @State var isPresented = false
    var textColor: Color {
        switch weather.description {
        case "SCATTERED CLOUDS", "FEW CLOUDS", "BROKEN CLOUDS", "OVERCAST CLOUDS":
            return .white
        case "CLEAR SKY":
            return .lightYellow
        case "MODERATE RAIN", "LIGHT RAIN":
            return .lightBlue
        case "THUNDERSTORM":
            return .lightBlue
        default:
            return .black
        }
    }
    var mainTextColor: Color {
        switch weather.description {
        case "SCATTERED CLOUDS", "FEW CLOUDS", "BROKEN CLOUDS", "OVERCAST CLOUDS":
            return .black
        case "CLEAR SKY":
            return .orange
        case "MODERATE RAIN", "LIGHT RAIN":
            return .darkBlue
        case "THUNDERSTORM":
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
                    .animation(.easeInOut(duration: 0.5), value: weather.description)
            }
            VStack {
                HStack {
                    Button {
                        withAnimation {
                            showMenu.toggle()
                        }
                    } label: {
                        if city.isEmpty {
                            Text("Choose a city")
                                .foregroundColor(textColor)
                                .fontWeight(.bold)
                        } else {
                            Text("\(city)")
                                .foregroundColor(textColor)
                                .fontWeight(.bold)
                        }
                    }
                    .padding()
                    Spacer()
                }
                Spacer()
                Group {
                    switch weather.description {
                    case "SCATTERED CLOUDS", "FEW CLOUDS":
                        Text("\u{26C5}")
                            .frame(width: 200, height: 150)
                            .font(.system(size: 150))
                            .shadow(color: .black, radius: 50)
                    case "BROKEN CLOUDS", "OVERCAST CLOUDS":
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
                    case "THUNDERSTORM":
                        Text("\u{26C8}")
                            .frame(width: 200, height: 150)
                            .font(.system(size: 150))
                            .shadow(color: .blue, radius: 100)
                        
                    default:
                        Text("\u{1F914}")
                            .frame(width: 200, height: 150)
                            .font(.system(size: 130))
                            .shadow(color: .blue, radius: 50)
                    }
                }
                .animation(.easeInOut(duration: 0.5), value: weather.description)
                Text("\(weather.description)")
                    .frame(width: 300)
                    .multilineTextAlignment(.center)
                    .padding(.top, 20)
                    .animation(.easeInOut(duration: 0.5), value: weather.description)
                    .transition(.opacity)
                    .font(.system(size: 25, weight: .bold))
                    .foregroundColor(mainTextColor)
                    .animation(.easeInOut, value: weather.description)
                Text("\(weather.temperature, specifier:"%.1f") °C")
                    .padding(.top, 20)
                    .animation(.easeInOut(duration: 0.5), value: weather.temperature)
                    .transition(.opacity)
                    .font(.system(size: 50, weight: .bold))
                    .foregroundColor(mainTextColor)
                    .animation(.easeInOut, value: weather.temperature)
                Text("Feels like \(weather.feelsLike, specifier:"%.1f") °C")
                    .fontWeight(.bold)
                    .animation(.easeInOut(duration: 0.5), value: weather.feelsLike)
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
            CityMenuView(city: $city, isPresented: $isPresented)
                .frame(width: 150, height: 150)
                .opacity(showMenu ? 1 : 0)
                .offset(y: showMenu ? 0 : -50)
                .animation(.easeInOut(duration: 0.4), value: showMenu)

            
        }
        .onTapGesture {
            withAnimation {
                showMenu = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                showMenu = false
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
        case "BROKEN CLOUDS", "OVERCAST CLOUDS":
            return RadialGradient(
                gradient: Gradient(colors: [.lightGray, .white.opacity(0.9), .darkGray.opacity(0.7)]),
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
        case "THUNDERSTORM":
            return RadialGradient(
                gradient: Gradient(colors: [.white, .gray.opacity(0.6), .yellow.opacity(0.5), .darkBlue.opacity(0.9)]),
                center: .center,
                startRadius: 150,
                endRadius: 320
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
