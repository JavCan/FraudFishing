import Foundation
import Combine

class AuthenticationController: ObservableObject {
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    // MARK: - Registro de Usuario (Corregido)
    @MainActor
    func registerUser(name: String, email: String, password: String) async throws {
        isLoading = true
        errorMessage = nil
        
        // defer garantiza que isLoading se apague sin importar cómo termine la función.
        defer { isLoading = false }
        
        let request = UserRegisterRequest(name: name, email: email, password: password)
        
        do {
            // Esta función no devuelve nada, solo puede lanzar un error.
            try await httpClient.UserRegistration(request)
            // Si no hubo error, el registro fue exitoso.
        } catch {
            // Si hubo un error de red o de status code, lo capturamos.
            self.errorMessage = error.localizedDescription
            print("🛑 ERROR en registerUser: \(error)")
            throw error // Lo volvemos a lanzar para que la vista muestre la alerta.
        }
    }
    
    // MARK: - Inicio de Sesión de Usuario (Corregido)
    @MainActor
    func loginUser(email: String, password: String) async throws -> Bool {
        isLoading = true
        errorMessage = nil
        
        // Usamos defer aquí también para consistencia y seguridad.
        defer { isLoading = false }
        
        do {
            let loginResponse = try await httpClient.UserLogin(email: email, password: password)
            
            // Guardamos los tokens de forma segura
            let accessTokenSaved = TokenStorage.set(.access, value: loginResponse.accessToken)
            let refreshTokenSaved = TokenStorage.set(.refresh, value: loginResponse.refreshToken)
            
            return accessTokenSaved && refreshTokenSaved
            
        } catch {
            self.errorMessage = error.localizedDescription
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
