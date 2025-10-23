//
//  ScreenLoading.swift
//  Fraud Fishing
//
//  Created by Javier Canella Ramos on 28/09/25.
//

import SwiftUI

struct ScreenLoading: View {
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [
                Color(red: 0.043, green: 0.067, blue: 0.173, opacity: 0.88),
                Color(red: 0.043, green: 0.067, blue: 0.173)]),
                           startPoint: .top,
                           endPoint: .bottom)
            .edgesIgnoringSafeArea(.all)
            VStack(spacing: 20) {
                // Logo
                Image("LogoBlanco")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 500, height: 360)
                    .padding(.bottom, 100)
            }
        }
        
    }
}

#Preview {
    ScreenLoading()
}
