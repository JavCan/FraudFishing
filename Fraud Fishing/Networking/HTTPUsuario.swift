

import Foundation

func myProfile(email: String, name:String, password: String) async throws -> Bool {
    
    let dataRequest = UserRegisterRequest(name: name, email: email, password: password)
    let jsonData = try JSONEncoder().encode(dataRequest)
    
    guard let url = URL(string: "http://localhost:3000/users") else {
        throw URLError(.badURL)
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = jsonData
    
    let (data, response) = try await URLSession.shared.data(for: request)
    
    guard let httpResponse = response as? HTTPURLResponse else {
        throw URLError(.badServerResponse)
    }
    
    // MARK: - Update User Profile
    func updateUserProfile(name: String?, email: String?, password: String?) async throws -> UserProfile {
        
        guard let url = URL(string: "http://10.48.248.216:3099/users/me") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT" //  método PUT para actualizar
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // --- Autenticación (igual que en GET) ---
        guard let token = TokenStorage.get(.access) else {
            throw URLError(.userAuthenticationRequired)
        }
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        // --- Construcción del Cuerpo Opcional ---
        // 1. Creamos el DTO con los valores que recibimos.
        let updateData = UpdateUserDTO(name: name, email: email, password: password)
        
        // 2. Codificamos el DTO. JSONEncoder omitirá las propiedades 'nil'.
        request.httpBody = try JSONEncoder().encode(updateData)
        
        // Imprimimos para depurar y ver qué se envía exactamente.
        if let jsonString = String(data: request.httpBody!, encoding: .utf8) {
            print("➡️ ENVIANDO PUT a /users/me:")
            print(jsonString)
        }

        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            print("❌ Error: No se pudo actualizar el perfil. Status: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
            if let body = String(data: data, encoding: .utf8) { print("Error Body: \(body)") }
            throw URLError(.badServerResponse)
        }
        
        // Decodificamos la respuesta (el perfil actualizado)
        let updatedProfile = try JSONDecoder().decode(UserProfile.self, from: data)
        print("✅ Perfil actualizado con éxito: \(updatedProfile.name)")
        return updatedProfile
    }
}

