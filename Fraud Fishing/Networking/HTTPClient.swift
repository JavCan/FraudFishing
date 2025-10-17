//
//  HTTPClient.swift
//  Testeo2.0
//
//  Created by Usuario on 06/10/25.
//

import Foundation

struct HTTPClient {
    
    func UserRegistration(_ request: UserRegisterRequest) async throws -> UserLoginResponse {
        guard let url = URL(string: "http://10.48.246.254:3000/users") else {
            throw URLError(.badURL)
    }
        
        var httpRequest = URLRequest(url: url)
        httpRequest.httpMethod = "POST"
        httpRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        httpRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        httpRequest.httpBody = try JSONEncoder().encode(request)
        
        let (data, response) = try await URLSession.shared.data(for: httpRequest)
        guard let http = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard let httpresponse = response as? HTTPURLResponse,
              (200...299).contains(httpresponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        let loginResponse = try JSONDecoder().decode(UserLoginResponse.self, from: data)
        return loginResponse
    }
    
    func UserLogin(email:String, password:String) async throws -> UserLoginResponse {
        let UserLoginRequest = UserLoginRequest(email:email, password:password)
        guard let url = URL(string: "http://10.48.246.254:3000/auth/login") else {
            throw URLError(.badURL)
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try? JSONEncoder().encode(UserLoginRequest)
        
        let (data,response) = try await URLSession.shared.data(for: urlRequest)
        
        // ... (Tu código para imprimir el status y el body, muy útil para debuggear)
        
        guard let httpresponse = response as? HTTPURLResponse,
              (200...299).contains(httpresponse.statusCode) else{
            // Es una buena práctica imprimir el error que viene del backend aquí
            let errorMessage = String(data: data, encoding: .utf8)
            print("Error en el login: \(errorMessage ?? "Sin mensaje")")
            throw URLError(.badServerResponse)
        }
        
        let loginResponse = try JSONDecoder().decode(UserLoginResponse.self, from: data)
        
        return loginResponse
    }
    
    func refreshAccessToken(refreshToken: String) async throws -> String{
        let refreshRequest = RefreshRequest(refreshToken: refreshToken)
        guard let url = URL(string: "http://10.48.246.254:3000/auth/refresh") else {
            throw URLError(.badURL)
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder().encode(refreshRequest)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpresponse = response as? HTTPURLResponse,
              (200...299).contains(httpresponse.statusCode) else{
            throw URLError(.userAuthenticationRequired)
        }
        
        let decoded = try JSONDecoder().decode(RefreshResponse.self, from: data)
        return decoded.accessToken
        
        
    }
    
}
