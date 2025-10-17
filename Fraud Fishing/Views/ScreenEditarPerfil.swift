import SwiftUI

// MARK: - Vista Principal: Editar Perfil
struct ScreenEditarPerfil: View {
    @StateObject private var profileController = UserProfileController()
    @Environment(\.dismiss) private var dismiss
    
    // Estados para controlar las vistas modales (sheets).
    @State private var showChangeNameSheet: Bool = false
    @State private var showChangePasswordSheet: Bool = false
    // ✅ 1. AÑADIDO: El estado que faltaba para la hoja de correo.
    @State private var showChangeEmailSheet: Bool = false

    var body: some View {
        ZStack {
            // Fondo oscuro consistente.
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.043, green: 0.067, blue: 0.173, opacity: 0.88),
                    Color(red: 0.043, green: 0.067, blue: 0.173)
                ]),
                startPoint: .top, endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                // Header (sin cambios)
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white).padding(10)
                            .background(Color.white.opacity(0.1)).clipShape(Circle())
                    }
                    Spacer()
                    Text("Editar Perfil").font(.title2).fontWeight(.bold).foregroundColor(.white)
                    Spacer()
                    Color.clear.frame(width: 40, height: 40)
                }
                .padding(.horizontal).padding(.top)

                // Contenido dinámico (Cargando / Perfil / Error)
                if profileController.isLoading && profileController.userProfile == nil {
                    Spacer()
                    ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .white))
                    Spacer()
                } else if let profile = profileController.userProfile {
                    // ✅ 2. CORREGIDO: Pasamos el nuevo binding a la vista de contenido.
                    UserProfileContentView(profile: profile,
                                         showChangeNameSheet: $showChangeNameSheet,
                                         showChangePasswordSheet: $showChangePasswordSheet,
                                         showChangeEmailSheet: $showChangeEmailSheet)
                } else if let errorMessage = profileController.errorMessage {
                    Spacer()
                    Text(errorMessage).foregroundColor(.red).padding().multilineTextAlignment(.center)
                    Spacer()
                }
            }
        }
        .navigationBarHidden(true)
        .task {
            // Carga el perfil cuando la vista aparece.
            await profileController.fetchUserProfile()
        }
        .sheet(isPresented: $showChangeNameSheet) {
            ChangeNameView(profileController: profileController)
        }
        .sheet(isPresented: $showChangePasswordSheet) {
            ChangePasswordView(profileController: profileController)
        }
        // ✅ 3. AÑADIDO: El .sheet que faltaba para el correo.
        .sheet(isPresented: $showChangeEmailSheet) {
            ChangeEmailView(profileController: profileController)
        }
        .overlay {
            // Muestra un indicador de carga durante las actualizaciones.
            if profileController.isLoading && profileController.userProfile != nil {
                Color.black.opacity(0.4).ignoresSafeArea()
                ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .white))
            }
        }
    }
}

// MARK: - Vista del Contenido del Perfil
struct UserProfileContentView: View {
    let profile: UserProfile
    @Binding var showChangeNameSheet: Bool
    @Binding var showChangePasswordSheet: Bool
    @Binding var showChangeEmailSheet: Bool

    var body: some View {
        VStack {
            VStack(spacing: 15) {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 80)).foregroundColor(.white.opacity(0.8))
                
                Text(profile.name)
                    .font(.title).fontWeight(.bold).foregroundColor(.white)
            }
            .padding(.vertical, 20)

            VStack(spacing: 0) {
                ProfileRow(title: "Nombre", value: profile.name, action: { showChangeNameSheet = true })
                ProfileRow(title: "Correo", value: profile.email, action: { showChangeEmailSheet = true })
                ProfileRow(title: "Contraseña", value: "••••••••", action: { showChangePasswordSheet = true })
            }
            .background(Color.white.opacity(0.1)).cornerRadius(10).padding(.horizontal)
            
            Spacer()
        }
    }
}

// MARK: - Componente reutilizable para las Filas de Opciones
struct ProfileRow: View {
    let title: String
    let value: String
    var action: (() -> Void)?

    var body: some View {
        Button(action: { action?() }) {
            VStack(spacing: 0) {
                HStack {
                    Text(title).foregroundColor(.white.opacity(0.8))
                    Spacer()
                    Text(value).foregroundColor(.white).lineLimit(1)
                    if action != nil {
                        Image(systemName: "chevron.right").foregroundColor(.white.opacity(0.5))
                    }
                }
                .padding()
                Divider().background(Color.white.opacity(0.2)).padding(.leading)
            }
        }
        .disabled(action == nil)
    }
}

// MARK: - Vista Modal para Cambiar Nombre
struct ChangeNameView: View {
    @ObservedObject var profileController: UserProfileController
    @Environment(\.dismiss) private var dismiss
    @State private var newName: String = ""

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(red: 0.043, green: 0.067, blue: 0.173, opacity: 0.88), Color(red: 0.043, green: 0.067, blue: 0.173)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                Text("Cambiar Nombre").font(.title2).fontWeight(.bold).foregroundColor(.white).padding()
                
                TextField("Nuevo nombre", text: $newName)
                    .foregroundColor(.white).padding()
                    .background(Color.white.opacity(0.1)).cornerRadius(10)
                
                Button("Guardar") {
                    Task {
                        let success = await profileController.updateName(newName)
                        if success { dismiss() }
                    }
                }
                .font(.headline).fontWeight(.bold).foregroundColor(.white)
                .padding().frame(maxWidth: .infinity)
                .background(Color(red: 0.0, green: 0.2, blue: 0.4)).cornerRadius(10)
                
                Spacer()
            }
            .padding()
            .onAppear { self.newName = profileController.userProfile?.name ?? "" }
            .overlay {
                if profileController.isLoading {
                    Color.black.opacity(0.4).ignoresSafeArea()
                    ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .white))
                }
            }
        }
    }
}

// MARK: - Change Email View
struct ChangeEmailView: View {
    @ObservedObject var profileController: UserProfileController
    @Environment(\.dismiss) private var dismiss
    
    @State private var newEmail: String = ""

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(red: 0.043, green: 0.067, blue: 0.173, opacity: 0.88), Color(red: 0.043, green: 0.067, blue: 0.173)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                Text("Cambiar Correo").font(.title2).fontWeight(.bold).foregroundColor(.white).padding()
                
                TextField("Nuevo correo electrónico", text: $newEmail)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(10)
                    .keyboardType(.emailAddress) // Teclado especial para correos
                    .autocapitalization(.none)
                
                if let errorMessage = profileController.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }

                Button("Guardar") {
                    Task {
                        // Llama a la nueva función de actualización del controlador
                        let success = await profileController.updateEmail(newEmail)
                        if success {
                            dismiss() // Cierra la hoja solo si la actualización fue exitosa
                        }
                    }
                }
                .font(.headline).fontWeight(.bold).foregroundColor(.white)
                .padding().frame(maxWidth: .infinity)
                .background(Color(red: 0.0, green: 0.2, blue: 0.4)).cornerRadius(10)
                
                Spacer()
            }
            .padding()
            .onAppear {
                // Precarga el campo de texto con el correo actual
                self.newEmail = profileController.userProfile?.email ?? ""
            }
            .overlay {
                // Muestra un indicador de carga si la vista está ocupada
                if profileController.isLoading {
                    Color.black.opacity(0.4).ignoresSafeArea()
                    ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .white))
                }
            }
        }
    }
}

// MARK: - Vista Modal para Cambiar Contraseña
struct ChangePasswordView: View {
    @ObservedObject var profileController: UserProfileController
    @Environment(\.dismiss) private var dismiss
    
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(red: 0.043, green: 0.067, blue: 0.173, opacity: 0.88), Color(red: 0.043, green: 0.067, blue: 0.173)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                Text("Cambiar Contraseña").font(.title2).fontWeight(.bold).foregroundColor(.white).padding()
                
                VStack(spacing: 20) {
                    SecureField("Nueva contraseña", text: $newPassword)
                        .foregroundColor(.white).padding()
                        .background(Color.white.opacity(0.1)).cornerRadius(10)
                    
                    SecureField("Confirmar nueva contraseña", text: $confirmPassword)
                        .foregroundColor(.white).padding()
                        .background(Color.white.opacity(0.1)).cornerRadius(10)
                }
                
                if let errorMessage = profileController.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }

                Button("Guardar") {
                    Task {
                        // Llama a la nueva función de actualización del controlador
                        let success = await profileController.updatePassword(
                            newPassword: newPassword,
                            confirmation: confirmPassword
                        )
                        if success {
                            dismiss()
                        }
                    }
                }
                .font(.headline).fontWeight(.bold).foregroundColor(.white)
                .padding().frame(maxWidth: .infinity)
                .background(Color(red: 0.0, green: 0.2, blue: 0.4)).cornerRadius(10)
                
                Spacer()
            }
            .padding()
            .overlay {
                // Muestra un indicador de carga si solo esta vista está ocupada
                if profileController.isLoading {
                    Color.black.opacity(0.4).ignoresSafeArea()
                    ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .white))
                }
            }
        }
    }
}

// MARK: - Vista Previa con Token Hardcodeado
#Preview {
    // 1. Pega aquí un token JWT válido que obtengas de un inicio de sesión exitoso.
    let hardcodedToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMCIsInR5cGUiOiJhY2Nlc3MiLCJwcm9maWxlIjp7ImlkIjoiMTAiLCJlbWFpbCI6InBydWViYUBwcnVlYmEuY29tIiwibmFtZSI6IlN1cGVyIFBydWViYSIsImlzX2FkbWluIjowLCJpc19zdXBlcl9hZG1pbiI6MH0sImlhdCI6MTc2MDY3NDYxNSwiZXhwIjoxNzYwNjc1MjE1fQ.Iiu5cSzFPQbW6fr1HsEj2d2BOz_u9mNc9NMAJOQ9HoQ"
    
    // 2. Simulamos el guardado del token antes de mostrar la vista.
    let _ = TokenStorage.set(.access, value: hardcodedToken)
    
    // 3. Ahora la vista previa puede hacer la llamada de red autenticada.
    return ScreenEditarPerfil()
}
