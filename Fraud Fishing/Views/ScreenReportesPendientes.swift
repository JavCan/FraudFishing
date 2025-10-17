//
//  ScreenReportesPendientes.swift
//  Fraud Fishing
//
//  Created by Victor Bosquez on 01/10/25.
//

import SwiftUI

struct ScreenReportesPendientes: View {
    @Environment(\.dismiss) private var dismiss
    
    // Datos de ejemplo - reemplazar con datos reales de API
    @State private var reportesPendientes: [Reporte] = [
        Reporte(
            id: "1",
            url: "https://www.lingscars.com",
            logo: "lingscars_logo",
            descripcion: "Los coches que muestran no son reales.",
            categoria: "Informacion falsa",
            hashtags: "#Coches #Desinformacion",
            estado: .pendiente,
            fechaCreacion: "15 Sep 2025"
        ),
        Reporte(
            id: "2",
            url: "https://www.arngren.net",
            logo: "arngren_logo",
            descripcion: "No se puede comprar nada en esta pagina web, pero te piden tus metodos de pago.",
            categoria: "Envios falsos",
            hashtags: "#Venta #Cobro #Envio",
            estado: .pendiente,
            fechaCreacion: "10 Sep 2025"
        )
    ]
    
    var body: some View {
        ZStack {
            // Fondo con gradiente
            LinearGradient(gradient: Gradient(colors: [
                Color(red: 0.043, green: 0.067, blue: 0.173, opacity: 0.88),
                Color(red: 0.043, green: 0.067, blue: 0.173)]),
                           startPoint: UnitPoint(x:0.5, y:0.1),
                           endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Lista de reportes
                ScrollView {
                    VStack(spacing: 20) {
                        if reportesPendientes.isEmpty {
                            EmptyStateView(
                                icon: "clock.badge.questionmark",
                                message: "No tienes reportes pendientes",
                                description: "Tus reportes aparecerán aquí mientras son revisados"
                            )
                            .padding(.top, 100)
                        } else {
                            ForEach(reportesPendientes) { reporte in
                                NavigationLink(destination: DetalleReporteView(reporte: reporte)) {
                                    ReporteCard(reporte: reporte)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 100)
                }
                
                Spacer()
            }
        }
        .navigationTitle("Reportes Pendientes")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                        Text("Ajustes")
                            .font(.body)
                    }
                    .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                }
            }
        }
    }
}

// MARK: - ScreenReportesVerificados

struct ScreenReportesVerificados: View {
    @Environment(\.dismiss) private var dismiss
    
    // Datos de ejemplo - reemplazar con datos reales de API
    @State private var reportesVerificados: [Reporte] = [
        Reporte(
            id: "3",
            url: "https://www.lingscars.com",
            logo: "lingscars_logo",
            descripcion: "Los coches que muestran no son reales.",
            categoria: "Informacion falsa",
            hashtags: "#Coches #Desinformacion",
            estado: .verificado,
            fechaCreacion: "15 Sep 2025",
            fechaVerificacion: "18 Sep 2025"
        ),
        Reporte(
            id: "4",
            url: "https://www.arngren.net",
            logo: "arngren_logo",
            descripcion: "No se puede comprar nada en esta pagina web, pero te piden tus metodos de pago.",
            categoria: "Envios falsos",
            hashtags: "#Venta #Cobro #Envio",
            estado: .verificado,
            fechaCreacion: "10 Sep 2025",
            fechaVerificacion: "12 Sep 2025"
        )
    ]
    
    var body: some View {
        ZStack {
            // Fondo con gradiente
            LinearGradient(gradient: Gradient(colors: [
                Color(red: 0.043, green: 0.067, blue: 0.173, opacity: 0.88),
                Color(red: 0.043, green: 0.067, blue: 0.173)]),
                           startPoint: UnitPoint(x:0.5, y:0.1),
                           endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Lista de reportes
                ScrollView {
                    VStack(spacing: 20) {
                        if reportesVerificados.isEmpty {
                            EmptyStateView(
                                icon: "checkmark.circle",
                                message: "No tienes reportes verificados",
                                description: "Tus reportes aceptados aparecerán aquí"
                            )
                            .padding(.top, 100)
                        } else {
                            ForEach(reportesVerificados) { reporte in
                                NavigationLink(destination: DetalleReporteView(reporte: reporte)) {
                                    ReporteCard(reporte: reporte)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 100)
                }
                
                Spacer()
            }
        }
        .navigationTitle("Reportes Verificados")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                        Text("Ajustes")
                            .font(.body)
                    }
                    .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                }
            }
        }
    }
}

// MARK: - Modelo de Datos

struct Reporte: Identifiable {
    let id: String
    let url: String
    let logo: String
    let descripcion: String
    let categoria: String
    let hashtags: String
    let estado: EstadoReporte
    let fechaCreacion: String
    var fechaVerificacion: String?
}

enum EstadoReporte {
    case pendiente
    case verificado
}

// MARK: - Componente ReporteCard Mejorado

struct ReporteCard: View {
    let reporte: Reporte
    
    var body: some View {
        VStack(spacing: 0) {
            // Header con badge de estado
            HStack {
                // Fecha de creación
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                    Text(reporte.fechaCreacion)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                // Badge de estado
                HStack(spacing: 6) {
                    Image(systemName: reporte.estado == .pendiente ? "clock.fill" : "checkmark.circle.fill")
                        .font(.system(size: 12))
                    Text(reporte.estado == .pendiente ? "Pendiente" : "Verificado")
                        .font(.system(size: 13, weight: .semibold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 14)
                .padding(.vertical, 6)
                .background(reporte.estado == .pendiente ? 
                           Color(red: 0.0, green: 0.2, blue: 0.4) : 
                           Color.green)
                .cornerRadius(20)
            }
            .padding(.horizontal, 16)
            .padding(.top, 14)
            .padding(.bottom, 10)
            .background(Color.white)
            
            Divider()
                .padding(.horizontal, 16)
            
            // URL del sitio
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Image(systemName: "link.circle.fill")
                        .foregroundColor(Color(red: 0.0, green: 0.6, blue: 0.5))
                        .font(.system(size: 18))
                    
                    Text(reporte.url)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                        .underline()
                        .lineLimit(1)
                }
                .padding(.top, 8)
                
                // Contenido del reporte
                HStack(alignment: .top, spacing: 14) {
                    // Logo/Imagen del sitio
                    RoundedRectangle(cornerRadius: 10)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 0.9, green: 0.9, blue: 0.95),
                                    Color(red: 0.8, green: 0.95, blue: 0.95)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 70, height: 70)
                        .overlay(
                            Image(systemName: "photo.fill")
                                .foregroundColor(Color(red: 0.0, green: 0.6, blue: 0.5).opacity(0.4))
                                .font(.system(size: 24))
                        )
                        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
                    
                    // Descripción
                    VStack(alignment: .leading, spacing: 4) {
                        Text(reporte.descripcion)
                            .font(.system(size: 14))
                            .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                            .lineLimit(3)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                // Categoría y Hashtags
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "tag.fill")
                            .font(.system(size: 11))
                            .foregroundColor(Color(red: 0.0, green: 0.8, blue: 0.7))
                        
                        Text(reporte.categoria)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 5)
                            .background(Color(red: 0.0, green: 0.8, blue: 0.7))
                            .cornerRadius(6)
                    }
                    
                    Text(reporte.hashtags)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(red: 0.0, green: 0.6, blue: 0.5))
                }
                
                // Indicador de "ver más"
                HStack {
                    Spacer()
                    HStack(spacing: 4) {
                        Text("Ver detalles")
                            .font(.system(size: 13, weight: .medium))
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .foregroundColor(Color(red: 0.0, green: 0.6, blue: 0.5))
                }
                .padding(.bottom, 8)
            }
            .padding(.horizontal, 16)
            .background(Color.white)
        }
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Vista de Estado Vacío

struct EmptyStateView: View {
    let icon: String
    let message: String
    let description: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundColor(Color(red: 0.0, green: 0.6, blue: 0.5).opacity(0.6))
            
            Text(message)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
            
            Text(description)
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
}

// MARK: - Vista de Detalle del Reporte

struct DetalleReporteView: View {
    @Environment(\.dismiss) private var dismiss
    let reporte: Reporte
    
    var body: some View {
        ZStack {
            // Fondo con gradiente
            LinearGradient(gradient: Gradient(colors: [
                Color(red: 1, green: 1, blue: 1),
                Color(red: 0.0, green: 0.8, blue: 0.7)]),
                           startPoint: UnitPoint(x:0.5, y:0.7),
                           endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 24) {
                    // Card principal con toda la información
                    VStack(spacing: 0) {
                        // Header con estado
                        HStack {
                            HStack(spacing: 8) {
                                Image(systemName: reporte.estado == .pendiente ? "clock.fill" : "checkmark.circle.fill")
                                    .font(.system(size: 16))
                                Text(reporte.estado == .pendiente ? "En revisión" : "Verificado")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 18)
                            .padding(.vertical, 10)
                            .background(reporte.estado == .pendiente ? 
                                       Color(red: 0.0, green: 0.2, blue: 0.4) : 
                                       Color.green)
                            .cornerRadius(25)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .background(Color.white)
                        
                        // Imagen del sitio
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color(red: 0.9, green: 0.9, blue: 0.95),
                                        Color(red: 0.8, green: 0.95, blue: 0.95)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(height: 180)
                            .overlay(
                                Image(systemName: "photo.fill")
                                    .foregroundColor(Color(red: 0.0, green: 0.6, blue: 0.5).opacity(0.3))
                                    .font(.system(size: 50))
                            )
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                        
                        // URL
                        VStack(alignment: .leading, spacing: 8) {
                            Label("URL reportada", systemImage: "link.circle.fill")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.gray)
                            
                            Text(reporte.url)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                                .underline()
                                .lineLimit(2)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                        
                        Divider()
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                        
                        // Descripción
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Descripción del reporte", systemImage: "doc.text.fill")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.gray)
                            
                            Text(reporte.descripcion)
                                .font(.system(size: 15))
                                .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        
                        Divider()
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                        
                        // Categoría
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Categoría", systemImage: "tag.fill")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.gray)
                            
                            HStack {
                                Text(reporte.categoria)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 7)
                                    .background(Color(red: 0.0, green: 0.8, blue: 0.7))
                                    .cornerRadius(8)
                                
                                Spacer()
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        
                        Divider()
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                        
                        // Hashtags
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Etiquetas", systemImage: "number")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.gray)
                            
                            Text(reporte.hashtags)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color(red: 0.0, green: 0.6, blue: 0.5))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        
                        Divider()
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                        
                        // Fechas
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "calendar.badge.plus")
                                    .foregroundColor(Color(red: 0.0, green: 0.6, blue: 0.5))
                                Text("Fecha de reporte:")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                Spacer()
                                Text(reporte.fechaCreacion)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                            }
                            
                            if let fechaVerificacion = reporte.fechaVerificacion {
                                HStack {
                                    Image(systemName: "calendar.badge.checkmark")
                                        .foregroundColor(.green)
                                    Text("Fecha de verificación:")
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                    Spacer()
                                    Text(fechaVerificacion)
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    }
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
                    .padding(.horizontal, 20)
                }
                .padding(.top, 20)
                .padding(.bottom, 40)
            }
        }
        .navigationTitle("Detalle del Reporte")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                        Text("Volver")
                            .font(.body)
                    }
                    .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                }
            }
        }
    }
}

// MARK: - Preview

#Preview("Reportes Pendientes") {
    NavigationView {
        ScreenReportesPendientes()
    }
}

#Preview("Reportes Verificados") {
    NavigationView {
        ScreenReportesVerificados()
    }
}

#Preview("Detalle Reporte") {
    NavigationView {
        DetalleReporteView(reporte: Reporte(
            id: "1",
            url: "https://www.lingscars.com",
            logo: "lingscars_logo",
            descripcion: "Los coches que muestran no son reales.",
            categoria: "Informacion falsa",
            hashtags: "#Coches #Desinformacion",
            estado: .verificado,
            fechaCreacion: "15 Sep 2025",
            fechaVerificacion: "18 Sep 2025"
        ))
    }
}