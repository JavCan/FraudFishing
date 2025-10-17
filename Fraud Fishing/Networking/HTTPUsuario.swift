

import Foundation

func myProfile(email: String, name:String, password: String) async throws -> Bool {
    
    let dataRequest = UserRegisterRequest(name: name, email: email, password: password)
    let jsonData = try JSONEncoder().encode(dataRequest)
    
    guard let url = URL(string: "http://10.48.246.254:3000/users") else {
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
    
    // A 201 status code indicates successful user creation.
    if httpResponse.statusCode == 201 {
        return true
    } else {
        // For any other status code, we'll treat it as an error.
        if let errorBody = String(data: data, encoding: .utf8) {
            print("Error en el registro. Código: \(httpResponse.statusCode). Mensaje: \(errorBody)")
        }
        // We throw an error to be caught by the calling function.
        throw URLError(.badServerResponse, userInfo: ["statusCode": httpResponse.statusCode, "data": data])
    }
}
