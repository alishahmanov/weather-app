//
//  InputCity.swift
//  WeatherApp
//
//  Created by Alihan on 30.06.2025.
//


import SwiftUI

struct InputCity: View {
    @Binding var city: String
    @Binding var isPresented: Bool
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        isPresented = false
                    }
                }
            
            VStack(spacing: 16) {
                Text("Enter the city name")
                    .font(.headline)
                
                TextField("Your text...", text: $city)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                Button("OK") {
                    withAnimation {
                        isPresented = false
                        if city == "" {
                            city = "Astana"
                        }
                    }
                }
            }
            .frame(width: 300, height: 200)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(radius: 10)
            .transition(.scale)
            
        }
    }
}
