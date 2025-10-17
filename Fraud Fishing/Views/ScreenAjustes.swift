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
        NavigationStack {
            ZStack {
                // 🔹 Fondo igual que en ScreenLogin
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
                    VStack(spacing: 35) {

                        // MARK: - Título
                        Text("Ajustes")
                            .font(.poppinsMedium(size: 34))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 30)
                            .padding(.top, 20)

                        // MARK: - Sección Cuenta
                        ajustesSection(title: "Cuenta") {
                            ajustesRow(
                                icon: "person.circle.fill",
                                title: "Editar Perfil",
                                destination: ScreenEditarPerfil()
                            )

                            ajustesToggleRow(
                                icon: "bell.fill",
                                title: "Notificaciones",
                                isOn: $notificacionesActivadas
                            )

                            ajustesRow(
                                icon: "lock.shield.fill",
                                title: "Aviso de Privacidad",
                                destination: ScreenAvisoPrivacidad()
                            )
                        }

                        // MARK: - Sección Reportes
                        ajustesSection(title: "Mis Reportes") {
                            ajustesRow(
                                icon: "checkmark.circle.fill",
                                title: "Mis reportes aceptados",
                                destination: ScreenReportesVerificados()
                            )

                            ajustesRow(
                                icon: "clock.fill",
                                title: "Mis reportes pendientes",
                                destination: ScreenReportesPendientes()
                            )

                            ajustesRow(
                                icon: "doc.text.fill",
                                title: "Términos y Condiciones",
                                destination: ScreenTerminosCondiciones()
                            )
                        }

                        // MARK: - Botón Cerrar Sesión
                        Button(action: { showLogoutAlert = true }) {
                            Text("Cerrar Sesión")
                                .font(.poppinsBold(size: 20))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red)
                                .cornerRadius(10)
                                .shadow(color: .red.opacity(0.3), radius: 5, x: 0, y: 3)
                        }
                        .padding(.horizontal, 30)
                        .padding(.bottom, 60)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .semibold))
                            Text("Home")
                                .font(.poppinsRegular(size: 18))
                        }
                        .foregroundColor(.white)
                    }
                }
            }
            .toolbarBackground(Color(red: 0.043, green: 0.067, blue: 0.173), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
            .alert("Cerrar Sesión", isPresented: $showLogoutAlert) {
                Button("Cancelar", role: .cancel) {}
                Button("Cerrar Sesión", role: .destructive) {
                    cerrarSesion()
                }
            } message: {
                Text("¿Estás seguro de que deseas cerrar sesión?")
            }
        }
    }

    // MARK: - Funciones auxiliares

    private func cerrarSesion() {
        print("Cerrando sesión...")
    }

    // MARK: - Componentes reutilizables

    @ViewBuilder
    private func ajustesSection(title: String, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(title)
                .font(.poppinsSemiBold(size: 20))
                .foregroundColor(.white)
                .padding(.leading, 30)
            VStack(spacing: 10) {
                content()
            }
            .padding(.horizontal, 25)
        }
        .padding(.bottom, 10)
    }

    private func ajustesRow<Destination: View>(
        icon: String,
        title: String,
        destination: Destination
    ) -> some View {
        NavigationLink(destination: destination) {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(.white.opacity(0.8))
                    .frame(width: 30)

                Text(title)
                    .font(.poppinsRegular(size: 18))
                    .foregroundColor(.white)

                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white.opacity(0.5))
            }
            .padding()
            .background(Color.white.opacity(0.08))
            .cornerRadius(8)
        }
    }

    private func ajustesToggleRow(icon: String, title: String, isOn: Binding<Bool>) -> some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundColor(.white.opacity(0.8))
                .frame(width: 30)

            Text(title)
                .font(.poppinsRegular(size: 18))
                .foregroundColor(.white)

            Spacer()
            Toggle("", isOn: isOn)
                .labelsHidden()
                .tint(Color.teal)
        }
        .padding()
        .background(Color.white.opacity(0.08))
        .cornerRadius(8)
    }
}

#Preview {
    ScreenAjustes()
}
