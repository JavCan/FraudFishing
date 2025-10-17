import SwiftUI

struct ScreenAjustes: View {
    @Environment(\.dismiss) private var dismiss
    @State private var notificacionesActivadas: Bool = true
    @State private var showLogoutAlert: Bool = false
    
    // Aquí iría la lógica para navegar a la pantalla de login después de cerrar sesión.
    
    var body: some View {
        ZStack {
            // MARK: - Fondo
            // Reutilizamos el gradiente oscuro de tu pantalla de login.
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.043, green: 0.067, blue: 0.173, opacity: 0.88),
                    Color(red: 0.043, green: 0.067, blue: 0.173)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // MARK: - Header Personalizado
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white).padding(10)
                            .background(Color.white.opacity(0.1)).clipShape(Circle())
                    }
                    Spacer()
                    Text("Ajustes")
                        .font(.title2).fontWeight(.bold).foregroundColor(.white)
                    Spacer()
                    Color.clear.frame(width: 40, height: 40)
                }
                .padding(.horizontal)
                .padding(.vertical)
                
                // MARK: - Opciones de Ajustes
                // Usamos un ScrollView por si en el futuro agregas más opciones.
                ScrollView {
                    VStack(spacing: 35) {
                        // --- Sección de Notificaciones ---
                        SettingsSection(title: "NOTIFICACIONES") {
                            Toggle(isOn: $notificacionesActivadas) {
                                HStack(spacing: 15) {
                                    Image(systemName: "bell.badge.fill")
                                        .foregroundColor(.purple).frame(width: 25, alignment: .center)
                                    Text("Notificaciones Push").foregroundColor(.white)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                            .tint(.cyan)
                        }
                        
                        // --- Sección de Ayuda y Soporte ---
                        SettingsSection(title: "REPORTES") {
                            SettingsRow(icon: "hourglass", title: "Reportes Pendientes", tintColor: .orange)
                            Divider().background(Color.white.opacity(0.2)).padding(.leading, 60)
                            SettingsRow(icon: "checkmark.shield.fill", title: "Reportes Aceptados", tintColor: .green)
                        }
                        
                        // --- Sección Legal ---
                        SettingsSection(title: "LEGAL") {
                            SettingsRow(icon: "doc.text.fill", title: "Términos y Condiciones", tintColor: .gray)
                            Divider().background(Color.white.opacity(0.2)).padding(.leading, 60)
                            SettingsRow(icon: "shield.lefthalf.filled", title: "Política de Privacidad", tintColor: .blue)
                        }
                    }
                    .padding(.top)
                }
            }
        }
    }
}

// MARK: - Componentes Reutilizables para Mejor Estructura

struct SettingsSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.footnote)
                .fontWeight(.semibold)
                .foregroundColor(.white.opacity(0.6))
                .padding(.horizontal)
            
            VStack(spacing: 0) {
                content
            }
            .background(Color.white.opacity(0.1))
            .cornerRadius(10)
        }
        .padding(.horizontal)
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let tintColor: Color

    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .foregroundColor(tintColor)
                .frame(width: 25, alignment: .center)
            
            Text(title)
                .foregroundColor(.white)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white.opacity(0.5))
        }
        .padding()
    }
}

// MARK: - Vista Previa
#Preview {
    NavigationStack {
        ScreenAjustes()
    }
}
