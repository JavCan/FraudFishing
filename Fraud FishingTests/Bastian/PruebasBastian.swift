import Testing
import Foundation
@testable import Fraud_Fishing

@Suite("Report Controller Search Tests")
struct ReportControllerSearchTests {
    
    @Test("Búsqueda exitosa de reportes por URL válida")
    @MainActor
    func testSearchReportsSuccess() async throws {
        // Arrange
        let controller = ReportController()
        let urlToSearch = "https://localhost.com"
        
        // Act
        let reports = try await controller.searchReports(byURL: urlToSearch)
        
        // Assert
        #expect(!reports.isEmpty)
        #expect(reports.first?.url.contains("localhost.com") == true)
    }
    
    func testSearchReportsInvalidURL() async throws {
        // Arrange
        let controller = ReportController()
        let invalidURL = "not_a_valid_url"
        
        // Act
        let results = try await controller.searchReports(byURL: invalidURL)
        
        // Assert
        #expect(results.isEmpty)
        #expect(results.count == 0)
    }
}
