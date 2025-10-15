//
//  ScreenHome.swift
//  Fraud Fishing
//
//  Created by Victor Bosquez on 02/10/25.
//

import SwiftUI

struct ScreenDashboard: View {
    @State private var categoriaSeleccionada: String = "Todas"
    @State private var showNotificaciones: Bool = false
    
    let categorias = ["Todas", "Informacion falsa", "Envios falsos", "Productos falsos", "Phishing", "Estafas"]
    
    // Datos de ejemplo - Reportes destacados
    @State private var reportesDestacados: [ReporteDestacado] = [
        ReporteDestacado(
            id: "1",
            nombre: "PaginaFake.com",
            logo: "pagina_fake",
            descripcion: "Esta es una pagina falsa que vende productos",
            categoria: "Productos falsos",
            hashtags: "#Venta #Cobro #Envio",
            numeroReportes: 45
        ),
        ReporteDestacado(
            id: "2",
            nombre: "TuEstafa.com",
            logo: "estafa_logo",
            descripcion: "Pagina que pone recomendaciones con links llenos de virus",
            categoria: "Phishing",
            hashtags: "#Bog #Desinformacion",
            numeroReportes: 38
        ),
        ReporteDestacado(
            id: "3",
            nombre: "Roboblanco.com",
            logo: "robo_logo",
            descripcion: "Sitio que roba información personal",
            categoria: "Informacion falsa",
            hashtags: "#Datos #Robo",
            numeroReportes: 52
        ),
        ReporteDestacado(
            id: "4",
            nombre: "BecaFalsa.mx",
            logo: "beca_logo",
            descripcion: "Ofrece becas falsas para obtener datos",
            categoria: "Estafas",
            hashtags: "#Becas #Educacion",
            numeroReportes: 29
        ),
        ReporteDestacado(
            id: "5",
            nombre: "Asalto.mx",
            logo: "asalto_logo",
            descripcion: "Venta de productos que nunca llegan",
            categoria: "Envios falsos",
            hashtags: "#Compras #Envios",
            numeroReportes: 41
        )
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
        NavigationView {
            ZStack {
                // Fondo con gradiente
                LinearGradient(gradient: Gradient(colors: [
                    Color(red: 1, green: 1, blue: 1),
                    Color(red: 0.0, green: 0.8, blue: 0.7)]),
                               startPoint: UnitPoint(x:0.5, y:0.7),
                               endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    // Header con título y notificaciones
                    HStack {
                        Text("Reportes Destacados")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                        
                        Spacer()
                        
                        Button(action: {
                            showNotificaciones = true
                        }) {
                            ZStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 40, height: 40)
                                    .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
                                
                                Image(systemName: "bell.fill")
                                    .foregroundColor(Color(red: 0.0, green: 0.6, blue: 0.5))
                                    .font(.system(size: 20))
                                
                                // Badge de notificaciones
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 12, height: 12)
                                    .offset(x: 12, y: -12)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .padding(.bottom, 15)
                    
                    // Filtro de categorías
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(categorias, id: \.self) { categoria in
                                CategoryChip(
                                    title: categoria,
                                    isSelected: categoriaSeleccionada == categoria,
                                    action: {
                                        withAnimation(.spring(response: 0.3)) {
                                            categoriaSeleccionada = categoria
                                        }
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 20)
                    
                    // Lista de sitios destacados
                    ScrollView {
                        VStack(spacing: 16) {
                            if reportesFiltrados.isEmpty {
                                EmptyStateView(
                                    icon: "magnifyingglass",
                                    message: "No hay reportes",
                                    description: "No se encontraron reportes en esta categoría"
                                )
                                .padding(.top, 60)
                            } else {
                                // Top 3 sitios web destacados (cards pequeños)
                                HStack(spacing: 12) {
                                    ForEach(Array(reportesFiltrados.prefix(3).enumerated()), id: \.element.id) { index, reporte in
                                        TopSiteCard(
                                            sitio: reporte.nombre,
                                            position: index + 1
                                        )
                                    }
                                }
                                .padding(.horizontal, 20)
                                
                                // Cards completos de reportes
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

// MARK: - Componente Category Chip

struct CategoryChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: isSelected ? .semibold : .medium))
                .foregroundColor(isSelected ? .white : Color(red: 0.0, green: 0.2, blue: 0.4))
                .padding(.horizontal, 18)
                .padding(.vertical, 10)
                .background(
                    isSelected ? 
                    Color(red: 0.0, green: 0.8, blue: 0.7) :
                    Color.white
                )
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(isSelected ? 0.15 : 0.08), radius: 4, x: 0, y: 2)
        }
    }
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
            // Medalla
            ZStack {
                Circle()
                    .fill(medalColor)
                    .frame(width: 35, height: 35)
                
                Text("\(position)")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
            }
            
            // Nombre del sitio
            Text(sitio)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(height: 32)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.08), radius: 5, x: 0, y: 3)
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
            LinearGradient(gradient: Gradient(colors: [
                Color(red: 1, green: 1, blue: 1),
                Color(red: 0.0, green: 0.8, blue: 0.7)]),
                           startPoint: UnitPoint(x:0.5, y:0.7),
                           endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 24) {
                    // Alerta de peligro
                    HStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.red)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("¡Sitio Reportado!")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.red)
                            Text("\(reporte.numeroReportes) usuarios han reportado este sitio")
                                .font(.system(size: 13))
                                .foregroundColor(.red.opacity(0.8))
                        }
                        
                        Spacer()
                    }
                    .padding(16)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    // Card principal
                    VStack(spacing: 0) {
                        // Logo grande
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
                                Image(systemName: "exclamationmark.shield.fill")
                                    .foregroundColor(Color.red.opacity(0.3))
                                    .font(.system(size: 60))
                            )
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                        
                        // Nombre del sitio
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Sitio web reportado", systemImage: "link.circle.fill")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.gray)
                            
                            Text(reporte.nombre)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                                .underline()
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                        
                        Divider()
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                        
                        // Descripción
                        VStack(alignment: .leading, spacing: 8) {
                            Label("¿Por qué es peligroso?", systemImage: "info.circle.fill")
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
                            Label("Tipo de fraude", systemImage: "tag.fill")
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
                        .padding(.bottom, 20)
                    }
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 40)
            }
        }
        .navigationTitle("Detalles del Reporte")
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
                        Text("Inicio")
                            .font(.body)
                    }
                    .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                }
            }
        }
    }
}

// MARK: - Vista de Notificaciones

struct NotificacionesView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.95, green: 0.95, blue: 0.97)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    EmptyStateView(
                        icon: "bell.slash",
                        message: "No tienes notificaciones",
                        description: "Te notificaremos cuando haya actualizaciones importantes"
                    )
                    .padding(.top, 100)
                    
                    Spacer()
                }
            }
            .navigationTitle("Notificaciones")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cerrar") {
                        dismiss()
                    }
                    .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    ScreenDashboard()
}