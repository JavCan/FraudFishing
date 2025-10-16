//
//  NotificacionDTO.swift
//  Fraud Fishing
//
//  Created by Victor Bosquez on 02/10/25.
//

import Foundation

// MARK: - Request para obtener notificaciones

struct NotificacionesRequest: Codable {
    let userId: String
    let limit: Int?
    let offset: Int?
}

// MARK: - Response de notificaciones

struct NotificacionesResponse: Decodable {
    let notificaciones: [NotificacionResponse]
    let total: Int
    let message: String?
}

struct NotificacionResponse: Decodable, Identifiable {
    let id: String
    let userId: String
    let titulo: String
    let descripcion: String
    let tipo: String
    let icono: String
    let fecha: String
    let leida: Bool
    let createdAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId
        case titulo
        case descripcion
        case tipo
        case icono
        case fecha
        case leida
        case createdAt
    }
}

// MARK: - Request para marcar notificación como leída

struct MarcarNotificacionLeidaRequest: Codable {
    let notificacionId: String
    let leida: Bool
}

// MARK: - Response para marcar como leída

struct MarcarNotificacionLeidaResponse: Decodable {
    let id: String
    let leida: Bool
    let message: String?
}

// MARK: - Request para marcar todas como leídas

struct MarcarTodasLeidasRequest: Codable {
    let userId: String
}

// MARK: - Response para marcar todas como leídas

struct MarcarTodasLeidasResponse: Decodable {
    let actualizadas: Int
    let message: String?
}

// MARK: - Request para eliminar notificación

struct EliminarNotificacionRequest: Codable {
    let notificacionId: String
}

// MARK: - Response para eliminar notificación

struct EliminarNotificacionResponse: Decodable {
    let id: String
    let message: String?
}

// MARK: - Modelo local para la app

struct NotificacionLocal: Identifiable {
    let id: String
    let titulo: String
    let descripcion: String
    let tipo: TipoNotificacion
    let icono: String
    let fecha: String
    var leida: Bool
    
    // Inicializador desde NotificacionResponse
    init(from response: NotificacionResponse) {
        self.id = response.id
        self.titulo = response.titulo
        self.descripcion = response.descripcion
        self.tipo = TipoNotificacion(rawValue: response.tipo.lowercased()) ?? .info
        self.icono = response.icono
        self.fecha = response.fecha
        self.leida = response.leida
    }
}