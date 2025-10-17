//
//  NotificacionController.swift
//  Fraud Fishing
//
//  Created by Usuario on 15/10/25.
//
import Foundation

@MainActor
final class NotificacionesController: ObservableObject {
    @Published var notificaciones: [NotificacionDTO] = []
    @Published var notificacionesAgrupadas: [(date: Date, items: [NotificacionDTO])] = []
    @Published var isLoading = false
    
    private let client = HTTPClient()
    
    func cargarNotificaciones(userId: Int) async {
        isLoading = true
        do {
            let result = try await client.fetchNotificaciones(userId: userId)
            self.notificaciones = result
            self.notificacionesAgrupadas = agruparPorFecha(result)
        } catch {
            print("❌ Error al obtener notificaciones: \(error.localizedDescription)")
            self.notificaciones = []
            self.notificacionesAgrupadas = []
        }
        isLoading = false
    }
    
    private func agruparPorFecha(_ items: [NotificacionDTO]) -> [(Date, [NotificacionDTO])] {
        let grouped = Dictionary(grouping: items) { Calendar.current.startOfDay(for: $0.createdAt) }
        return grouped
            .map { ($0.key, $0.value) }
            .sorted { $0.0 > $1.0 } // Orden descendente (hoy primero)
    }
}
