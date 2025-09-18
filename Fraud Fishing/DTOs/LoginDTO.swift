//
//  LoginDTO.swift
//  TemplateReto451
//
//  Created by Usuario on 09/09/25.
//

import Foundation

struct UserLoginRequest: Codable {
    let email: String // Cambiado de username a email
    let password: String
}

struct UserLoginResponse: Decodable {
    let accessToken, refreshToken: String
}
