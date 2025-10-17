//
//  ScreenReportesPendientes.swift
//  Fraud Fishing
//
//  Created by Victor Bosquez on 01/10/25.
//

import SwiftUI

struct ScreenReportesPendientes: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var reportesPendientes: [Reporte] = [
        Reporte(
            id: "1",
            url: "https://www.lingscars.com",
            logo: "lingscars_logo",
            descripcion: "Los coches que muestran no son reales.",
            categoria: "Información falsa",
            hashtags: "#Coches #Desinformacion",
            estado: .pendiente,
            fechaCreacion: "15 Sep 2025"
        ),
        Reporte(
            id: "2",
            url: "https://www.arngren.net",
            logo: "arngren_logo",
            descripcion: "No se puede comprar nada en esta página web, pero te piden tus métodos de pago.",
            categoria: "Envíos falsos",
            hashtags: "#Venta #Cobro #Envio",
            estado: .pendiente,
            fechaCreacion: "10 Sep 2025"
        )
    ]
    
    var body: some View {
        ZStack {
            // 🔹 Fondo azul oscuro degradado
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.043, green: 0.067, blue: 0.173, opacity: 0.88),
                    Color(red: 0.043, green: 0.067, blue: 0.173)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Lista de reportes
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        if reportesPendientes.isEmpty {
                            EmptyStateView(
                                icon: "clock.badge.questionmark",
                                message: "No tienes reportes pendientes",
                                description: "Tus reportes aparecerán aquí mientras son revisados"
                            )
                            .padding(.top, 120)
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
            }
        }
        .navigationTitle("Reportes Pendientes")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                        Text("Ajustes")
                            .font(.poppinsRegular(size: 18))
                    }
                    .foregroundColor(.white)
                }
            }
        }
        .toolbarBackground(Color(red: 0.043, green: 0.067, blue: 0.173), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

// MARK: - ScreenReportesVerificados

struct ScreenReportesVerificados: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var reportesVerificados: [Reporte] = [
        Reporte(
            id: "3",
            url: "https://www.lingscars.com",
            logo: "lingscars_logo",
            descripcion: "Los coches que muestran no son reales.",
            categoria: "Información falsa",
            hashtags: "#Coches #Desinformacion",
            estado: .verificado,
            fechaCreacion: "15 Sep 2025",
            fechaVerificacion: "18 Sep 2025"
        ),
        Reporte(
            id: "4",
            url: "https://www.arngren.net",
            logo: "arngren_logo",
            descripcion: "No se puede comprar nada en esta página web, pero te piden tus métodos de pago.",
            categoria: "Envíos falsos",
            hashtags: "#Venta #Cobro #Envio",
            estado: .verificado,
            fechaCreacion: "10 Sep 2025",
            fechaVerificacion: "12 Sep 2025"
        )
    ]
    
    var body: some View {
        ZStack {
            // 🔹 Fondo azul oscuro degradado (coherente con todo el proyecto)
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.043, green: 0.067, blue: 0.173, opacity: 0.88),
                    Color(red: 0.043, green: 0.067, blue: 0.173)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Lista de reportes
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        if reportesVerificados.isEmpty {
                            EmptyStateView(
                                icon: "checkmark.circle",
                                message: "No tienes reportes verificados",
                                description: "Tus reportes aceptados aparecerán aquí"
                            )
                            .padding(.top, 120)
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
            }
        }
        .navigationTitle("Reportes Verificados")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                        Text("Ajustes")
                            .font(.poppinsRegular(size: 18))
                    }
                    .foregroundColor(.white)
                }
            }
        }
        .toolbarBackground(Color(red: 0.043, green: 0.067, blue: 0.173), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
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
        VStack(alignment: .leading, spacing: 12) {
            // MARK: - Header (fecha + estado)
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.7))
                    Text(reporte.fechaCreacion)
                        .font(.poppinsRegular(size: 12))
                        .foregroundColor(.white.opacity(0.7))
                }
                Spacer()
                
                // Badge de estado
                HStack(spacing: 6) {
                    Image(systemName: reporte.estado == .pendiente ? "clock.fill" : "checkmark.circle.fill")
                        .font(.system(size: 12))
                    Text(reporte.estado == .pendiente ? "Pendiente" : "Verificado")
                        .font(.poppinsSemiBold(size: 13))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 5)
                .background(
                    reporte.estado == .pendiente
                    ? Color.yellow
                    : Color.green.opacity(0.4)
                )
                .cornerRadius(20)
            }
            
            // MARK: - URL
            HStack {
                Image(systemName: "link.circle.fill")
                    .foregroundColor(.teal)
                    .font(.system(size: 18))
                Text(reporte.url)
                    .font(.poppinsSemiBold(size: 15))
                    .foregroundColor(.white)
                    .underline()
                    .lineLimit(1)
            }
            
            // MARK: - Contenido del reporte
            HStack(alignment: .top, spacing: 14) {
                // Imagen o logo
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white.opacity(0.08))
                    .frame(width: 70, height: 70)
                    .overlay(
                        Image(systemName: "photo.fill")
                            .foregroundColor(.white.opacity(0.3))
                            .font(.system(size: 24))
                    )
                    .shadow(color: .black.opacity(0.15), radius: 3, x: 0, y: 2)
                
                // Descripción
                Text(reporte.descripcion)
                    .font(.poppinsRegular(size: 14))
                    .foregroundColor(.white.opacity(0.9))
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            // MARK: - Categoría y hashtags
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Image(systemName: "tag.fill")
                        .font(.system(size: 11))
                        .foregroundColor(.teal)
                    
                    Text(reporte.categoria)
                        .font(.poppinsSemiBold(size: 12))
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.teal.opacity(0.4))
                        .cornerRadius(6)
                }
                
                Text(reporte.hashtags)
                    .font(.poppinsRegular(size: 12))
                    .foregroundColor(.teal.opacity(0.8))
            }
            
            // MARK: - Ver detalles
            HStack {
                Spacer()
                HStack(spacing: 4) {
                    Text("Ver detalles")
                        .font(.poppinsMedium(size: 13))
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                }
                .foregroundColor(.teal)
            }
        }
        .padding(16)
        .background(Color.white.opacity(0.08))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.25), radius: 8, x: 0, y: 4)
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
            // 🔹 Fondo azul oscuro degradado (coherente con toda la app)
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.043, green: 0.067, blue: 0.173, opacity: 0.88),
                    Color(red: 0.043, green: 0.067, blue: 0.173)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // MARK: - Header con estado
                    HStack {
                        HStack(spacing: 8) {
                            Image(systemName: reporte.estado == .pendiente ? "clock.fill" : "checkmark.circle.fill")
                                .font(.system(size: 16))
                            Text(reporte.estado == .pendiente ? "En revisión" : "Verificado")
                                .font(.poppinsSemiBold(size: 16))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 10)
                        .background(
                            reporte.estado == .pendiente
                            ? Color.yellow.opacity(0.3)
                            : Color.green.opacity(0.4)
                        )
                        .cornerRadius(25)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    // MARK: - Imagen del sitio
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.08))
                        .frame(height: 180)
                        .overlay(
                            Image(systemName: "photo.fill")
                                .foregroundColor(.white.opacity(0.3))
                                .font(.system(size: 50))
                        )
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                    
                    // MARK: - URL
                    InfoSection(
                        icon: "link.circle.fill",
                        title: "URL reportada",
                        content: reporte.url,
                        accentColor: .teal
                    )
                    
                    Divider().background(.white.opacity(0.2))
                        .padding(.horizontal, 20)
                    
                    // MARK: - Descripción
                    InfoSection(
                        icon: "doc.text.fill",
                        title: "Descripción del reporte",
                        content: reporte.descripcion,
                        accentColor: .white.opacity(0.9)
                    )
                    
                    Divider().background(.white.opacity(0.2))
                        .padding(.horizontal, 20)
                    
                    // MARK: - Categoría
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Categoría", systemImage: "tag.fill")
                            .font(.poppinsSemiBold(size: 14))
                            .foregroundColor(.white.opacity(0.8))
                        
                        Text(reporte.categoria)
                            .font(.poppinsSemiBold(size: 14))
                            .foregroundColor(.white)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 7)
                            .background(Color.teal.opacity(0.4))
                            .cornerRadius(8)
                    }
                    .padding(.horizontal, 20)
                    
                    Divider().background(.white.opacity(0.2))
                        .padding(.horizontal, 20)
                    
                    // MARK: - Hashtags
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Etiquetas", systemImage: "number")
                            .font(.poppinsSemiBold(size: 14))
                            .foregroundColor(.white.opacity(0.8))
                        Text(reporte.hashtags)
                            .font(.poppinsRegular(size: 14))
                            .foregroundColor(.teal.opacity(0.9))
                    }
                    .padding(.horizontal, 20)
                    
                    Divider().background(.white.opacity(0.2))
                        .padding(.horizontal, 20)
                    
                    // MARK: - Fechas
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "calendar.badge.plus")
                                .foregroundColor(.teal)
                            Text("Fecha de reporte:")
                                .font(.poppinsRegular(size: 14))
                                .foregroundColor(.white.opacity(0.7))
                            Spacer()
                            Text(reporte.fechaCreacion)
                                .font(.poppinsSemiBold(size: 14))
                                .foregroundColor(.white)
                        }
                        
                        if let fechaVerificacion = reporte.fechaVerificacion {
                            HStack {
                                Image(systemName: "calendar.badge.checkmark")
                                    .foregroundColor(.green)
                                Text("Fecha de verificación:")
                                    .font(.poppinsRegular(size: 14))
                                    .foregroundColor(.white.opacity(0.7))
                                Spacer()
                                Text(fechaVerificacion)
                                    .font(.poppinsSemiBold(size: 14))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                    
                }
                .padding(.top, 10)
                .padding(.bottom, 40)
                .background(Color.white.opacity(0.05))
                .cornerRadius(16)
                .padding(.horizontal, 20)
                .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
            }
        }
        .navigationTitle("Detalle del Reporte")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                        Text("Volver")
                            .font(.poppinsRegular(size: 18))
                    }
                    .foregroundColor(.white)
                }
            }
        }
        .toolbarBackground(Color(red: 0.043, green: 0.067, blue: 0.173), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

// MARK: - Sección de información reutilizable
struct InfoSection: View {
    let icon: String
    let title: String
    let content: String
    var accentColor: Color = .white
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(title, systemImage: icon)
                .font(.poppinsSemiBold(size: 14))
                .foregroundColor(.white.opacity(0.8))
            Text(content)
                .font(.poppinsRegular(size: 15))
                .foregroundColor(accentColor)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, 20)
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
