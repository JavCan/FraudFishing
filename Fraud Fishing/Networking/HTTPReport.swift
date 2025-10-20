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
        guard let url = URL(string: "http://localhost:3000/reports") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let token = TokenStorage.get(.access) else {
            throw URLError(.userAuthenticationRequired)
        }
        
        // Adjuntar el token al encabezado Authorization
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        request.httpBody = try JSONEncoder().encode(reportData)

        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            // No es una respuesta HTTP (error de red bajo nivel)
            throw URLError(.badServerResponse)
        }

        // Si el código de estado NO es 2xx (200-299), decodificamos el error del servidor.
        if !(200...299).contains(httpResponse.statusCode) {
            // Intentamos decodificar el cuerpo de la respuesta como un error de servidor
            if let serverError = try? JSONDecoder().decode(ServerErrorResponse.self, from: data) {
                // Lanzamos un error más descriptivo
                throw NSError(domain: "ServerError", code: serverError.statusCode, userInfo: [NSLocalizedDescriptionKey: serverError.message])
            } else {
                // Si no se puede decodificar, lanzamos el error original con el código de estado
                throw URLError(.badServerResponse, userInfo: [
                    NSLocalizedDescriptionKey: "Solicitud fallida. Código de estado: \(httpResponse.statusCode)",
                    "StatusCode": httpResponse.statusCode
                ])
            }
        }
        
        // Verificamos el código de estado de éxito esperado (201). 
        // Si el servidor devuelve 200/202 en su lugar, esto seguirá siendo válido por el bloque 'if' anterior.
        // Mantenemos esta verificación si el DTO de éxito solo se espera con 201.
        if httpResponse.statusCode != 201 && httpResponse.statusCode != 200 {
             // Si quieres forzar que SÓLO 201 o 200 sea considerado un éxito, usa este guard.
             throw URLError(.badServerResponse, userInfo: [
                NSLocalizedDescriptionKey: "Respuesta de éxito inesperada. Código: \(httpResponse.statusCode). Se esperaba 201 o 200."
             ])
        }

        // Si llegamos aquí, la respuesta fue 201 o 200 (éxito)
        return try JSONDecoder().decode(ReportResponse.self, from: data)
    }
    // Agrega voto a un reporte (PUT /reports/{id}/vote)
    func voteReport(reportId: Int) async throws -> VoteResponse {
        let urlString = "http://localhost:3000/reports/\(reportId)/vote"
        guard let url = URL(string: urlString) else {
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

        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(VoteResponse.self, from: data)
    }
}
