//
//  ScreenLogin.swift
//  Fraud Fishing
//
//  Created by Javier Canella Ramos on 16/09/25.
//

import SwiftUI

enum LoginRoute: Hashable {
    case home
}

struct ScreenLogin: View {
    // MARK: - Estados y Entorno
    @State private var emailOrUsername: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    @Environment(\.authenticationController) var authenticationController

    @State private var isLoading: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var loginExitoso: Bool = false
    @State private var navPath: [LoginRoute] = []  // ← Nuevo path de navegación

    // MARK: - Función de Inicio de Sesión
    func login() async {
        isLoading = true
        do {
            let response = try await authenticationController.loginUser(email: emailOrUsername, password: password)
            print("Login exitoso: \(response)")
            alertMessage = "Inicio de sesión exitoso."
            loginExitoso = true
            showAlert = true
            await MainActor.run {
                navPath.append(.home)  // ← Navegación programática con NavigationStack
            }
        } catch {
            print("Error al iniciar sesión: \(error.localizedDescription)")
            alertMessage = "Credenciales inválidas. Por favor, inténtalo de nuevo."
            showAlert = true
            loginExitoso = false
        }
        isLoading = false
    }

    // MARK: - Vista Principal
    var body: some View {
        NavigationStack(path: $navPath) {   // ← Usa path
            ZStack {
                // MARK: Fondo con gradiente oscuro
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.043, green: 0.067, blue: 0.173, opacity: 0.88),
                        Color(red: 0.043, green: 0.067, blue: 0.173)
                    ]),
                    startPoint: UnitPoint(x: 0.5, y: 0.1),
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)

                VStack {
                    // MARK: - Título
                    Text("Iniciar Sesión")
                        .font(.poppinsMedium(size: 34))
                        .foregroundColor(.white)
                        .padding(.bottom, 40)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 30)

                    // MARK: - Campo de Correo
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Correo")
                            .font(.poppinsSemiBold(size: 14))
                            .foregroundColor(.white.opacity(0.8))
                            .padding(.leading, 30)

                        HStack {
                            Image(systemName: "envelope")
                                .foregroundColor(.white.opacity(0.5))
                                .padding(.leading, 30)

                            ZStack(alignment: .leading) {
                                if emailOrUsername.isEmpty {
                                    Text("ejemplo@email.com")
                                        .font(.poppinsRegular(size: 18))
                                        .foregroundColor(.white.opacity(0.6))
                                        .padding(.vertical, 5)
                                }
                                TextField("", text: $emailOrUsername)
                                    .font(.poppinsRegular(size: 18))
                                    .foregroundColor(.white)
                                    .padding(.vertical, 5)
                                    .autocapitalization(.none)
                                    .keyboardType(.emailAddress)
                            }
                        }

                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.white.opacity(0.5))
                            .padding(.horizontal, 30)
                    }
                    .padding(.bottom, 20)

                    // MARK: - Campo de Contraseña
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Contraseña")
                            .font(.poppinsSemiBold(size: 14))
                            .foregroundColor(.white.opacity(0.8))
                            .padding(.leading, 30)

                        HStack {
                            Image(systemName: "lock")
                                .foregroundColor(.white.opacity(0.5))
                                .padding(.leading, 30)
                                .padding(.horizontal, 4)

                            if isPasswordVisible {
                                ZStack(alignment: .leading) {
                                    if password.isEmpty {
                                        Text("••••••••")
                                            .font(.poppinsRegular(size: 18))
                                            .foregroundColor(.white.opacity(0.6))
                                            .padding(.vertical, 5)
                                    }
                                    TextField("", text: $password)
                                        .font(.poppinsRegular(size: 18))
                                        .foregroundColor(.white)
                                        .padding(.vertical, 5)
                                }
                            } else {
                                ZStack(alignment: .leading) {
                                    if password.isEmpty {
                                        Text("••••••••")
                                            .font(.poppinsRegular(size: 18))
                                            .foregroundColor(.white.opacity(0.6))
                                            .padding(.vertical, 5)
                                    }
                                    SecureField("", text: $password)
                                        .font(.poppinsRegular(size: 18))
                                        .foregroundColor(.white)
                                        .padding(.vertical, 5)
                                }
                            }

                            Button(action: { isPasswordVisible.toggle() }) {
                                Image(systemName: isPasswordVisible ? "eye.fill" : "eye.slash.fill")
                                    .foregroundColor(.white.opacity(0.5))
                                    .padding(.trailing, 30)
                            }
                        }

                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.white.opacity(0.5))
                            .padding(.horizontal, 30)
                    }

                    // MARK: - Olvidé mi Contraseña
                    Button(action: {}) {
                        Text("Olvidé mi contraseña")
                            .font(.poppinsRegular(size: 15))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 30)
                    .padding(.top, 10)
                    .padding(.bottom, 30)

                    // MARK: - Botón Iniciar Sesión
                    Button(action: {
                        Task { await login() }
                    }) {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Iniciar Sesión")
                                    .font(.poppinsBold(size: 20))
                            }
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(isLoading ? Color.gray : Color(red: 0.0, green: 0.2, blue: 0.4))
                        .cornerRadius(10)
                        .padding(.horizontal, 30)
                    }
                    .disabled(isLoading)
                    .padding(.bottom, 10)

                    // MARK: - Enlace a Registro
                    HStack {
                        Text("Soy un nuevo usuario.")
                            .font(.poppinsRegular(size: 17))
                            .foregroundColor(.white.opacity(0.8))
                        NavigationLink(destination: ScreenRegister()) {
                            Text("Registrarme")
                                .font(.poppinsBold(size: 17))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.bottom, 170)
                }
            }

            // MARK: - Navegación y Alertas
            .navigationBarHidden(true)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(loginExitoso ? "Éxito" : "Error"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            .navigationDestination(for: LoginRoute.self) { route in   // ← Destino moderno
                switch route {
                case .home:
                    ScreenHome()
                        .navigationBarBackButtonHidden(true)
                        .toolbar(.hidden, for: .navigationBar)
                }
            }
        }
    }
}

#Preview {
    ScreenLogin()
}
