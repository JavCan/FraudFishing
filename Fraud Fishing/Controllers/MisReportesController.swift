

import Foundation

@MainActor
class ReportesController: ObservableObject {
    @Published var reportesPendientes: [Reporte] = []
    @Published var reportesVerificados: [Reporte] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let httpReport = HTTPReport()
    
    func fetchReportesPendientes() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let responses = try await httpReport.getMyReports(status: 1)
            // Obtener reportes con sus tags
            var reportes: [Reporte] = []
            for response in responses {
                let reporte = await convertToReporteWithTags(response, estado: .pendiente)
                reportes.append(reporte)
            }
            reportesPendientes = reportes
        } catch {
            errorMessage = "Error al cargar reportes: \(error.localizedDescription)"
            print("Error fetching reportes pendientes: \(error)")
        }
        
        isLoading = false
    }
    
    func fetchReportesVerificados() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let responses = try await httpReport.getMyReports(status: 2)
            // Obtener reportes con sus tags
            var reportes: [Reporte] = []
            for response in responses {
                let reporte = await convertToReporteWithTags(response, estado: .verificado)
                reportes.append(reporte)
            }
            reportesVerificados = reportes
        } catch {
            errorMessage = "Error al cargar reportes: \(error.localizedDescription)"
            print("Error fetching reportes verificados: \(error)")
        }
        
        isLoading = false
    }
    
    // Convertir ReportResponse a Reporte con tags del servidor
    private func convertToReporteWithTags(_ response: ReportResponse, estado: EstadoReporte) async -> Reporte {
        // Formatear fechas
        let fechaCreacion = formatearFecha(response.createdAt)
        let fechaVerificacion = estado == .verificado ? formatearFecha(response.updatedAt) : nil
        
        // Obtener tags del servidor
        var hashtags = ""
        do {
            let tags = try await httpReport.getReportTags(reportId: response.id)
            hashtags = tags.map { "#\($0.name)" }.joined(separator: " ")
        } catch {
            print("Error fetching tags for report \(response.id): \(error)")
        }
        
        return Reporte(
            id: String(response.id),
            url: response.url,
            logo: response.imageUrl ?? "",
            descripcion: response.description,
            categoria: getCategoryName(from: response.categoryId),
            hashtags: hashtags,
            estado: estado,
            fechaCreacion: fechaCreacion,
            fechaVerificacion: fechaVerificacion
        )
    }
    
    // Helper para obtener nombre de categoría
    private func getCategoryName(from categoryId: Int) -> String {
        switch categoryId {
        case 1: return "Phishing"
        case 2: return "Malware"
        case 3: return "Scam"
        case 4: return "Noticias Falsas"
        case 5: return "Otro"
        default: return "Desconocido"
        }
    }
    
    // Helper para formatear fechas
    private func formatearFecha(_ isoString: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        guard let date = isoFormatter.date(from: isoString) else {
            return isoString
        }
        
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "dd MMM yyyy"
        displayFormatter.locale = Locale(identifier: "es_ES")
        
        return displayFormatter.string(from: date)
    }
}
