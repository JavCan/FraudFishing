//
//  Fraud_FishingApp.swift
//  Fraud Fishing
//
//  Created by Javier Canella Ramos on 11/09/25.
//

import SwiftUI

@main
struct Fraud_FishingApp: App {
    var body: some Scene {
        WindowGroup {
            ScreenLogin()
                .environment(\.authenticationController, AuthenticationController(httpClient: HTTPClient())) // Proporciona la instancia aquí
        }
    }
}
