import Foundation

class HTTPReport {
    private let executor = RequestExecutor()

    func createReport(reportData: CreateReportRequest) async throws -> ReportResponse {
        guard let url = URL(string: "http://10.48.249.14:3099/reports") else {
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
        var components = URLComponents(string: "http://10.48.249.14:3099/reports")
        components?.queryItems = [
            URLQueryItem(name: "status", value: "\(status)"),
            URLQueryItem(name: "userId", value: "\(userId)")
        ]
        
        guard let url = components?.url else {
            throw URLError(.badURL)
        }

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
    
    // MARK: - Obtener tags de un reporte específico
    /// Obtiene las tags asociadas a un reporte
    /// - Parameter reportId: ID del reporte
    /// - Returns: Array de tags
    func getReportTags(reportId: Int) async throws -> [TagResponse] {
        guard let url = URL(string: "http://10.48.249.14:3099/reports/\(reportId)/tags") else {
            throw URLError(.badURL)
        }

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

        return try JSONDecoder().decode([TagResponse].self, from: data)
    }
    
    // MARK: - Helper para extraer userId del token
    private func getUserIdFromToken() -> Int? {
        guard let token = TokenStorage.get(.access) else {
            return nil
        }
        
        // Decodificar JWT para obtener el userId
        let segments = token.components(separatedBy: ".")
        guard segments.count > 1 else { return nil }
        
        let base64String = segments[1]
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        let padded = base64String.padding(toLength: ((base64String.count + 3) / 4) * 4,
                                          withPad: "=",
                                          startingAt: 0)
        
        guard let data = Data(base64Encoded: padded),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let sub = json["sub"] as? String,
              let userId = Int(sub) else {
            return nil
        }
        
        return userId
    }
}
