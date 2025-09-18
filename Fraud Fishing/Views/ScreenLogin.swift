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
    @Environment(\.authenticationController) var authenticationController // Añadimos el controlador de autenticación

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
        NavigationView { // Envuelve la vista en un NavigationView
            ZStack {
                LinearGradient(gradient: Gradient(colors: [
                    Color(red: 1, green: 1, blue: 1),
                    Color(red: 0.0, green: 0.8, blue: 0.7)]),
                               startPoint: UnitPoint(x:0.5, y:0.7),
                               endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
        
                VStack {
                    // Placeholder para el logo
                    Image("FRAUD FISHING-03") // Reemplazado con la imagen del logo
                        .resizable()
                        .scaledToFill()
                        .frame(width: 400, height: 240) // Ajusta el tamaño según sea necesario
                    
                    
                    // Campo de Correo o Nombre
                    Text("Correo o Nombre")
                        .font(.headline)
                        .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 40)

                    TextField("", text: $emailOrUsername) // Enlazado a emailOrUsername
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(red: 0.0, green: 0.2, blue: 0.4), lineWidth: 1)
                            )
                        .padding(.horizontal, 30)
                        .padding(.bottom, 20)
                    
                    Spacer().frame(height: 25)
                    
                    // Campo de Contraseña
                    Text("Contraseña")
                        .font(.headline)
                        .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 40)

                    SecureField("", text: $password) // Enlazado a password
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(red: 0.0, green: 0.2, blue: 0.4), lineWidth: 1)
                            )
                        .padding(.horizontal, 30)

                    // ¿Olvidaste tu contraseña?
                    Button(action: {
                        // Acción para recuperar contraseña
                    }) {
                        Text("¿Olvidaste tu contraseña?")
                            .font(.subheadline)
                            .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 30)
                    .padding(.top, 5)
                    .padding(.bottom, 40)

                    
                    // Botón Iniciar Sesión
                    Button(action: {
                        Task {
                            await login() // Llamamos a la función login
                        }
                    }) {
                        Text("Iniciar Sesión")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(red: 0.0, green: 0.2, blue: 0.4))
                            .cornerRadius(10)
                            .padding(.horizontal, 30)
                    }
                    .padding(.bottom, 50)

                
                    
                    // ¿No tienes cuenta? Regístrate aquí
                    HStack (alignment: .bottom){
                        VStack{
                            Spacer()
                        }
                        Text("¿No tienes cuenta?")
                            .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                        NavigationLink(destination: ScreenRegister()) { // Navegación a ScreenRegister
                            Text("Regístrate aquí")
                                .fontWeight(.bold)
                                .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                        }
                    }
                }
            }
            .navigationBarHidden(true) // Oculta la barra de navegación por defecto
        }
    }
}

#Preview {
    ScreenLogin()
}
