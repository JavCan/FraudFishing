//
//  ScreenRegister.swift
//  Fraud Fishing
//
//  Created by Javier Canella Ramos on 16/09/25.
//  Edited by Victor Bosquez on 18/09/25.

import SwiftUI

struct ScreenRegister: View {
    @Environment(\.authenticationController) private var authController
    @State private var nombre: String = ""
    @State private var correo: String = ""
    @State private var contrasena: String = ""
    @State private var confirmarContrasena: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var isLoading: Bool = false
    @State private var registroExitoso: Bool = false
    @State private var isPasswordVisible: Bool = false
    @State private var isConfirmPasswordVisible: Bool = false
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        ZStack {
            // Fondo con el mismo gradiente que ScreenLogin
            LinearGradient(gradient: Gradient(colors: [
                Color(red: 1, green: 1, blue: 1),
                Color(red: 0.0, green: 0.71, blue: 0.737)
            ]),
            startPoint: UnitPoint(x: 0.5, y: 0.7),
            endPoint: .bottom)
            .edgesIgnoringSafeArea(.all)

            ScrollView {
                VStack(spacing: 20) {
                    // Título "Registrar" (estilo similar a ScreenLogin)
                    Text("Registrarse")
                        .font(.poppinsMedium(size: 34))
                        .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 70)
                        .padding(.leading, 30)

                    // Campo: Nombre Completo (label gris arriba, ícono + texto, línea inferior)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Nombre Completo")
                            .font(.poppinsSemiBold(size: 14))
                            .foregroundColor(.gray)
                            .padding(.leading, 30)
                            .padding(.top, 15)

                        HStack {
                            Image(systemName: "person")
                                .foregroundColor(.gray)
                                .padding(.leading, 30)
                            TextField("Ingresa tu nombre completo", text: $nombre)
                                .font(.poppinsRegular(size: 18))
                                .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                                .padding(.vertical, 5)
                                .autocapitalization(.words)
                                .disabled(isLoading)
                        }
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.gray.opacity(0.5))
                            .padding(.horizontal, 30)
                    }

                    // Campo: Correo
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Correo")
                            .font(.poppinsSemiBold(size: 14))
                            .foregroundColor(.gray)
                            .padding(.leading, 30)

                        HStack {
                            Image(systemName: "envelope")
                                .foregroundColor(.gray)
                                .padding(.leading, 30)
                            TextField("ejemplo@correo.com", text: $correo)
                                .font(.poppinsRegular(size: 18))
                                .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                                .padding(.vertical, 5)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .autocorrectionDisabled()
                                .disabled(isLoading)
                        }
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.gray.opacity(0.5))
                            .padding(.horizontal, 30)
                    }

                    // Campo: Contraseña
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Contraseña")
                            .font(.poppinsSemiBold(size: 14))
                            .foregroundColor(.gray)
                            .padding(.leading, 30)

                        HStack {
                            Image(systemName: "lock")
                                .foregroundColor(.gray)
                                .padding(.leading, 30)
                                .padding(.horizontal, 4)

                            if isPasswordVisible {
                                TextField("••••••••", text: $contrasena)
                                    .font(.poppinsRegular(size: 18))
                                    .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                                    .padding(.vertical, 5)
                                    .disabled(isLoading)
                            } else {
                                SecureField("••••••••", text: $contrasena)
                                    .font(.poppinsRegular(size: 18))
                                    .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                                    .padding(.vertical, 5)
                                    .disabled(isLoading)
                            }

                            Button(action: {
                                isPasswordVisible.toggle()
                            }) {
                                Image(systemName: isPasswordVisible ? "eye.fill" : "eye.slash.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 30)
                            }
                        }

                        // Indicadores de fortaleza de contraseña (agregados)
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
                            .padding(.leading, 30) // alineado con el contenido del campo
                        }

                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.gray.opacity(0.5))
                            .padding(.horizontal, 30)
                    }
                

                    // Campo: Confirmar Contraseña
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Confirmar Contraseña")
                            .font(.poppinsSemiBold(size: 14))
                            .foregroundColor(.gray)
                            .padding(.leading, 30)

                        HStack {
                            Image(systemName: "lock")
                                .foregroundColor(.gray)
                                .padding(.leading, 30)
                                .padding(.horizontal, 4)

                            if isConfirmPasswordVisible {
                                TextField("••••••••", text: $confirmarContrasena)
                                    .font(.poppinsRegular(size: 18))
                                    .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                                    .padding(.vertical, 5)
                                    .disabled(isLoading)
                            } else {
                                SecureField("••••••••", text: $confirmarContrasena)
                                    .font(.poppinsRegular(size: 18))
                                    .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                                    .padding(.vertical, 5)
                                    .disabled(isLoading)
                            }

                            Button(action: {
                                isConfirmPasswordVisible.toggle()
                            }) {
                                Image(systemName: isConfirmPasswordVisible ? "eye.fill" : "eye.slash.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 30)
                            }
                        }

                        // Mensaje de validación (coincidencia)
                        if !confirmarContrasena.isEmpty && contrasena != confirmarContrasena {
                            Text("Las contraseñas no coinciden")
                                .font(.caption)
                                .foregroundColor(.red)
                                .padding(.leading, 30)
                        }

                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.gray.opacity(0.5))
                            .padding(.horizontal, 30)
                    }

                    // Botón Registrarse (estilo consistente con ScreenLogin)
                    Button(action: {
                        Task {
                            await registrarUsuario()
                        }
                    }) {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .scaleEffect(0.8)
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            }
                            Text(isLoading ? "Registrando..." : "Registrarse")
                                .font(.poppinsBold(size: 20))
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(formularioValido() && !isLoading ? Color(red: 0.0, green: 0.2, blue: 0.4) : Color.gray)
                        .cornerRadius(10)
                        .padding(.horizontal, 30)
                    }
                    .disabled(!formularioValido() || isLoading)

                    // ¿Ya tengo una cuenta? Iniciar Sesión
                    HStack(spacing: 4) {
                        Text("Ya tengo una cuenta.")
                            .font(.poppinsRegular(size: 17))
                            .foregroundColor(.gray)

                        NavigationLink(destination: ScreenLogin()) {
                            Text("Iniciar Sesión")
                                .font(.poppinsBold(size: 17))
                                .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 8)
                    .padding(.bottom, 40)
                }
            }
        }
        // Al mostrar esta vista dentro de una NavigationView, ocultamos el back predeterminado y usamos uno personalizado
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 36, height: 36)
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                            .font(.system(size: 16, weight: .semibold))
                    }
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
        return nombre.trimmingCharacters(in: .whitespacesAndNewlines).count >= 2
    }
    
    private func validarCorreo() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPred.evaluate(with: correo.trimmingCharacters(in: .whitespacesAndNewlines))
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
    
    @MainActor
    private func registrarUsuario() async {
        isLoading = true
        
        do {
            let response = try await authController.registerUser(
                name: nombre.trimmingCharacters(in: .whitespacesAndNewlines),
                email: correo.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(),
                password: contrasena
            
            )
            // Registro exitoso
            registroExitoso = true
            alertMessage = "¡Registro exitoso! Bienvenido "
            showAlert = true
            
            // Limpiar campos después del registro exitoso
            limpiarCampos()
            
        } catch {
            // Manejar errores
            alertMessage = "Error en el registro. Por favor intenta de nuevo."
            showAlert = true
            registroExitoso = false
        }
        
        isLoading = false
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
