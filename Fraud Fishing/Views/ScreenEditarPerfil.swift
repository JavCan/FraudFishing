//
//  ScreenEditarPerfil.swift
//  Fraud Fishing
//
//  Created by Victor Bosquez on 30/09/25.
//

import SwiftUI

struct ScreenEditarPerfil: View {
    @Environment(\.dismiss) private var dismiss
    @State private var nombre: String = "Juan Rodrigo Ferro Rayón"
    @State private var correo: String = "juan.ferro@gmail.com"
    @State private var contrasena: String = "••••••••"
    @State private var numeroReportes: Int = 4
    
    @State private var showChangeEmailSheet: Bool = false
    @State private var showChangeNameSheet: Bool = false
    @State private var showChangePasswordSheet: Bool = false
    
    var body: some View {
        ZStack {
            // Fondo con gradiente
            LinearGradient(gradient: Gradient(colors: [
                Color(red: 1, green: 1, blue: 1),
                Color(red: 0.0, green: 0.8, blue: 0.7)]),
                           startPoint: UnitPoint(x:0.5, y:0.7),
                           endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // MARK: - Header con información del usuario
                VStack(spacing: 8) {
                    // Nombre del usuario
                    Text(obtenerPrimerNombre())
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                    
                    // Número de reportes
                    Text("\(numeroReportes) Reportes")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top, 40)
                .padding(.bottom, 40)
                
                // MARK: - Sección de Correo
                VStack(alignment: .leading, spacing: 8) {
                    Text("Correo")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.leading, 30)
                    
                    HStack(spacing: 12) {
                        Image(systemName: "envelope")
                            .foregroundColor(.gray)
                            .font(.system(size: 18))
                        
                        Text(correo)
                            .font(.body)
                            .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                        
                        Spacer()
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
                    .padding(.horizontal, 30)
                    
                    // Botón Cambiar Correo
                    Button(action: {
                        showChangeEmailSheet = true
                    }) {
                        Text("Cambiar Correo")
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 0.0, green: 0.2, blue: 0.4))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 8)
                }
                .padding(.bottom, 30)
                
                // MARK: - Sección de Nombre
                VStack(alignment: .leading, spacing: 8) {
                    Text("Nombre")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.leading, 30)
                    
                    HStack(spacing: 12) {
                        Image(systemName: "person")
                            .foregroundColor(.gray)
                            .font(.system(size: 18))
                        
                        Text(nombre)
                            .font(.body)
                            .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                        
                        Spacer()
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
                    .padding(.horizontal, 30)
                    
                    // Botón Cambiar Nombre
                    Button(action: {
                        showChangeNameSheet = true
                    }) {
                        Text("Cambiar Nombre")
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 0.0, green: 0.2, blue: 0.4))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 8)
                }
                .padding(.bottom, 30)
                
                // MARK: - Sección de Contraseña
                VStack(alignment: .leading, spacing: 8) {
                    Text("Contraseña")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.leading, 30)
                    
                    HStack(spacing: 12) {
                        Image(systemName: "lock")
                            .foregroundColor(.gray)
                            .font(.system(size: 18))
                        
                        Text(contrasena)
                            .font(.body)
                            .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                        
                        Spacer()
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
                    .padding(.horizontal, 30)
                    
                    // Botón Cambiar Contraseña
                    Button(action: {
                        showChangePasswordSheet = true
                    }) {
                        Text("Cambiar Contraseña")
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 0.0, green: 0.2, blue: 0.4))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 8)
                }
                
                Spacer()
            }
        }
        .navigationTitle("Editar Perfil")
        .navigationBarTitleDisplayMode(.inline)
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
        .sheet(isPresented: $showChangeEmailSheet) {
            ChangeEmailSheet(correo: $correo)
        }
        .sheet(isPresented: $showChangeNameSheet) {
            ChangeNameSheet(nombre: $nombre)
        }
        .sheet(isPresented: $showChangePasswordSheet) {
            ChangePasswordSheet()
        }
    }
    
    // MARK: - Funciones Auxiliares
    
    private func obtenerPrimerNombre() -> String {
        return nombre.components(separatedBy: " ").first ?? "Usuario"
    }
}

// MARK: - Sheet para Cambiar Correo

struct ChangeEmailSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var correo: String
    @State private var nuevoCorreo: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.95, green: 0.95, blue: 0.97)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    Text("Ingresa tu nuevo correo electrónico")
                        .font(.body)
                        .foregroundColor(.gray)
                        .padding(.top, 20)
                    
                    TextField("nuevo@correo.com", text: $nuevoCorreo)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                        .padding(.horizontal, 30)
                    
                    Button(action: {
                        if validarCorreo(nuevoCorreo) {
                            correo = nuevoCorreo
                            dismiss()
                        } else {
                            alertMessage = "Por favor ingresa un correo válido"
                            showAlert = true
                        }
                    }) {
                        Text("Guardar")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 0.0, green: 0.2, blue: 0.4))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 30)
                    
                    Spacer()
                }
            }
            .navigationTitle("Cambiar Correo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancelar") {
                        dismiss()
                    }
                    .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                }
            }
            .alert("Error", isPresented: $showAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private func validarCorreo(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPred.evaluate(with: email)
    }
}

// MARK: - Sheet para Cambiar Nombre

struct ChangeNameSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var nombre: String
    @State private var nuevoNombre: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.95, green: 0.95, blue: 0.97)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    Text("Ingresa tu nuevo nombre completo")
                        .font(.body)
                        .foregroundColor(.gray)
                        .padding(.top, 20)
                    
                    TextField("Nombre completo", text: $nuevoNombre)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .autocapitalization(.words)
                        .padding(.horizontal, 30)
                    
                    Button(action: {
                        if nuevoNombre.trimmingCharacters(in: .whitespacesAndNewlines).count >= 2 {
                            nombre = nuevoNombre
                            dismiss()
                        } else {
                            alertMessage = "Por favor ingresa un nombre válido"
                            showAlert = true
                        }
                    }) {
                        Text("Guardar")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 0.0, green: 0.2, blue: 0.4))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 30)
                    
                    Spacer()
                }
            }
            .navigationTitle("Cambiar Nombre")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancelar") {
                        dismiss()
                    }
                    .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                }
            }
            .alert("Error", isPresented: $showAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
            }
        }
    }
}

// MARK: - Sheet para Cambiar Contraseña

struct ChangePasswordSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var contrasenaActual: String = ""
    @State private var nuevaContrasena: String = ""
    @State private var confirmarContrasena: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.95, green: 0.95, blue: 0.97)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    Text("Ingresa tu contraseña actual y la nueva")
                        .font(.body)
                        .foregroundColor(.gray)
                        .padding(.top, 20)
                        .padding(.horizontal, 30)
                    
                    SecureField("Contraseña actual", text: $contrasenaActual)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 30)
                    
                    SecureField("Nueva contraseña", text: $nuevaContrasena)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 30)
                    
                    SecureField("Confirmar nueva contraseña", text: $confirmarContrasena)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 30)
                    
                    if !nuevaContrasena.isEmpty {
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Image(systemName: nuevaContrasena.count >= 6 ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(nuevaContrasena.count >= 6 ? .green : .red)
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
                        .padding(.horizontal, 30)
                    }
                    
                    Button(action: {
                        validarYCambiarContrasena()
                    }) {
                        Text("Guardar")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 0.0, green: 0.2, blue: 0.4))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 10)
                    
                    Spacer()
                }
            }
            .navigationTitle("Cambiar Contraseña")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancelar") {
                        dismiss()
                    }
                    .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                }
            }
            .alert("Atención", isPresented: $showAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private func contrasenaContieneNumero() -> Bool {
        return nuevaContrasena.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil
    }
    
    private func validarYCambiarContrasena() {
        guard !contrasenaActual.isEmpty else {
            alertMessage = "Por favor ingresa tu contraseña actual"
            showAlert = true
            return
        }
        
        guard nuevaContrasena.count >= 6 && contrasenaContieneNumero() else {
            alertMessage = "La nueva contraseña debe tener al menos 6 caracteres y un número"
            showAlert = true
            return
        }
        
        guard nuevaContrasena == confirmarContrasena else {
            alertMessage = "Las contraseñas no coinciden"
            showAlert = true
            return
        }
        
        // Aquí implementarías la llamada a la API para cambiar la contraseña
        alertMessage = "Contraseña actualizada exitosamente"
        showAlert = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            dismiss()
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationView {
        ScreenEditarPerfil()
    }
}