//
//  ScreenRegister.swift
//  Fraud Fishing
//
//  Created by Javier Canella Ramos on 16/09/25.
//  Edited by Victor Bosquez on 18/09/25.
//  Dark mode + unified design by ChatGPT (2025)

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
            // 🔹 Fondo igual que ScreenLogin
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.043, green: 0.067, blue: 0.173, opacity: 0.88),
                    Color(red: 0.043, green: 0.067, blue: 0.173)
                ]),
                startPoint: UnitPoint(x: 0.5, y: 0.1),
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)

            ScrollView {
                VStack(spacing: 25) {
                    // 🔹 Título
                    Text("Registrarse")
                        .font(.poppinsMedium(size: 34))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 70)
                        .padding(.leading, 30)

                    // MARK: - Campo Nombre
                    customTextField(
                        label: "Nombre Completo",
                        icon: "person",
                        placeholder: "Ingresa tu nombre completo",
                        text: $nombre,
                        isSecure: false
                    )

                    // MARK: - Campo Correo
                    customTextField(
                        label: "Correo",
                        icon: "envelope",
                        placeholder: "ejemplo@correo.com",
                        text: $correo,
                        isSecure: false,
                        keyboardType: .emailAddress,
                        autocapitalization: .never
                    )

                    // MARK: - Campo Contraseña
                    customTextField(
                        label: "Contraseña",
                        icon: "lock",
                        placeholder: "••••••••",
                        text: $contrasena,
                        isSecure: !isPasswordVisible,
                        trailingIcon: isPasswordVisible ? "eye.fill" : "eye.slash.fill",
                        autocapitalization: .never,
                        onTrailingTap: { isPasswordVisible.toggle() }
                    )

                    // Indicadores de fortaleza
                    if !contrasena.isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Image(systemName: contrasena.count >= 6 ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(contrasena.count >= 6 ? .green : .red)
                                Text("Al menos 6 caracteres")
                            }
                            HStack {
                                Image(systemName: contrasenaContieneNumero() ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(contrasenaContieneNumero() ? .green : .red)
                                Text("Al menos un número")
                            }
                        }
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.leading, 38)
                    }

                    // MARK: - Confirmar Contraseña
                    customTextField(
                        label: "Confirmar Contraseña",
                        icon: "lock",
                        placeholder: "••••••••",
                        text: $confirmarContrasena,
                        isSecure: !isConfirmPasswordVisible,
                        trailingIcon: isConfirmPasswordVisible ? "eye.fill" : "eye.slash.fill",
                        autocapitalization: .never,
                        onTrailingTap: { isConfirmPasswordVisible.toggle() }
                    )

                    if !confirmarContrasena.isEmpty && contrasena != confirmarContrasena {
                        Text("Las contraseñas no coinciden")
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.leading, 38)
                    }

                    // MARK: - Botón Registrarse
                    Button(action: {
                        Task { await registrarUsuario() }
                    }) {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Registrarse")
                                    .font(.poppinsBold(size: 20))
                            }
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(formularioValido() && !isLoading ? Color(red: 0.0, green: 0.2, blue: 0.4) : Color.gray)
                        .cornerRadius(10)
                        .padding(.horizontal, 30)
                    }
                    .disabled(!formularioValido() || isLoading)
                    .padding(.top, 10)

                    // MARK: - Ya tengo cuenta
                    HStack {
                        Text("Ya tengo una cuenta.")
                            .font(.poppinsRegular(size: 17))
                            .foregroundColor(.white.opacity(0.8))
                        NavigationLink(destination: ScreenLogin()) {
                            Text("Iniciar Sesión")
                                .font(.poppinsBold(size: 17))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 80)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.1))
                            .frame(width: 36, height: 36)
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .semibold))
                    }
                }
            }
        }
        .alert("Registro", isPresented: $showAlert) {
            if registroExitoso {
                Button("Continuar") {}
            } else {
                Button("OK") {}
            }
        } message: {
            Text(alertMessage)
        }
    }

    // MARK: - Subcomponentes reutilizables
    @ViewBuilder
    func customTextField(
        label: String,
        icon: String,
        placeholder: String,
        text: Binding<String>,
        isSecure: Bool,
        trailingIcon: String? = nil,
        keyboardType: UIKeyboardType = .default,
        autocapitalization: TextInputAutocapitalization = .sentences,
        onTrailingTap: (() -> Void)? = nil
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.poppinsSemiBold(size: 14))
                .foregroundColor(.white.opacity(0.8))
                .padding(.leading, 30)

            HStack {
                Image(systemName: icon)
                    .foregroundColor(.white.opacity(0.6))
                    .padding(.leading, 30)

                ZStack(alignment: .leading) {
                    if text.wrappedValue.isEmpty {
                        Text(placeholder)
                            .font(.poppinsRegular(size: 18))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    if isSecure {
                        SecureField("", text: text)
                            .font(.poppinsRegular(size: 18))
                            .foregroundColor(.white)
                            .keyboardType(keyboardType)
                            .padding(.vertical, 5)
                    } else {
                        TextField("", text: text)
                            .font(.poppinsRegular(size: 18))
                            .foregroundColor(.white)
                            .foregroundColor(.white)
                            .keyboardType(keyboardType)
                            .padding(.vertical, 5)
                    }
                }

                if let trailingIcon = trailingIcon {
                    Button(action: { onTrailingTap?() }) {
                        Image(systemName: trailingIcon)
                            .foregroundColor(.white.opacity(0.6))
                            .padding(.trailing, 30)
                    }
                }
            }
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.white.opacity(0.5))
                .padding(.horizontal, 30)
        }
    }

    // MARK: - Validaciones
    private func validarNombre() -> Bool { nombre.trimmingCharacters(in: .whitespacesAndNewlines).count >= 2 }
    private func validarCorreo() -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format:"SELF MATCHES %@", regex)
            .evaluate(with: correo.trimmingCharacters(in: .whitespacesAndNewlines))
    }
    private func validarContrasena() -> Bool {
        contrasena.count >= 6 && contrasenaContieneNumero()
    }
    private func contrasenaContieneNumero() -> Bool {
        contrasena.rangeOfCharacter(from: .decimalDigits) != nil
    }
    private func formularioValido() -> Bool {
        validarNombre() && validarCorreo() && validarContrasena() && contrasena == confirmarContrasena && !confirmarContrasena.isEmpty
    }

    // MARK: - Registro
    @MainActor
    private func registrarUsuario() async {
        isLoading = true
        do {
            _ = try await authController.registerUser(
                name: nombre.trimmingCharacters(in: .whitespacesAndNewlines),
                email: correo.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(),
                password: contrasena
            )
            registroExitoso = true
            alertMessage = "¡Registro exitoso! Bienvenido."
            showAlert = true
            limpiarCampos()
        } catch {
            registroExitoso = false
            alertMessage = "Error en el registro. Inténtalo de nuevo."
            showAlert = true
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
