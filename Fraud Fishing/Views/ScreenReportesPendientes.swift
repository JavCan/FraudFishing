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
            estado: .pendiente
        ),
        Reporte(
            id: "2",
            url: "https://www.arngren.net",
            logo: "arngren_logo",
            descripcion: "No se puede comprar nada en esta pagina web, pero te piden tus metodos de pago.",
            categoria: "Envios falsos",
            hashtags: "#Venta #Cobro #Envio",
            estado: .pendiente
        )
    ]
    
    var body: some View {
        ZStack {
            // Fondo
            Color.white
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Lista de reportes
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(reportesPendientes) { reporte in
                            ReporteCard(reporte: reporte)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 20)
                    .padding(.bottom, 100)
                }
                
                Spacer()
            }
        }
        .navigationTitle("Reportes\nPendientes")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
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
            estado: .verificado
        ),
        Reporte(
            id: "4",
            url: "https://www.arngren.net",
            logo: "arngren_logo",
            descripcion: "No se puede comprar nada en esta pagina web, pero te piden tus metodos de pago.",
            categoria: "Envios falsos",
            hashtags: "#Venta #Cobro #Envio",
            estado: .verificado
        )
    ]
    
    var body: some View {
        ZStack {
            // Fondo
            Color.white
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Lista de reportes
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(reportesVerificados) { reporte in
                            ReporteCard(reporte: reporte)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 20)
                    .padding(.bottom, 100)
                }
                
                Spacer()
            }
        }
        .navigationTitle("Reportes\nVerificados")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
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
}

enum EstadoReporte {
    case pendiente
    case verificado
}

// MARK: - Componente ReporteCard

struct ReporteCard: View {
    let reporte: Reporte
    
    var body: some View {
        VStack(spacing: 0) {
            // Header con badge de estado
            HStack {
                Spacer()
                
                Text(reporte.estado == .pendiente ? "Pendiente" : "Verificado")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(reporte.estado == .pendiente ? 
                               Color(red: 0.0, green: 0.2, blue: 0.4) : 
                               Color.green)
                    .cornerRadius(8)
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .background(Color.white)
            
            // URL del sitio
            VStack(alignment: .leading, spacing: 12) {
                Text(reporte.url)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                    .underline()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 8)
                
                // Contenido del reporte
                HStack(alignment: .top, spacing: 12) {
                    // Logo/Imagen del sitio
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 80, height: 80)
                        .overlay(
                            Image(systemName: "photo")
                                .foregroundColor(.gray)
                        )
                    
                    // Descripción
                    Text(reporte.descripcion)
                        .font(.system(size: 14))
                        .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                        .lineLimit(4)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 16)
                
                // Categoría
                HStack {
                    Text(reporte.categoria)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 6)
                        .background(Color(red: 0.0, green: 0.8, blue: 0.7))
                        .cornerRadius(8)
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                
                // Hashtags
                Text(reporte.hashtags)
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
            }
            .background(Color.white)
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
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