//
//  ScreenHome.swift
//  Fraud Fishing
//
//  Created by Victor Bosquez on 02/10/25.
//
//

import SwiftUI

struct ScreenDashboard: View {
    @State private var categoriaSeleccionada: String = "Todas"
    @State private var showNotificaciones: Bool = false
    
    let categorias = ["Todas", "Informacion falsa", "Envios falsos", "Productos falsos", "Phishing", "Estafas"]
    
    @State private var reportesDestacados: [ReporteDestacado] = [
        ReporteDestacado(id: "1", nombre: "PaginaFake.com", logo: "pagina_fake", descripcion: "Esta es una página falsa que vende productos", categoria: "Productos falsos", hashtags: "#Venta #Cobro #Envio", numeroReportes: 45),
        ReporteDestacado(id: "2", nombre: "TuEstafa.com", logo: "estafa_logo", descripcion: "Página que pone recomendaciones con links llenos de virus", categoria: "Phishing", hashtags: "#Blog #Desinformacion", numeroReportes: 38),
        ReporteDestacado(id: "3", nombre: "Roboblanco.com", logo: "robo_logo", descripcion: "Sitio que roba información personal", categoria: "Informacion falsa", hashtags: "#Datos #Robo", numeroReportes: 52)
    ]
    
    var reportesFiltrados: [ReporteDestacado] {
        if categoriaSeleccionada == "Todas" {
            return reportesDestacados.sorted { $0.numeroReportes > $1.numeroReportes }
        } else {
            return reportesDestacados
                .filter { $0.categoria == categoriaSeleccionada }
                .sorted { $0.numeroReportes > $1.numeroReportes }
        }
    }
    
    var body: some View {
        NavigationStack {
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
                    // MARK: - Header
                    HStack {
                        Text("Reportes Destacados")
                            .font(.poppinsSemiBold(size: 24))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button(action: { showNotificaciones = true }) {
                            ZStack {
                                Circle()
                                    .fill(Color.white.opacity(0.1))
                                    .frame(width: 40, height: 40)
                                
                                Image(systemName: "bell.fill")
                                    .foregroundColor(.teal)
                                    .font(.system(size: 20))
                                
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 10, height: 10)
                                    .offset(x: 12, y: -12)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .padding(.bottom, 15)
                    
                    // MARK: - Filtro de categorías
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(categorias, id: \.self) { categoria in
                                CategoryChip(
                                    title: categoria,
                                    isSelected: categoriaSeleccionada == categoria
                                ) {
                                    withAnimation(.spring(response: 0.3)) {
                                        categoriaSeleccionada = categoria
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 20)
                    
                    // MARK: - Lista
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 16) {
                            if reportesFiltrados.isEmpty {
                                EmptyStateView(
                                    icon: "magnifyingglass",
                                    message: "No hay reportes",
                                    description: "No se encontraron reportes en esta categoría"
                                )
                                .padding(.top, 80)
                            } else {
                                // Top 3
                                HStack(spacing: 12) {
                                    ForEach(Array(reportesFiltrados.prefix(3).enumerated()), id: \.element.id) { index, reporte in
                                        TopSiteCard(sitio: reporte.nombre, position: index + 1)
                                    }
                                }
                                .padding(.horizontal, 20)
                                
                                // Cards completas
                                ForEach(reportesFiltrados) { reporte in
                                    NavigationLink(destination: DetalleReporteDestacadoView(reporte: reporte)) {
                                        ReporteDestacadoCard(reporte: reporte)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                        .padding(.bottom, 100)
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showNotificaciones) {
                NotificacionesView()
            }
        }
    }
}

// MARK: - Chips actualizados
struct CategoryChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.poppinsMedium(size: 14))
                .foregroundColor(isSelected ? .white : .teal)
                .padding(.horizontal, 18)
                .padding(.vertical, 10)
                .background(isSelected ? Color.teal.opacity(0.6) : Color.white.opacity(0.08))
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.15), radius: 3, x: 0, y: 2)
        }
    }
}
// MARK: - Modelo de Datos

struct ReporteDestacado: Identifiable {
    let id: String
    let nombre: String
    let logo: String
    let descripcion: String
    let categoria: String
    let hashtags: String
    let numeroReportes: Int
}

// MARK: - Top Site Card (pequeño)

struct TopSiteCard: View {
    let sitio: String
    let position: Int
    
    var medalColor: Color {
        switch position {
        case 1: return Color(red: 1.0, green: 0.84, blue: 0.0) // Oro
        case 2: return Color(red: 0.75, green: 0.75, blue: 0.75) // Plata
        case 3: return Color(red: 0.8, green: 0.5, blue: 0.2) // Bronce
        default: return Color.gray
        }
    }
    
    var body: some View {
        VStack(spacing: 8) {
            // 🥇 Medalla
            ZStack {
                Circle()
                    .fill(medalColor.opacity(0.9))
                    .frame(width: 38, height: 38)
                    .shadow(color: medalColor.opacity(0.4), radius: 6, x: 0, y: 2)
                
                Text("\(position)")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
            }
            
            // 🌐 Nombre del sitio
            Text(sitio)
                .font(.poppinsSemiBold(size: 12))
                .foregroundColor(.white)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(height: 32)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.white.opacity(0.08),
                    Color.white.opacity(0.04)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.25), radius: 6, x: 0, y: 3)
    }
}


// MARK: - Reporte Destacado Card

struct ReporteDestacadoCard: View {
    let reporte: ReporteDestacado
    
    var body: some View {
        VStack(spacing: 0) {
            // Header con nombre del sitio y número de reportes
            HStack {
                Text(reporte.nombre)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.red)
                    Text("\(reporte.numeroReportes)")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.red)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color.red.opacity(0.1))
                .cornerRadius(12)
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 12)
            
            Divider()
                .padding(.horizontal, 16)
            
            // Contenido
            HStack(alignment: .top, spacing: 14) {
                // Logo/Imagen
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
                    .frame(width: 80, height: 80)
                    .overlay(
                        Image(systemName: "exclamationmark.shield.fill")
                            .foregroundColor(Color.red.opacity(0.4))
                            .font(.system(size: 30))
                    )
                    .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
                
                // Descripción
                VStack(alignment: .leading, spacing: 8) {
                    Text(reporte.descripcion)
                        .font(.system(size: 14))
                        .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                        .lineLimit(3)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    // Categoría
                    Text(reporte.categoria)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color(red: 0.0, green: 0.8, blue: 0.7))
                        .cornerRadius(6)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            
            // Hashtags
            HStack {
                Text(reporte.hashtags)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color(red: 0.0, green: 0.6, blue: 0.5))
                
                Spacer()
                
                HStack(spacing: 4) {
                    Text("Ver más")
                        .font(.system(size: 12, weight: .medium))
                    Image(systemName: "chevron.right")
                        .font(.system(size: 11, weight: .semibold))
                }
                .foregroundColor(Color(red: 0.0, green: 0.6, blue: 0.5))
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 14)
        }
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
        .padding(.horizontal, 20)
    }
}

// MARK: - Vista de Detalle del Reporte Destacado

struct DetalleReporteDestacadoView: View {
    @Environment(\.dismiss) private var dismiss
    let reporte: ReporteDestacado
    
    var body: some View {
        ZStack {
            // 🔹 Fondo degradado azul oscuro coherente
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.043, green: 0.067, blue: 0.173, opacity: 0.9),
                    Color(red: 0.043, green: 0.067, blue: 0.173)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    
                    // 🚨 Alerta de peligro
                    HStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.red)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("⚠️ Sitio Reportado")
                                .font(.poppinsSemiBold(size: 16))
                                .foregroundColor(.red)
                            Text("\(reporte.numeroReportes) usuarios han reportado este sitio")
                                .font(.poppinsRegular(size: 13))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        
                        Spacer()
                    }
                    .padding(16)
                    .background(Color.red.opacity(0.15))
                    .cornerRadius(12)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    // 💠 Card principal
                    VStack(alignment: .leading, spacing: 20) {
                        
                        // Logo / Imagen
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.08))
                            .frame(height: 180)
                            .overlay(
                                Image(systemName: "exclamationmark.shield.fill")
                                    .foregroundColor(Color.red.opacity(0.5))
                                    .font(.system(size: 60))
                            )
                            .padding(.horizontal, 20)
                        
                        // Sitio
                        InfoSection(
                            icon: "link.circle.fill",
                            title: "Sitio web reportado",
                            content: reporte.nombre,
                            accentColor: .teal
                        )
                        
                        Divider().background(.white.opacity(0.25))
                            .padding(.horizontal, 20)
                        
                        // Descripción
                        InfoSection(
                            icon: "info.circle.fill",
                            title: "¿Por qué es peligroso?",
                            content: reporte.descripcion,
                            accentColor: .white.opacity(0.9)
                        )
                        
                        Divider().background(.white.opacity(0.25))
                            .padding(.horizontal, 20)
                        
                        // Categoría
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Tipo de fraude", systemImage: "tag.fill")
                                .font(.poppinsSemiBold(size: 14))
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text(reporte.categoria)
                                .font(.poppinsSemiBold(size: 14))
                                .foregroundColor(.white)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 7)
                                .background(Color.teal.opacity(0.5))
                                .cornerRadius(8)
                        }
                        .padding(.horizontal, 20)
                        
                        Divider().background(.white.opacity(0.25))
                            .padding(.horizontal, 20)
                        
                        // Hashtags
                        InfoSection(
                            icon: "number",
                            title: "Etiquetas",
                            content: reporte.hashtags,
                            accentColor: .teal.opacity(0.8)
                        )
                    }
                    .padding(.vertical, 20)
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(16)
                    .padding(.horizontal, 20)
                    .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .padding(.bottom, 40)
            }
        }
        .navigationTitle("Detalles del Reporte")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Inicio")
                    }
                    .font(.poppinsRegular(size: 18))
                    .foregroundColor(.white)
                }
            }
        }
        .toolbarBackground(Color(red: 0.043, green: 0.067, blue: 0.173), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

// MARK: - Enlace a Notificaciones

struct NotificacionesView: View {
    var body: some View {
        NavigationLink(destination: ScreenNotifications()) {
            Label("Notificaciones", systemImage: "bell")
                .foregroundColor(.primary)
                .padding()
        }
    }
}


// MARK: - Preview

#Preview {
    ScreenDashboard()
}
