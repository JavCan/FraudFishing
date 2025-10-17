import Foundation
import UIKit
import SwiftUI // Necesario para el tipo Color/ObservableObject

class CreateReportController: ObservableObject {
    // Dependencia del servicio HTTP
    private let httpReport = HTTPReport()

    // MARK: - Published Properties: Notifican a la vista sobre cambios
    @Published var isSending = false
    @Published var reportError: Error?
    @Published var isSuccess = false

    // MARK: - Image Upload Placeholder
    // Simula la subida de una imagen (en una app real, esto subiría a AWS S3, Firebase, etc.)
    private func uploadImageAndGetURL(imageData: Data?) async throws -> String? {
        guard let data = imageData else { return nil }

        // 1. Convert Data to UIImage para compresión (si es necesario)
        guard let uiImage = UIImage(data: data) else {
            throw ReportError.imageProcessingFailed
        }

        // 2. Comprimir imagen (ejemplo: a JPEG con 70% de calidad)
        // Esto reduce el tamaño y el tiempo de subida en un entorno real.
        guard let compressedData = uiImage.jpegData(compressionQuality: 0.7) else {
            throw ReportError.imageProcessingFailed
        }

        // --- Lógica de Subida Simulada ---
        print("Simulando subida de imagen de \(data.count) bytes a \(compressedData.count) bytes (comprimido)...")
        // Simular un retraso de red
        try await Task.sleep(nanoseconds: 1_000_000_000)

        // Devolver un URL temporal como si la subida hubiese tenido éxito
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
        // Actualizar estado en el hilo principal
        DispatchQueue.main.async {
            self.isSending = true
            self.reportError = nil
            self.isSuccess = false
        }

        do {
            // 1. Validar campos obligatorios
            guard !reportedURL.isEmpty, !category.isEmpty, !description.isEmpty else {
                throw ReportError.validationFailed(message: "Faltan campos obligatorios (URL, Categoría, Descripción).")
            }
            
            // 2. Mapear String de Categoría a ID (usando la extensión en ReportDTO)
            guard let categoryId = category.toCategoryId() else {
                throw ReportError.validationFailed(message: "Categoría no válida.")
            }
            
            // 3. Subir Imagen (si existe)
            let imageUrl = try await uploadImageAndGetURL(imageData: selectedImageData)

            // 4. Crear DTO de Petición
            let reportRequest = CreateReportRequest(
                categoryId: categoryId,
                title: category, // Usamos la categoría como título por simplicidad
                description: description,
                url: reportedURL,
                tagNames: tags,
                imageUrl: imageUrl
            )

            // 5. Enviar Reporte
            let response = try await httpReport.createReport(reportData: reportRequest)

            // 6. Manejar Éxito
            print("Reporte enviado con éxito. ID: \(response.id)")
            DispatchQueue.main.async {
                self.isSuccess = true
            }

        } catch {
            // 7. Manejar Error
            print("Error al enviar reporte: \(error)")
            DispatchQueue.main.async {
                self.reportError = error
            }
        }
        
        // 8. Finalizar estado de envío
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
