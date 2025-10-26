import Testing
import Foundation
@testable import Fraud_Fishing // Reemplaza con el nombre de tu módulo

// MARK: - Tests de Integración
// NOTA: Asegúrate de que tu servidor esté corriendo en http://localhost:3000
// antes de ejecutar estos tests
@Suite("Authentication Controller Login Tests")
struct AuthenticationControllerTests {
    
    @Test("Login exitoso con credenciales correctas")
    @MainActor
    func testLoginSuccess() async throws {
        // Arrange
        let httpClient = HTTPClient()
        let controller = AuthenticationController(httpClient: httpClient)
        
        // IMPORTANTE: Usa credenciales que existan en tu base de datos
        let email = "d@gmail.com"
        let password = "danna123"
        
        // Act
        let result = try await controller.loginUser(email: email, password: password)
        
        // Assert
        #expect(result == true)
        #expect(controller.currentUser != nil)
        #expect(controller.currentUser?.email == email)
        #expect(controller.errorMessage == nil)
        #expect(controller.isLoading == false)
    }
    
    @Test("Login fallido con credenciales incorrectas")
    @MainActor
    func testLoginFailure() async throws {
        // Arrange
        let httpClient = HTTPClient()
        let controller = AuthenticationController(httpClient: httpClient)
        
        // Credenciales que NO existen en tu base de datos
        let email = "usuario_no_existe@example.com"
        let password = "password_incorrecto"
        
        // Act & Assert
        await #expect(throws: Error.self) {
            try await controller.loginUser(email: email, password: password)
        }
        
        #expect(controller.errorMessage != nil)
        #expect(controller.currentUser == nil)
        #expect(controller.isLoading == false)
    }
}
