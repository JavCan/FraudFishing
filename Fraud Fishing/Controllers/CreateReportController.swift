import Foundation
import UIKit // Necesario para la compresión de UIImage
import SwiftUI // Necesario para el tipo Color

class CreateReportController: ObservableObject {
    private let httpReport = HTTPReport()

    // MARK: - Published Properties
    @Published var isSending = false
    @Published var reportError: Error?
    @Published var isSuccess = false

    // MARK: - Image Upload Placeholder
    private func uploadImageAndGetURL(imageData: Data?) async throws -> String? {
        guard let data = imageData else { return nil }

        // 1. Convert Data to UIImage for potential compression
        guard let uiImage = UIImage(data: data) else {
            throw ReportError.imageProcessingFailed
        }

        // 2. Compress image (e.g., to JPEG with 70% quality)
        guard let compressedData = uiImage.jpegData(compressionQuality: 0.7) else {
            throw ReportError.imageProcessingFailed
        }

        // --- Simulated Upload Logic (Replace with actual API call) ---
        print("Simulando subida de imagen de \(data.count) bytes a \(compressedData.count) bytes (comprimido)...")
        try await Task.sleep(nanoseconds: 1_000_000_000) // Simulate network delay

        return "https://report-images.com/\(UUID().uuidString).jpg"
    }

    // MARK: - Public API
    func sendReport(
        reportedURL: String,
        category: String,
        tags: [String],
        description: String,
        selectedImageData: Data?
    ) async {
        DispatchQueue.main.async {
            self.isSending = true
            self.reportError = nil
            self.isSuccess = false
        }

        do {
            // 1. Validate required fields
            guard !reportedURL.isEmpty, !category.isEmpty, !description.isEmpty else {
                throw ReportError.validationFailed(message: "Faltan campos obligatorios (URL, Categoría, Descripción).")
            }
            
            // 2. Map Category String to ID (CORREGIDO: Ahora el método existe gracias a la extensión)
            guard let categoryId = category.toCategoryId() else {
                throw ReportError.validationFailed(message: "Categoría no válida.")
            }
            
            // 3. Handle Image Upload
            let imageUrl = try await uploadImageAndGetURL(imageData: selectedImageData)

            // 4. Create DTO
            let reportRequest = CreateReportRequest(
                categoryId: categoryId,
                title: category, // Using category as title for simplicity
                description: description,
                url: reportedURL,
                tagNames: tags,
                imageUrl: imageUrl
            )

            // 5. Send Report
            let response = try await httpReport.createReport(reportData: reportRequest) // 'response' ya está en scope

            // 6. Handle Success
            print("Reporte enviado con éxito. ID: \(response.id)")
            DispatchQueue.main.async {
                self.isSuccess = true
            }

        } catch {
            // 7. Handle Error
            print("Error al enviar reporte: \(error)")
            DispatchQueue.main.async {
                self.reportError = error
            }
        }
        
        DispatchQueue.main.async {
            self.isSending = false
        }
    }
}

// MARK: - Error Handling
enum ReportError: LocalizedError {
    case validationFailed(message: String)
    case imageProcessingFailed
    
    var errorDescription: String? {
        switch self {
        case .validationFailed(let message):
            return message
        case .imageProcessingFailed:
            return "Error al procesar la imagen para subir."
        }
    }
}
