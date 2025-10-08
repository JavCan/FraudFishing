//
//  Fraud_FishingApp.swift
//  Fraud Fishing
//
//  Created by Javier Canella Ramos on 11/09/25.
//

import SwiftUI

@main
struct Fraud_FishingApp: App {
    @State private var isOnboardingFinished = false

    var body: some Scene {
        WindowGroup {
            if isOnboardingFinished {
                ScreenLogin()
                    .environment(\.authenticationController, AuthenticationController(httpClient: HTTPClient()))
            } else {
                ScreenOnboarding(isOnboardingFinished: $isOnboardingFinished)
            }
        }
    }
}
