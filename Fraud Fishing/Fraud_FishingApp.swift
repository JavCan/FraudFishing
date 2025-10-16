import SwiftUI

@main
struct Fraud_FishingApp: App {
    // 1. Crea una única instancia del controlador que vivirá durante toda la app.
    @StateObject private var authController = AuthenticationController(httpClient: HTTPClient())
    @State private var isOnboardingFinished = false

    var body: some Scene {
        WindowGroup {
            if isOnboardingFinished {
                ScreenLogin()
                    // 2. Inyecta el objeto en el entorno para que cualquier vista hija pueda acceder a él.
                    .environmentObject(authController)
            } else {
                ScreenOnboarding(isOnboardingFinished: $isOnboardingFinished)
            }
        }
    }
}
