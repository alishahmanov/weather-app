//
//  CityMenuView.swift
//  WeatherApp
//
//  Created by Alihan on 29.06.2025.
//


import SwiftUI

struct CityMenuView: View {
    @Binding var city: String
    @Binding var isPresented: Bool
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(radius: 10)
            VStack {
                Button {
                    city = "Almaty"
                } label: {
                    Text("Almaty")
                        .foregroundColor(.black)
                        .fontWeight(.medium)
                }
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray)
                Button {
                    city = "Astana"
                } label: {
                    Text("Astana")
                        .foregroundColor(.black)
                        .fontWeight(.medium)
                }
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray)
                Button {
                    city = "Pavlodar"
                } label: {
                    Text("Pavlodar")
                        .foregroundColor(.black)
                        .fontWeight(.medium)
                }
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray)
                Button("Other...") {
                    withAnimation {
                        isPresented = true
                        city = ""
                    }
                }
                .foregroundColor(.black)
                .fontWeight(.medium)
            }
            if isPresented {
                InputCity(city: $city, isPresented: $isPresented)
                    .frame(width: 300, height: 200)
                    .cornerRadius(16)
            }
        }
        .frame(width: 150, height: 160)
    }
}

#Preview {
    MainScreen()
}

