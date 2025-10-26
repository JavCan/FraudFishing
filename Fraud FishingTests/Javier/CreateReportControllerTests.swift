import Testing
import Foundation
import UIKit
@testable import Fraud_Fishing

// MARK: - Tests de CreateReportController
// NOTA: Asegúrate de que tu servidor esté corriendo antes de ejecutar estos tests
@Suite("Create Report Controller Tests")
struct CreateReportControllerTests {
    
    // MARK: - Authentication Helper
    @MainActor
    private func authenticateUser() async throws {
        let httpClient = HTTPClient()
        let authController = AuthenticationController(httpClient: httpClient)
        
        // Usar las credenciales proporcionadas
        let email = "usuario@example.com"
        let password = "danna123"
        
        let success = try await authController.loginUser(email: email, password: password)
        if !success {
            throw NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "Falló la autenticación para las pruebas"])
        }
    }
    
    // MARK: - Test Data Helpers
    private func createValidReportData() -> (
        reportedURL: String,
        categoryId: Int,
        categoryName: String,
        tags: [String],
        description: String
    ) {
        return (
            reportedURL: "https://sitio-fraudulento-test.com",
            categoryId: 1,
            categoryName: "Phishing",
            tags: ["phishing", "fraude", "test"],
            description: "Este es un sitio web fraudulento utilizado para pruebas unitarias. Contiene elementos sospechosos de phishing."
        )
    }
    
    private func createTestImageData() -> Data? {
        // Crear una imagen de prueba simple
        let size = CGSize(width: 100, height: 100)
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.red.cgColor)
        context?.fill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image?.jpegData(compressionQuality: 0.7)
    }
    
    // MARK: - Success Tests
    
    @Test("Crear reporte exitoso con todos los campos válidos")
    @MainActor
    func testCreateReportSuccess() async throws {
        // Arrange - Autenticar usuario primero
        try await authenticateUser()
        
        let controller = CreateReportController()
        let testData = createValidReportData()
        
        // Verificar estado inicial
        #expect(controller.isSending == false)
        #expect(controller.isSuccess == false)
        #expect(controller.reportError == nil)
        
        // Act
        await controller.sendReport(
            reportedURL: testData.reportedURL,
            categoryId: testData.categoryId,
            categoryName: testData.categoryName,
            tags: testData.tags,
            description: testData.description,
            selectedImageData: nil
        )
        
        // Assert
        #expect(controller.isSending == false)
        #expect(controller.isSuccess == true)
        #expect(controller.reportError == nil)
    }
    
    // MARK: - Validation Error Tests
    
    @Test("Fallar al crear reporte con campo vacío")
    @MainActor
    func testCreateReportFailsWithEmptyURL() async throws {
        // Arrange
        let controller = CreateReportController()
        let testData = createValidReportData()
        
        // Act
        await controller.sendReport(
            reportedURL: "", // URL vacía
            categoryId: testData.categoryId,
            categoryName: testData.categoryName,
            tags: testData.tags,
            description: testData.description,
            selectedImageData: nil
        )
        
        // Assert
        #expect(controller.isSending == false)
        #expect(controller.isSuccess == false)
        #expect(controller.reportError != nil)
        
        if let error = controller.reportError as? CreateReportController.ReportError {
            switch error {
            case .validationFailed(let message):
                #expect(message.contains("campos obligatorios"))
            default:
                Issue.record("Se esperaba un error de validación")
            }
        }
    }
}
