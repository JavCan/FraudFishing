//
//  HTTPClient.swift
//  TemplateReto415
//
//  Created by Javier Canella Ramos on 02/09/25.
//

import Foundation

struct HTTPClient {
    
    func registerUser(email: String, name:String, password: String) async throws -> Bool{
        
        var returnValue:Bool = false
        let dataRequest = UserRequest(email: email, name: name, password: password)
        let jsonData = try JSONEncoder().encode(dataRequest)
        let url = URL(string: "http://localhost:3000/users")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        let (data, response) = try await URLSession.shared.data(for: request)
        if let httpResponse = response as? HTTPURLResponse,
           httpResponse.statusCode != 201,
           let string = String(data: data, encoding: .utf8) {
            print(string)
            returnValue = true
        }
        return returnValue
    }

    func loginUser(email: String, password: String) async throws -> UserLoginResponse { // Cambiado de username a email
        let loginRequest = UserLoginRequest(email: email, password: password) // Cambiado de username a email
        let jsonData = try JSONEncoder().encode(loginRequest)
        
        let url = URL(string: "http://localhost:3000/auth/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        if httpResponse.statusCode != 201 {
            print("Error de servidor: Código de estado HTTP \(httpResponse.statusCode)")
            if let responseBody = String(data: data, encoding: .utf8) {
                print("Cuerpo de la respuesta: \(responseBody)")
            }
            throw URLError(.badServerResponse) // O un error más específico si lo deseas
        }
        
        let loginResponse = try JSONDecoder().decode(UserLoginResponse.self, from: data)
        return loginResponse
    }
}
