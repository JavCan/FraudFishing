import Testing
import Foundation
@testable import Fraud_Fishing

@Suite("Authentication Controller Register Tests")
struct AuthenticationControllerRegisterTests {
    
    @Test("Registro exitoso con datos válidos")
    @MainActor
    func testRegisterSuccess() async throws {
        // Arrange
        let httpClient = HTTPClient()
        let controller = AuthenticationController(httpClient: httpClient)
        
        let name = "Juan Pérez"
        let email = "jun.perz@example.com"
        let password = "Password1!"
        
        // Validación previa de formato (opcional, pero útil)
        let emailValid = NSPredicate(
            format: "SELF MATCHES %@",
            "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        ).evaluate(with: email)
        
        let passwordValid = NSPredicate(
            format: "SELF MATCHES %@",
            "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[!@#$%^&*()_+\\-={}:;<>?]).{7,}$"
        ).evaluate(with: password)
        
        #expect(emailValid)
        #expect(passwordValid)
        
        // Act & Assert
        try await controller.registerUser(name: name, email: email, password: password)
        
        // No se lanza error => éxito
        #expect(controller.errorMessage == nil)
        #expect(controller.isLoading == false)
    }
    
    @Test("Registro fallido con correo inválido")
    @MainActor
    func testRegisterInvalidEmail() async throws {
        let httpClient = HTTPClient()
        let controller = AuthenticationController(httpClient: httpClient)
        
        let name = "Ana"
        let email = "correo_invalido"
        let password = "Password1!"
        
        // Act & Assert
        await #expect(throws: Error.self) {
            try await controller.registerUser(name: name, email: email, password: password)
        }
        
        #expect(controller.errorMessage != nil)
        #expect(controller.isLoading == false)
    }
    
    @Test("Registro fallido con contraseña débil")
    @MainActor
    func testRegisterWeakPassword() async throws {
        let httpClient = HTTPClient()
        let controller = AuthenticationController(httpClient: httpClient)
        
        let name = "Carlos"
        let email = "carlos@example.com"
        let password = "abc123"
        
        // Act & Assert
        await #expect(throws: Error.self) {
            try await controller.registerUser(name: name, email: email, password: password)
        }
        
        #expect(controller.errorMessage != nil)
        #expect(controller.isLoading == false)
    }
}
