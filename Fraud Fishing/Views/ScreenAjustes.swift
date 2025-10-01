//
//  ScreenAjustes.swift
//  Fraud Fishing
//
//  Created by Victor Bosquez on 30/09/25.
//

import SwiftUI

struct ScreenAjustes: View {
    @Environment(\.dismiss) private var dismiss
    @State private var notificacionesActivadas: Bool = true
    @State private var showLogoutAlert: Bool = false
    
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
                
                ScrollView {
                    VStack(spacing: 25) {
                        // MARK: - Sección Cuenta
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Cuenta")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                                .padding(.horizontal, 20)
                                .padding(.bottom, 10)
                            
                            VStack(spacing: 0) {
                                // Editar Perfil
                                NavigationLink(destination: Text("Editar Perfil")) {
                                    SettingsRow(
                                        icon: "person.circle.fill",
                                        title: "Editar Perfil",
                                        showChevron: true
                                    )
                                }
                                
                                Divider()
                                    .padding(.leading, 60)
                                
                                // Notificaciones con Toggle
                                HStack {
                                    Image(systemName: "bell.fill")
                                        .font(.system(size: 22))
                                        .foregroundColor(Color(red: 0.0, green: 0.6, blue: 0.5))
                                        .frame(width: 30)
                                    
                                    Text("Notificaciones")
                                        .font(.body)
                                        .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                                    
                                    Spacer()
                                    
                                    Toggle("", isOn: $notificacionesActivadas)
                                        .labelsHidden()
                                        .tint(Color(red: 0.0, green: 0.6, blue: 0.5))
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 15)
                                .background(Color.white)
                                
                                Divider()
                                    .padding(.leading, 60)
                                
                                // Aviso de Privacidad
                                NavigationLink(destination: Text("Aviso de Privacidad")) {
                                    SettingsRow(
                                        icon: "lock.shield.fill",
                                        title: "Aviso de Privacidad",
                                        showChevron: true
                                    )
                                }
                            }
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                            .padding(.horizontal, 20)
                        }
                        
                        // MARK: - Sección Mis Reportes
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Mis reportes")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                                .padding(.horizontal, 20)
                                .padding(.bottom, 10)
                            
                            VStack(spacing: 0) {
                                // Reportes Aceptados
                                NavigationLink(destination: Text("Reportes Aceptados")) {
                                    SettingsRow(
                                        icon: "checkmark.circle.fill",
                                        title: "Mis reportes aceptados",
                                        showChevron: true
                                    )
                                }
                                
                                Divider()
                                    .padding(.leading, 60)
                                
                                // Reportes Pendientes
                                NavigationLink(destination: Text("Reportes Pendientes")) {
                                    SettingsRow(
                                        icon: "clock.fill",
                                        title: "Mis reportes pendientes",
                                        showChevron: true
                                    )
                                }
                                
                                Divider()
                                    .padding(.leading, 60)
                                
                                // Términos y Condiciones
                                NavigationLink(destination: Text("Términos y Condiciones")) {
                                    SettingsRow(
                                        icon: "doc.text.fill",
                                        title: "Términos y condiciones",
                                        showChevron: true
                                    )
                                }
                            }
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                            .padding(.horizontal, 20)
                        }
                        
                        // MARK: - Botón Cerrar Sesión
                        Button(action: {
                            showLogoutAlert = true
                        }) {
                            HStack {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                    .font(.system(size: 18))
                                Text("Cerrar Sesión")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(12)
                            .shadow(color: Color.red.opacity(0.3), radius: 5, x: 0, y: 3)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 40)
                    }
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Ajustes")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .semibold))
                            Text("Home")
                                .font(.body)
                        }
                        .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                    }
                }
            }
            .alert("Cerrar Sesión", isPresented: $showLogoutAlert) {
                Button("Cancelar", role: .cancel) { }
                Button("Cerrar Sesión", role: .destructive) {
                    cerrarSesion()
                }
            } message: {
                Text("¿Estás seguro de que deseas cerrar sesión?")
            }
        }
    }
    
    // MARK: - Funciones
    
    private func cerrarSesion() {
        // Aquí implementarías la lógica de cerrar sesión
        // Por ejemplo: limpiar tokens, navegar a login, etc.
        print("Cerrando sesión...")
        
        // Ejemplo de lo que podrías hacer:
        // UserDefaults.standard.removeObject(forKey: "accessToken")
        // UserDefaults.standard.removeObject(forKey: "refreshToken")
        // Navegar a pantalla de login
    }
}

// MARK: - Componente Reutilizable para Filas de Ajustes

struct SettingsRow: View {
    let icon: String
    let title: String
    let showChevron: Bool
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundColor(Color(red: 0.0, green: 0.6, blue: 0.5))
                .frame(width: 30)
            
            Text(title)
                .font(.body)
                .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
            
            Spacer()
            
            if showChevron {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 15)
        .background(Color.white)
        .contentShape(Rectangle())
    }
}

// MARK: - Preview

#Preview {
    ScreenAjustes()
}