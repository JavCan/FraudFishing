import Testing
import Foundation
@testable import Fraud_Fishing

@Suite("User Profile Controller Update Tests")
struct UserProfileControllerUpdateTests {
    
    @Test("Actualizar nombre correctamente")
    @MainActor
    func testUpdateNameSuccess() async throws {
        let controller = UserProfileController()
        let result = await controller.updateName("Carlos Mendoza")
        
        #expect(result == true)
        #expect(controller.errorMessage == nil)
        #expect(controller.isLoading == false)
    }
    
    @Test("Falla al actualizar con nombre vacío")
    @MainActor
    func testUpdateNameEmpty() async throws {
        let controller = UserProfileController()
        let result = await controller.updateName("")
        
        #expect(result == false)
        #expect(controller.errorMessage == "El nombre no puede estar vacío.")
        #expect(controller.isLoading == false)
    }
    
    @Test("Actualizar correo con formato válido")
    @MainActor
    func testUpdateEmailSuccess() async throws {
        let controller = UserProfileController()
        let result = await controller.updateEmail("usuario@example.com")
        
        #expect(result == true)
        #expect(controller.errorMessage == nil)
    }
    
    @Test("Falla con formato de correo inválido")
    @MainActor
    func testUpdateEmailInvalidFormat() async throws {
        let controller = UserProfileController()
        let result = await controller.updateEmail("correo_invalido")
        
        #expect(result == false)
        #expect(controller.errorMessage == "El formato del correo no es válido.")
    }
    
    @Test("Actualizar contraseña correctamente")
    @MainActor
    func testUpdatePasswordSuccess() async throws {
        let controller = UserProfileController()
        let result = await controller.updatePassword(newPassword: "NuevaPass1!", confirmation: "NuevaPass1!")
        
        #expect(result == true)
        #expect(controller.errorMessage == nil)
    }
    
    @Test("Falla al actualizar contraseña vacía")
    @MainActor
    func testUpdatePasswordEmpty() async throws {
        let controller = UserProfileController()
        let result = await controller.updatePassword(newPassword: "", confirmation: "")
        
        #expect(result == false)
        #expect(controller.errorMessage == "La contraseña no puede estar vacía.")
    }
    
    @Test("Falla al no coincidir contraseñas")
    @MainActor
    func testUpdatePasswordMismatch() async throws {
        let controller = UserProfileController()
        let result = await controller.updatePassword(newPassword: "NuevaPass1!", confirmation: "OtraPass1!")
        
        #expect(result == false)
        #expect(controller.errorMessage == "Las contraseñas no coinciden.")
    }
}
