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
                // Gradiente de malla sutil con RadialGradient
                RadialGradient(gradient: Gradient(colors: [
                    Color(red: 0.98, green: 0.98, blue: 1.0), // Muy claro, casi blanco azulado
                    Color(red: 0.90, green: 0.95, blue: 1.0),  // Azul claro
                    Color(red: 0, green: 0.90, blue: 0.95)   // Azul ligeramente más profundo
                ]), center: .center, startRadius: 15, endRadius: 500)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    // Título "Iniciar Sesión"
                    Text("Iniciar Sesión")
                        .font(.poppinsRegular(size: 34)) // Aplicando Poppins Bold
                        .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                        .padding(.bottom, 40)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 30)

                    // Campo de Correo
                    Text("Correo")
                        .font(.poppinsSemiBold(size: 17)) // Aplicando Poppins SemiBold
                        .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 40)

                    HStack {
                        Image(systemName: "envelope")
                            .foregroundColor(.gray)
                            .padding(.leading, 10)
                        TextField("ejemplo@email.com", text: $emailOrUsername)
                            .font(.poppinsRegular(size: 17)) // Aplicando Poppins Regular
                            .padding(.vertical, 10)
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .padding(.horizontal, 30)
                    .padding(.bottom, 20)

                    // Campo de Contraseña
                    Text("Contraseña")
                        .font(.poppinsSemiBold(size: 17)) // Aplicando Poppins SemiBold
                        .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 40)


                    HStack {
                        Image(systemName: "lock")
                            .foregroundColor(.gray)
                            .padding(.leading, 10)
                        if isPasswordVisible {
                            TextField("••••••••", text: $password)
                                .font(.poppinsRegular(size: 17)) // Aplicando Poppins Regular
                                .padding(.vertical, 10)
                        } else {
                            SecureField("••••••••", text: $password)
                                .font(.poppinsRegular(size: 17)) // Aplicando Poppins Regular
                                .padding(.vertical, 10)
                        }
                        Button(action: {
                            isPasswordVisible.toggle()
                        }) {
                            Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.gray)
                                .padding(.trailing, 10)
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .padding(.horizontal, 30)

                    // ¿Olvidaste tu contraseña?
                    Button(action: {
                        // Acción para recuperar contraseña
                    }) {
                        Text("¿Olvidaste tu contraseña?")
                            .font(.poppinsRegular(size: 15)) // Aplicando Poppins Regular
                            .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 30)
                    .padding(.top, 5)
                    .padding(.bottom, 40)

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
                    .padding(.bottom, 50)

                    // ¿No tienes cuenta? Regístrate aquí
                    HStack {
                        Text("Soy un nuevo usuario.")
                            .font(.poppinsRegular(size: 17)) // Aplicando Poppins Regular
                            .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                        NavigationLink(destination: ScreenRegister()) {
                            Text("Registrarme")
                                .font(.poppinsBold(size: 17)) // Aplicando Poppins Bold
                                .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    ScreenLogin()
}
