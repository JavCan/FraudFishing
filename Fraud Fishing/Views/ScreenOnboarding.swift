//
//  ScreenOnboarding.swift
//  Fraud Fishing
//
//  Created by Javier Canella Ramos on 24/09/25.
//

import SwiftUI

struct ScreenOnboarding: View {
    let imageName: String
    let title: String
    let description: String
    let currentPage: Int
    let totalPages: Int

    var body: some View {
        NavigationView { // Añadimos NavigationView aquí
            ZStack {
                // Fondo oscuro
                Color(red: 0.043, green: 0.067, blue: 0.173)// Un azul muy oscuro
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    Spacer().frame(height: 150) // Empuja el contenido hacia el centro/arriba

                    // Placeholder de la imagen
                    Image(imageName) // Usamos el nombre de la imagen proporcionado
                        .resizable()
                        .scaledToFit()
                        .frame(height: 250) // Ajusta el tamaño según sea necesario
                        .padding(.bottom, 10)
                        .animation(.easeOut(duration: 0.5), value: imageName) // Animación para la imagen

                    // Indicadores de paginación (los "puntitos")
                    HStack(spacing: 8) {
                        ForEach(0..<totalPages, id: \.self) { index in
                            Capsule() // Cambiado a Capsule para forma alargada
                                .frame(width: index == currentPage ? 20 : 8, height: 8) // Ancho dinámico
                                .foregroundColor(index == currentPage ? .white : .gray.opacity(0.5))
                                .animation(.easeOut(duration: 0.3), value: currentPage) // Animación para el cambio de indicador
                        }
                    }
                    .padding(.bottom, 40)

                    // Título
                    Text(title)
                        .font(.poppinsBold(size: 28))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center) // Centrado
                        .padding(.horizontal, 30) // Mantener padding horizontal para evitar que el texto toque los bordes
                        .lineLimit(nil)            // sin límite de líneas
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.bottom, 10)
                        .animation(.easeOut(duration: 0.5), value: title) // Animación para el título
                        

                    // Descripción
                    Text(description)
                        .font(.poppinsRegular(size: 16))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center) // Centrado
                        .padding(.horizontal, 40) // Mantener padding horizontal
                        .lineLimit(nil)            // sin límite de líneas
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.bottom, 50)
                        .animation(.easeOut(duration: 0.5), value: description) // Animación para la descripción

                    // Botón "Siguiente"
                    NavigationLink(destination: ScreenOnboarding2(
                        imageName: "onboarding2",
                        title: "Recibe alertas en tiempo real",
                        description: "Te notificamos sobre nuevas amenazas y el estado de tus reportes para que navegues seguro",
                        currentPage: 1,
                        totalPages: 3
                    )) {
                        Text("Siguiente")
                            .font(.poppinsBold(size: 20))
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(red: 0.0, green: 0.2, blue: 0.4)) // Color del botón
                            .cornerRadius(10)
                            .padding(.horizontal, 30)
                    }
                    .padding(.bottom, 30) // Espacio inferior para el botón
                    .animation(.easeOut(duration: 0.5), value: currentPage) // Animación para el botón

                    Spacer() // Empuja el contenido hacia el centro/abajo
                }
            }
        }
    }
}

#Preview {
    ScreenOnboarding(
        imageName: "onboarding1", // Usando el logo como placeholder
        title: "Reporta las páginas fraudulentas",
        description: "Ve los reportes de los demás usuarios para evitar imprevistos.",
        currentPage: 0,
        totalPages: 3
    )
}
