//
//  ScreenLogin.swift
//  Fraud Fishing
//
//  Created by Javier Canella Ramos on 16/09/25.
//

import SwiftUI


struct ScreenLogin: View {
    @State private var emailOrUsername: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    @Environment(\.authenticationController) var authenticationController

    func login() async {
        do {
            let response = try await authenticationController.loginUser(email: emailOrUsername, password: password)
            print("Login exitoso: \(response)")
            // Aquí puedes manejar la navegación a la siguiente vista o guardar los tokens
        } catch {
            print("Error al iniciar sesión: \(error.localizedDescription)")
            // Aquí puedes mostrar un mensaje de error al usuario
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [
                    Color(red: 1, green: 1, blue: 1),
                    Color(red: 0.0, green: 0.71, blue: 0.737)]),
                               startPoint: UnitPoint(x:0.5, y:0.7),
                               endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    // Título "Iniciar Sesión"
                    Text("Iniciar Sesión")
                        .font(.poppinsMedium(size: 34)) // Aplicando Poppins Bold
                        .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4)) // Cambiado a blanco para contraste
                        .padding(.bottom, 40)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 30)

                    // Campo de Correo
                    VStack(alignment: .leading, spacing: 8) { // Alineación a la izquierda para el label
                        Text("Correo")
                            .font(.poppinsSemiBold(size: 14)) // Semibold más pequeño
                            .foregroundColor(.gray) // Color gris
                            .padding(.leading, 30) // Alineado con el contenido del campo

                        HStack {
                            Image(systemName: "envelope")
                                .foregroundColor(.gray)
                                .padding(.leading, 30) // Alineación del icono
                            TextField("ejemplo@email.com", text: $emailOrUsername)
                                .font(.poppinsRegular(size: 18)) // Fuente más grande y clara
                                .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4)) // Texto de entrada blanco
                                .padding(.vertical, 5) // Ajuste de padding vertical
                        }
                        Rectangle() // Línea gris tenue
                            .frame(height: 1)
                            .foregroundColor(.gray.opacity(0.5))
                            .padding(.horizontal, 30) // Alineado con el contenido del campo
                    }
                    .padding(.bottom, 20)

                    // Campo de Contraseña
                    VStack(alignment: .leading, spacing: 8) { // Alineación a la izquierda para el label
                        Text("Contraseña")
                            .font(.poppinsSemiBold(size: 14)) // Semibold más pequeño
                            .foregroundColor(.gray) // Color gris
                            .padding(.leading, 30) // Alineado con el contenido del campo

                        HStack {
                            Image(systemName: "lock")
                                .foregroundColor(.gray)
                                .padding(.leading, 30)
                                .padding(.horizontal, 4)
                            if isPasswordVisible {
                                TextField("••••••••", text: $password)
                                    .font(.poppinsRegular(size: 18)) // Fuente más grande y clara
                                    .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4)) // Texto de entrada blanco
                                    .padding(.vertical, 5) // Ajuste de padding vertical
                            } else {
                                SecureField("••••••••", text: $password)
                                    .font(.poppinsRegular(size: 18)) // Fuente más grande y clara
                                    .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4)) // Texto de entrada blanco
                                    .padding(.vertical, 5) // Ajuste de padding vertical
                            }
                            Button(action: {
                                isPasswordVisible.toggle()
                            }) {
                                Image(systemName: isPasswordVisible ? "eye.fill" : "eye.slash.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 30) // Alineación del icono
                            }
                        }
                        Rectangle() // Línea gris tenue
                            .frame(height: 1)
                            .foregroundColor(.gray.opacity(0.5))
                            .padding(.horizontal, 30) // Alineado con el contenido del campo
                    }

                    // ¿Olvidaste tu contraseña?
                    Button(action: {
                        // Acción para recuperar contraseña
                    }) {
                        Text("Olvidé mi contraseña") // Texto actualizado
                            .font(.poppinsRegular(size: 15)) // Aplicando Poppins Regular
                            .foregroundColor(.gray) // Color gris
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 30)
                    .padding(.top, 10)
                    .padding(.bottom, 30)

                    // Botón Iniciar Sesión
                    Button(action: {
                        Task {
                            await login()
                        }
                    }) {
                        Text("Iniciar Sesión")
                            .font(.poppinsBold(size: 20)) // Aplicando Poppins Bold
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(red: 0.0, green: 0.2, blue: 0.4))
                            .cornerRadius(10)
                            .padding(.horizontal, 30)
                    }
                    .padding(.bottom, 10)

                    // ¿No tienes cuenta? Regístrate aquí
                    HStack {
                        Text("Soy un nuevo usuario.")
                            .font(.poppinsRegular(size: 17)) // Aplicando Poppins Regular
                            .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4)) // Cambiado a blanco
                        NavigationLink(destination: ScreenRegister()) {
                            Text("Registrarme")
                                .font(.poppinsBold(size: 17)) // Aplicando Poppins Bold
                                .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4)) // Color de acento
                        }
                    }
                    .padding(.bottom, 170)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    ScreenLogin()
}
