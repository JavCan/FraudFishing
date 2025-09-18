//
//  ScreenRegister.swift
//  Fraud Fishing
//
//  Created by Javier Canella Ramos on 16/09/25.
//

import SwiftUI

struct ScreenRegister: View {
    @State private var nombre: String = ""
    @State private var correo: String = ""
    @State private var contrasena: String = ""
    @State private var confirmarContrasena: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var isLoading: Bool = false
    @State private var registroExitoso: Bool = false
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [
                Color(red: 1, green: 1, blue: 1),
                Color(red: 0.0, green: 0.8, blue: 0.7)]),
                           startPoint: UnitPoint(x:0.5, y:0.7),
                           endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
    
            ScrollView { // Agregado para manejar teclado
                VStack(spacing: 20) {
                    // Logo
                    Image("FRAUD FISHING-03")
                        .resizable()
                        .scaledToFit() // Cambiado de scaledToFill
                        .frame(width: 300, height: 180) // Tamaño más manejable
                        .padding(.top, 20)
                    
                    VStack(spacing: 15) {
                        // Campo de Nombre
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Nombre completo")
                                .font(.headline)
                                .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                                .frame(maxWidth: .infinity, alignment: .leading)

                            TextField("Ingresa nombre completo", text: $nombre)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(validarNombre() ? Color(red: 0.0, green: 0.2, blue: 0.4) : Color.red, lineWidth: 1)
                                )
                                .autocapitalization(.words)
                        }
                        
                        // Campo de Correo
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Correo electrónico")
                                .font(.headline)
                                .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                                .frame(maxWidth: .infinity, alignment: .leading)

                            TextField("ejemplo@correo.com", text: $correo)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(validarCorreo() ? Color(red: 0.0, green: 0.2, blue: 0.4) : Color.red, lineWidth: 1)
                                )
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .autocorrectionDisabled()
                        }
                        
                        // Campo de Contraseña
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Contraseña")
                                .font(.headline)
                                .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                                .frame(maxWidth: .infinity, alignment: .leading)

                            SecureField("Mínimo 6 caracteres", text: $contrasena)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(validarContrasena() ? Color(red: 0.0, green: 0.2, blue: 0.4) : Color.red, lineWidth: 1)
                                )
                            
                            // Indicadores de fortaleza de contraseña
                            if !contrasena.isEmpty {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("La contraseña debe tener:")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    
                                    HStack {
                                        Image(systemName: contrasena.count >= 6 ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(contrasena.count >= 6 ? .green : .red)
                                            .font(.caption)
                                        Text("Al menos 6 caracteres")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    HStack {
                                        Image(systemName: contrasenaContieneNumero() ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(contrasenaContieneNumero() ? .green : .red)
                                            .font(.caption)
                                        Text("Al menos un número")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .padding(.leading, 5)
                            }
                        }
                        
                        // Campo de Confirmar Contraseña
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Confirmar contraseña")
                                .font(.headline)
                                .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                                .frame(maxWidth: .infinity, alignment: .leading)

                            SecureField("Confirma tu contraseña", text: $confirmarContrasena)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(contrasena == confirmarContrasena && !confirmarContrasena.isEmpty ? Color(red: 0.0, green: 0.2, blue: 0.4) : Color.red, lineWidth: 1)
                                )
                            
                            if !confirmarContrasena.isEmpty && contrasena != confirmarContrasena {
                                Text("Las contraseñas no coinciden")
                                    .font(.caption)
                                    .foregroundColor(.red)
                                    .padding(.leading, 5)
                            }
                        }
                    }
                    .padding(.horizontal, 30)
                    
                    Spacer().frame(height: 30)
                    
                    // Botón Regístrate
                    Button(action: {
                        registrarUsuario()
                    }) {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .scaleEffect(0.8)
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            }
                            Text(isLoading ? "Registrando..." : "Registrate")
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(formularioValido() ? Color(red: 0.0, green: 0.2, blue: 0.4) : Color.gray)
                        .cornerRadius(10)
                        .padding(.horizontal, 30)
                    }
                    .disabled(!formularioValido() || isLoading)
                    .padding(.bottom, 50)
                }
            }
        }
        .alert("Registro", isPresented: $showAlert) {
            if registroExitoso {
                Button("Continuar") {
                    // Aquí navegarías a la siguiente pantalla
                }
            } else {
                Button("OK") { }
            }
        } message: {
            Text(alertMessage)
        }
    }
    
    // MARK: - Funciones de Validación
    
    private func validarNombre() -> Bool {
        return nombre.count >= 2
    }
    
    private func validarCorreo() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPred.evaluate(with: correo)
    }
    
    private func validarContrasena() -> Bool {
        return contrasena.count >= 6 && contrasenaContieneNumero()
    }
    
    private func contrasenaContieneNumero() -> Bool {
        return contrasena.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil
    }
    
    private func formularioValido() -> Bool {
        return validarNombre() && 
               validarCorreo() && 
               validarContrasena() && 
               contrasena == confirmarContrasena &&
               !confirmarContrasena.isEmpty
    }
    
    // MARK: - Función de Registro
    
    private func registrarUsuario() {
        isLoading = true
        
        // Simulación de llamada a API
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isLoading = false
            
            // Aquí harías la llamada real a tu API
            // Por ahora simulamos un registro exitoso
            registroExitoso = true
            alertMessage = "¡Registro exitoso! Bienvenido a Fraud Fishing."
            showAlert = true
            
            // Limpiar campos después del registro exitoso
            limpiarCampos()
        }
    }
    
    private func limpiarCampos() {
        nombre = ""
        correo = ""
        contrasena = ""
        confirmarContrasena = ""
    }
}

#Preview {
    ScreenRegister()
}