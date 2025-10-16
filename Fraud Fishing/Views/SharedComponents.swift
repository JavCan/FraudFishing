//
//  SharedComponents.swift
//  Fraud Fishing
//
//  Created by Victor Bosquez on 02/10/25.
//

import SwiftUI

// MARK: - Enums y Modelos

enum NavigationTab {
    case home, dashboard, settings
}

struct ReporteDestacado: Identifiable {
    let id: String
    let nombre: String
    let logo: String
    let descripcion: String
    let categoria: String
    let hashtags: String
    let numeroReportes: Int
}

// MARK: - Empty State View

struct EmptyStateViewShared: View {
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

// MARK: - Category Chip

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

// MARK: - Top Site Card

struct TopSiteCard: View {
    let sitio: String
    let position: Int
    
    var medalColor: Color {
        switch position {
        case 1: return Color(red: 1.0, green: 0.84, blue: 0.0)
        case 2: return Color(red: 0.75, green: 0.75, blue: 0.75)
        case 3: return Color(red: 0.8, green: 0.5, blue: 0.2)
        default: return Color.gray
        }
    }
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(medalColor)
                    .frame(width: 35, height: 35)
                
                Text("\(position)")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
            }
            
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
            
            HStack(alignment: .top, spacing: 14) {
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
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(reporte.descripcion)
                        .font(.system(size: 14))
                        .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                        .lineLimit(3)
                        .fixedSize(horizontal: false, vertical: true)
                    
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

// MARK: - Detalle Reporte Destacado View

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
                    
                    VStack(spacing: 0) {
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
                        Text("Atrás")
                            .font(.body)
                    }
                    .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                }
            }
        }
    }
}

// MARK: - Dashboard Tab Bar

struct DashboardTabBar: View {
    @Binding var selectedTab: NavigationTab
    
    var body: some View {
        let darkBlue = Color(red: 0.0, green: 0.2, blue: 0.4)
        let barHeight: CGFloat = 88
        
        ZStack {
            Path { path in
                let width = UIScreen.main.bounds.width
                path.move(to: CGPoint(x: 0, y: 0))
                path.addQuadCurve(to: CGPoint(x: width, y: 0),
                                  control: CGPoint(x: width / 2, y: 40))
                path.addLine(to: CGPoint(x: width, y: barHeight))
                path.addLine(to: CGPoint(x: 0, y: barHeight))
                path.closeSubpath()
            }
            .fill(Color.white)
            .shadow(color: .black.opacity(0.12), radius: 10, x: 0, y: -6)
            
            HStack {
                NavigationLink(destination: ScreenHome()) {
                    Image(systemName: "house.fill")
                        .font(.system(size: 24))
                        .foregroundColor(selectedTab == .home ? darkBlue : Color.gray.opacity(0.5))
                }
                
                Spacer()
                
                NavigationLink(destination: ScreenAjustes()) {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 24))
                        .foregroundColor(selectedTab == .settings ? darkBlue : Color.gray.opacity(0.5))
                }
            }
            .padding(.horizontal, 55)
            
            NavigationLink(destination: ScreenDashboard()) {
                ZStack {
                    Circle()
                        .fill(Color(red: 0.0, green: 0.71, blue: 0.737))
                        .frame(width: 70, height: 70)
                        .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 6)
                    Image(systemName: "chart.bar.fill")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .offset(y: -25)
        }
        .frame(height: barHeight)
    }
}