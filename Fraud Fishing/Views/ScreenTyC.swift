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
            LinearGradient(gradient: Gradient(colors: [
                Color(red: 0.043, green: 0.067, blue: 0.173, opacity: 0.88),
                Color(red: 0.043, green: 0.067, blue: 0.173)]),
                           startPoint: UnitPoint(x:0.5, y:0.1),
                           endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Terminos y condiciones")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 20)
                    Text("Al descargar y utilizar Fraud Fishing, usted acepta los siguientes términos y condiciones:")
                        .font(.system(size: 15))
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 10)
                    
                    // Sección 1: Uso de la App
                    TerminoSeccion(
                        numero: "1.",
                        titulo: "Uso de la App",
                        contenido: "La App se proporciona para fines [informativos / de servicio / de entretenimiento, según corresponda]. Usted se compromete a usarla de manera legal y responsable."
                    )
                    
                    // Sección 2: Propiedad intelectual
                    TerminoSeccion(
                        numero: "2.",
                        titulo: "Propiedad intelectual",
                        contenido: "Todo el contenido, diseño y funciones de la App son propiedad de [Nombre de la empresa/ desarrollador]. No está permitido copiar, modificar o distribuir dicho contenido sin autorización previa."
                    )
                    
                    // Sección 3: Limitación de responsabilidad
                    TerminoSeccion(
                        numero: "3.",
                        titulo: "Limitación de responsabilidad",
                        contenido: "La App se ofrece \"tal cual\" y no garantizamos que esté libre de errores o interrupciones. [Nombre de la empresa/desarrollador] no se hace responsable por daños derivados del uso de la App."
                    )
                    
                    // Sección 4: Datos personales
                    TerminoSeccion(
                        numero: "4.",
                        titulo: "Datos personales",
                        contenido: "El uso de la App implica el tratamiento de datos personales conforme a nuestro Aviso de Privacidad."
                    )
                    
                    // Sección 5: Modificaciones
                    TerminoSeccion(
                        numero: "5.",
                        titulo: "Modificaciones",
                        contenido: "[Nombre de la empresa/desarrollador] podrá modificar estos Términos y Condiciones en cualquier momento, publicando las actualizaciones en la App."
                    )
                    
                    // Texto final
                    Text("Si no está de acuerdo con estos términos, le solicitamos no utilizar la App.")
                        .font(.system(size: 15))
                        .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        .padding(.bottom, 40)
                }
            }
        }
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
    }
}

// MARK: - Componente para cada sección de términos

struct TerminoSeccion: View {
    let numero: String
    let titulo: String
    let contenido: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 4) {
                Text(numero)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                Text(titulo)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                    .underline()
            }
            Text(contenido)
                .font(.system(size: 15))
                .foregroundColor(.white.opacity(0.85))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.leading, 12)
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Pantalla de Aviso de Privacidad

struct ScreenAvisoPrivacidad: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [
                Color(red: 0.043, green: 0.067, blue: 0.173, opacity: 0.88),
                Color(red: 0.043, green: 0.067, blue: 0.173)]),
                           startPoint: UnitPoint(x:0.5, y:0.1),
                           endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Aviso de Privacidad")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 20)
                    Text("En Fraud Fishing, respetamos y protegemos la privacidad de nuestros usuarios. Este aviso describe cómo recopilamos, usamos y protegemos su información personal.")
                        .font(.system(size: 15))
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 10)
                    
                    // Sección 1: Información que recopilamos
                    PrivacidadSeccion(
                        numero: "1.",
                        titulo: "Información que recopilamos",
                        contenido: "Recopilamos información personal que usted nos proporciona directamente, como nombre, correo electrónico y datos de registro. También recopilamos información sobre los reportes que realiza en la aplicación."
                    )
                    
                    // Sección 2: Uso de la información
                    PrivacidadSeccion(
                        numero: "2.",
                        titulo: "Uso de la información",
                        contenido: "Utilizamos su información para proporcionar y mejorar nuestros servicios, procesar sus reportes de fraude, comunicarnos con usted y garantizar la seguridad de la plataforma."
                    )
                    
                    // Sección 3: Protección de datos
                    PrivacidadSeccion(
                        numero: "3.",
                        titulo: "Protección de datos",
                        contenido: "Implementamos medidas de seguridad técnicas y organizativas para proteger su información personal contra accesos no autorizados, pérdida o alteración."
                    )
                    
                    // Sección 4: Compartir información
                    PrivacidadSeccion(
                        numero: "4.",
                        titulo: "Compartir información",
                        contenido: "No vendemos ni compartimos su información personal con terceros, excepto cuando sea necesario para proporcionar nuestros servicios o cuando lo requiera la ley."
                    )
                    
                    // Sección 5: Sus derechos
                    PrivacidadSeccion(
                        numero: "5.",
                        titulo: "Sus derechos",
                        contenido: "Usted tiene derecho a acceder, rectificar, cancelar u oponerse al tratamiento de sus datos personales. Para ejercer estos derechos, puede contactarnos a través de la aplicación."
                    )
                    
                    // Sección 6: Cambios al aviso
                    PrivacidadSeccion(
                        numero: "6.",
                        titulo: "Cambios al aviso de privacidad",
                        contenido: "Nos reservamos el derecho de actualizar este Aviso de Privacidad en cualquier momento. Le notificaremos sobre cambios significativos a través de la aplicación."
                    )
                    
                    // Texto de contacto
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Contacto")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                            .underline()
                        
                        Text("Si tiene preguntas sobre este Aviso de Privacidad, puede contactarnos a través del correo: privacidad@fraudfishing.com")
                            .font(.system(size: 15))
                            .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .padding(.bottom, 40)
                }
            }
        }
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
    }
}

// MARK: - Componente para cada sección de privacidad

struct PrivacidadSeccion: View {
    let numero: String
    let titulo: String
    let contenido: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 4) {
                Text(numero)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                Text(titulo)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                    .underline()
            }
            Text(contenido)
                .font(.system(size: 15))
                .foregroundColor(.white.opacity(0.85))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.leading, 12)
        }
        .padding(.horizontal, 20)
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