import Foundation

final class HTTPReport {
    private let executor = RequestExecutor()

    func searchReports(byURL urlString: String) async throws -> [ReportResponse] {
        var components = URLComponents(string: "http://localhost:3000/reports")
        components?.queryItems = [
            URLQueryItem(name: "url", value: urlString),
            URLQueryItem(name: "include", value: "tags"),
            URLQueryItem(name: "include", value: "category"),
            URLQueryItem(name: "limit", value: "50")
        ]
        guard let url = components?.url else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let (data, _) = try await executor.send(request, requiresAuth: false)
        return try JSONDecoder().decode([ReportResponse].self, from: data)
    }

    func createReport(reportData: CreateReportRequest) async throws -> ReportResponse {
        guard let url = URL(string: "http://10.48.248.174:3099/reports") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let token = TokenStorage.get(.access) else {
            throw URLError(.userAuthenticationRequired)
        }
        
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = try JSONEncoder().encode(reportData)

        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        if !(200...299).contains(httpResponse.statusCode) {
            if let serverError = try? JSONDecoder().decode(ServerErrorResponse.self, from: data) {
                throw NSError(domain: "ServerError", code: serverError.statusCode, userInfo: [NSLocalizedDescriptionKey: serverError.message])
            } else {
                throw URLError(.badServerResponse, userInfo: [
                    NSLocalizedDescriptionKey: "Solicitud fallida. Código de estado: \(httpResponse.statusCode)",
                    "StatusCode": httpResponse.statusCode
                ])
            }
        }
        
        if httpResponse.statusCode != 201 && httpResponse.statusCode != 200 {
             throw URLError(.badServerResponse, userInfo: [
                NSLocalizedDescriptionKey: "Respuesta de éxito inesperada. Código: \(httpResponse.statusCode). Se esperaba 201 o 200."
             ])
        }

        return try JSONDecoder().decode(ReportResponse.self, from: data)
    }
    
    // MARK: - Obtener reportes del usuario autenticado
    /// Obtiene los reportes del usuario autenticado filtrados por estado
    /// - Parameter status: 1 para pendientes, 2 para verificados
    /// - Returns: Array de reportes
    func getMyReports(status: Int) async throws -> [ReportResponse] {
        // Obtener el userId del token almacenado
        guard let userId = getUserIdFromToken() else {
            throw URLError(.userAuthenticationRequired)
        }
        
        // Construir URL con query parameters
        var components = URLComponents(string: "http://10.48.248.174:3099/reports")
        components?.queryItems = [
            URLQueryItem(name: "status", value: "\(status)"),
            URLQueryItem(name: "userId", value: "\(userId)")
        ]
        
        guard let url = components?.url else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        guard let token = TokenStorage.get(.access) else {
            throw URLError(.userAuthenticationRequired)
        }
        
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        if !(200...299).contains(httpResponse.statusCode) {
            if let serverError = try? JSONDecoder().decode(ServerErrorResponse.self, from: data) {
                throw NSError(domain: "ServerError", code: serverError.statusCode, userInfo: [NSLocalizedDescriptionKey: serverError.message])
            } else {
                throw URLError(.badServerResponse, userInfo: [
                    NSLocalizedDescriptionKey: "Solicitud fallida. Código de estado: \(httpResponse.statusCode)",
                    "StatusCode": httpResponse.statusCode
                ])
            }
        }

        return try JSONDecoder().decode([ReportResponse].self, from: data)
    }
    
    
    // MARK: - Obtener todas las categorías disponibles
    func getCategories() async throws -> [CategoryDTO] {
        guard let url = URL(string: "http://10.48.248.174:3099/categories") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Agregar token si es necesario (depende de tu API)
        if let token = TokenStorage.get(.access) {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        if !(200...299).contains(httpResponse.statusCode) {
            if let serverError = try? JSONDecoder().decode(ServerErrorResponse.self, from: data) {
                throw NSError(domain: "ServerError", code: serverError.statusCode,
                             userInfo: [NSLocalizedDescriptionKey: serverError.message])
            } else {
                throw URLError(.badServerResponse, userInfo: [
                    NSLocalizedDescriptionKey: "Error al obtener categorías. Código: \(httpResponse.statusCode)"
                ])
            }
        }
        
        return try JSONDecoder().decode([CategoryDTO].self, from: data)
    }

    // MARK: - Obtener categoría de un reporte específico
    func getReportCategory(reportId: Int) async throws -> ReportCategoryResponse {
        let url = URL(string: "http://10.48.248.174:3099/reports/\(reportId)/category")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let token = TokenStorage.get(.access) else {
            throw URLError(.userAuthenticationRequired)
        }
        
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard httpResponse.statusCode == 200 else {
            if let serverError = try? JSONDecoder().decode(ServerErrorResponse.self, from: data) {
                throw NSError(domain: "", code: httpResponse.statusCode,
                             userInfo: [NSLocalizedDescriptionKey: serverError.message])
            }
            throw URLError(.badServerResponse)
        }
        
        let categoryResponse = try JSONDecoder().decode(ReportCategoryResponse.self, from: data)
        return categoryResponse
    }
    
    // MARK: - Obtener tags de un reporte específico
    /// Obtiene las tags asociadas a un reporte
    /// - Parameter reportId: ID del reporte
    /// - Returns: Array de tags
    func getReportTags(reportId: Int) async throws -> [TagResponse] {
        guard let url = URL(string: "http://10.48.248.174:3099/reports/\(reportId)/tags") else {
            throw URLError(.badURL)
        }

        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(VoteResponse.self, from: data)
    }
}
