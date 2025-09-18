//
//  AuthenticationController.swift
//  TemplateReto415
//
//  Created by Javier Canella Ramos on 02/09/25.
//

import Foundation
import SwiftUI // Importar SwiftUI para EnvironmentKey

struct AuthenticationController {
    let httpClient: HTTPClient
    
    /*func registerUser(name: String,email: String, password: String) async throws -> Bool{
        let registrationResponse = try await httpClient.registerUser(email: email, name: name, password: password)
        
        return registrationResponse
    }*/

    func loginUser(email: String, password: String) async throws -> UserLoginResponse {
        let loginResponse = try await httpClient.loginUser(email: email, password: password)
        return loginResponse
    }
}

// MARK: - EnvironmentKey para AuthenticationController
private struct AuthenticationControllerKey: EnvironmentKey {
    static let defaultValue: AuthenticationController = AuthenticationController(httpClient: HTTPClient())
}

// MARK: - Extensión de EnvironmentValues para acceder al AuthenticationController
extension EnvironmentValues {
    var authenticationController: AuthenticationController {
        get { self[AuthenticationControllerKey.self] }
        set { self[AuthenticationControllerKey.self] = newValue }
    }
}
