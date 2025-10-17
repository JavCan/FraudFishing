import Foundation
import Combine

class AuthenticationController: ObservableObject {
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    // MARK: - Registro de Usuario
    @MainActor
    func registerUser(name: String, email: String, password: String) async throws {
        isLoading = true
        errorMessage = nil
        
        let request = UserRegisterRequest(name: name, email: email, password: password)
        
        do {
            try await httpClient.UserRegistration(request)
        } catch {
            self.errorMessage = error.localizedDescription
            throw error
        }
        isLoading = false
    }
    
    // MARK: - Inicio de Sesión de Usuario
    @MainActor
    func loginUser(email: String, password: String) async throws -> Bool {
        isLoading = true
        errorMessage = nil
        
        do {
            let loginResponse = try await httpClient.UserLogin(email: email, password: password)
            
            // Guardamos los tokens de forma segura
            let accessTokenSaved = TokenStorage.set(.access, value: loginResponse.accessToken)
            let refreshTokenSaved = TokenStorage.set(.refresh, value: loginResponse.refreshToken)
            
            isLoading = false
            return accessTokenSaved && refreshTokenSaved
            
        } catch {
            self.errorMessage = error.localizedDescription
            isLoading = false
            throw error // Re-lanzamos el error para que la vista lo capture
        }
    }
    
    func getAccessToken() -> String? {
        TokenStorage.get(.access)
    }
    
    func getRefreshToken() -> String? {
        TokenStorage.get(.refresh)
    }
}
