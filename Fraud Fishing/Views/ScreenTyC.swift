//
//  ScreenTerminosCondiciones.swift
//  Fraud Fishing
//
//  Created by Victor Bosquez on 01/10/25.
//

import SwiftUI

struct ScreenTerminosCondiciones: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            // 🔹 Fondo azul tipo ScreenLogin
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.043, green: 0.067, blue: 0.173, opacity: 0.88),
                    Color(red: 0.043, green: 0.067, blue: 0.173)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // MARK: - Título
                    Text("Términos y Condiciones")
                        .font(.poppinsMedium(size: 30))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 20)
                    
                    Text("Al descargar y utilizar Fraud Fishing, usted acepta los siguientes términos y condiciones:")
                        .font(.poppinsRegular(size: 16))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 25)
                        .padding(.bottom, 10)
                    
                    // MARK: - Secciones
                    TerminoSeccion(
                        numero: "1.",
                        titulo: "Uso de la App",
                        contenido: "La App se proporciona para fines informativos. Usted se compromete a usarla de manera legal y responsable."
                    )
                    
                    TerminoSeccion(
                        numero: "2.",
                        titulo: "Propiedad intelectual",
                        contenido: "Todo el contenido, diseño y funciones de la App son propiedad del desarrollador. No está permitido copiar, modificar o distribuir dicho contenido sin autorización previa."
                    )
                    
                    TerminoSeccion(
                        numero: "3.",
                        titulo: "Limitación de responsabilidad",
                        contenido: "La App se ofrece 'tal cual' y no garantizamos que esté libre de errores o interrupciones. El desarrollador no se hace responsable por daños derivados del uso de la App."
                    )
                    
                    TerminoSeccion(
                        numero: "4.",
                        titulo: "Datos personales",
                        contenido: "El uso de la App implica el tratamiento de datos personales conforme a nuestro Aviso de Privacidad."
                    )
                    
                    TerminoSeccion(
                        numero: "5.",
                        titulo: "Modificaciones",
                        contenido: "El desarrollador podrá modificar estos Términos y Condiciones en cualquier momento, publicando las actualizaciones en la App."
                    )
                    
                    Text("Si no está de acuerdo con estos términos, le solicitamos no utilizar la App.")
                        .font(.poppinsRegular(size: 16))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 25)
                        .padding(.bottom, 40)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                        Text("Ajustes")
                            .font(.poppinsRegular(size: 18))
                    }
                    .foregroundColor(.white)
                }
            }
        }
        .toolbarBackground(Color(red: 0.043, green: 0.067, blue: 0.173), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

struct TerminoSeccion: View {
    let numero: String
    let titulo: String
    let contenido: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 4) {
                Text(numero)
                    .font(.poppinsSemiBold(size: 16))
                    .foregroundColor(.white)
                Text(titulo)
                    .font(.poppinsSemiBold(size: 16))
                    .foregroundColor(.white)
                    .underline()
            }
            Text(contenido)
                .font(.poppinsRegular(size: 15))
                .foregroundColor(.white.opacity(0.9))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.leading, 12)
        }
        .padding(.horizontal, 25)
    }
}


// MARK: - Pantalla de Aviso de Privacidad

struct ScreenAvisoPrivacidad: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            // 🔹 Fondo azul igual al de ScreenLogin
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.043, green: 0.067, blue: 0.173, opacity: 0.88),
                    Color(red: 0.043, green: 0.067, blue: 0.173)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // MARK: - Título principal
                    Text("Aviso de Privacidad")
                        .font(.poppinsMedium(size: 30))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 20)
                    
                    // MARK: - Texto introductorio
                    Text("En Fraud Fishing, respetamos y protegemos la privacidad de nuestros usuarios. Este aviso describe cómo recopilamos, usamos y protegemos su información personal.")
                        .font(.poppinsRegular(size: 16))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 25)
                        .padding(.bottom, 10)
                    
                    // MARK: - Secciones
                    PrivacidadSeccion(
                        numero: "1.",
                        titulo: "Información que recopilamos",
                        contenido: "Recopilamos información personal que usted nos proporciona directamente, como nombre, correo electrónico y datos de registro. También recopilamos información sobre los reportes que realiza en la aplicación."
                    )
                    
                    PrivacidadSeccion(
                        numero: "2.",
                        titulo: "Uso de la información",
                        contenido: "Utilizamos su información para proporcionar y mejorar nuestros servicios, procesar sus reportes de fraude, comunicarnos con usted y garantizar la seguridad de la plataforma."
                    )
                    
                    PrivacidadSeccion(
                        numero: "3.",
                        titulo: "Protección de datos",
                        contenido: "Implementamos medidas de seguridad técnicas y organizativas para proteger su información personal contra accesos no autorizados, pérdida o alteración."
                    )
                    
                    PrivacidadSeccion(
                        numero: "4.",
                        titulo: "Compartir información",
                        contenido: "No vendemos ni compartimos su información personal con terceros, excepto cuando sea necesario para proporcionar nuestros servicios o cuando lo requiera la ley."
                    )
                    
                    PrivacidadSeccion(
                        numero: "5.",
                        titulo: "Sus derechos",
                        contenido: "Usted tiene derecho a acceder, rectificar, cancelar u oponerse al tratamiento de sus datos personales. Para ejercer estos derechos, puede contactarnos a través de la aplicación."
                    )
                    
                    PrivacidadSeccion(
                        numero: "6.",
                        titulo: "Cambios al aviso de privacidad",
                        contenido: "Nos reservamos el derecho de actualizar este Aviso de Privacidad en cualquier momento. Le notificaremos sobre cambios significativos a través de la aplicación."
                    )
                    
                    // MARK: - Sección de contacto
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Contacto")
                            .font(.poppinsSemiBold(size: 16))
                            .foregroundColor(.white)
                            .underline()
                        
                        Text("Si tiene preguntas sobre este Aviso de Privacidad, puede contactarnos a través del correo: privacidad@fraudfishing.com")
                            .font(.poppinsRegular(size: 15))
                            .foregroundColor(.white.opacity(0.9))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.horizontal, 25)
                    .padding(.top, 10)
                    .padding(.bottom, 40)
                }
            }
        }
        // MARK: - Configuración de barra de navegación
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                        Text("Ajustes")
                            .font(.poppinsRegular(size: 18))
                    }
                    .foregroundColor(.white)
                }
            }
        }
        .toolbarBackground(Color(red: 0.043, green: 0.067, blue: 0.173), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

// MARK: - Componente de sección reutilizable

struct PrivacidadSeccion: View {
    let numero: String
    let titulo: String
    let contenido: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 4) {
                Text(numero)
                    .font(.poppinsSemiBold(size: 16))
                    .foregroundColor(.white)
                Text(titulo)
                    .font(.poppinsSemiBold(size: 16))
                    .foregroundColor(.white)
                    .underline()
            }
            Text(contenido)
                .font(.poppinsRegular(size: 15))
                .foregroundColor(.white.opacity(0.9))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.leading, 12)
        }
        .padding(.horizontal, 25)
    }
}
// MARK: - Preview

#Preview("Términos y Condiciones") {
    NavigationView {
        ScreenTerminosCondiciones()
    }
}

#Preview("Aviso de Privacidad") {
    NavigationView {
        ScreenAvisoPrivacidad()
    }
}
