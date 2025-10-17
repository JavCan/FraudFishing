//
//  NotificacionDTO.swift
//  Fraud Fishing
//
//  Created by Usuario on 15/10/25.
//

import Foundation

struct NotificacionDTO: Decodable, Identifiable {
    let id: Int                 // ID de la notificación
    let title: String           // Título del aviso
    let message: String         // Texto descriptivo del mensaje
    let relatedId: Int          // ID del elemento relacionado (ej: reporte)
    let isRead: Bool            // Indica si la notificación ya fue leída
    let createdAt: Date         // Fecha de creación (formato ISO8601)
    let updatedAt: Date         // Fecha de última actualización (formato ISO8601)
}

