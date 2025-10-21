//
//  HTTPNoti.swift
//  Fraud Fishing
//
//  Created by Usuario on 15/10/25.
//

import Foundation



extension HTTPClient {
    
    func fetchNotificaciones(userId: Int) async throws -> [NotificacionDTO] {
        
        let urlString = "http://localhost:3000/notificaciones/user/\(userId)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        guard http.statusCode == 200 else {
            if let body = String(data: data, encoding: .utf8) {
                print("GET notificaciones falló [\(http.statusCode)]: \(body)")
            }
            throw URLError(.badServerResponse)
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let notificaciones = try decoder.decode([NotificacionDTO].self, from: data)
        print("Notificaciones cargadas: \(notificaciones.count)")
        return notificaciones
    }
}
