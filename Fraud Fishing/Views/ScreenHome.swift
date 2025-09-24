//
//  ScreenHome.swift
//  Fraud Fishing
//
//  Created by Javier Canella Ramos on 22/09/25.
//

import SwiftUI

struct ScreenHome: View {
    @State private var urlInput: String = ""

    var body: some View {
        NavigationView {
            ZStack(alignment: .topTrailing) { // Alineamos el ZStack para el botón de notificación
                LinearGradient(gradient: Gradient(colors: [
                    Color(red: 1, green: 1, blue: 1),
                    Color(red: 0.0, green: 0.71, blue: 0.737)]),
                               startPoint: UnitPoint(x:0.5, y:0.7),
                               endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    // Logo
                    Image("FRAUD FISHING-03")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 400, height: 240)
                        .padding(.top, 60) // Ajusta el padding superior para el logo

                    // Barra de entrada de URL
                    HStack {
                        TextField("URL", text: $urlInput)
                            .padding()
                            .background(Color(red: 0.0, green: 0.71, blue: 0.737, opacity: 0.2))
                            .cornerRadius(25)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color(red: 0.0, green: 0.71, blue: 0.737))
                            )
                            .padding(.leading, 20)

                        /*Button(action: {
                            // Acción para buscar URL
                            print("Buscar URL: \(urlInput)")
                        }) {
                            Image(systemName: "magnifyingglass")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color(red: 0.0, green: 0.71, blue: 0.737))
                                .clipShape(Circle())
                        }
                        */.padding(.trailing, 20)
                    }
                    .padding(.bottom, 30)

                    // Botones de Reportar y Buscar
                    HStack(spacing: 20) {
                        NavigationLink(destination: ScreenCreateReport(reportedURL: urlInput)) {
                            Text("Reportar")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.red)
                                .cornerRadius(10)
                        }

                        Button(action: {
                            // Acción para buscar
                            print("Buscar URL reportada: \(urlInput)")
                        }) {
                            Text("Buscar")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(red: 0.0, green: 0.2, blue: 0.4))
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 50)

                    Spacer() // Empuja el contenido hacia arriba

                    // Barra de navegación inferior
                    VStack {
                        Spacer() // Empuja la barra de navegación hacia abajo
                        HStack {
                            Spacer()
                            Button(action: {
                                // Acción para Buscar
                            }) {
                                VStack {
                                    Image(systemName: "plus.magnifyingglass")
                                    Text("Buscar")
                                }
                                .foregroundColor(.white)
                            }
                            Spacer()
                            Button(action: {
                                // Acción para Dashboard
                            }) {
                                VStack {
                                    Image(systemName: "lightbulb.fill")
                                    Text("Dashboard")
                                }
                                .foregroundColor(.white)
                            }
                            Spacer()
                            Button(action: {
                                // Acción para Perfil
                            }) {
                                VStack {
                                    Image(systemName: "person.fill")
                                    Text("Perfil")
                                }
                                .foregroundColor(.white)
                            }
                            Spacer()
                        }
                        .padding(.vertical, 20)
                        .background(Color(red: 0.0, green: 0.2, blue: 0.4))
                        .cornerRadius(45)
                        .padding(.horizontal, 20)
                        
                    }
                }

                // Botón de notificaciones
                Button(action: {
                    // Acción para notificaciones
                }) {
                    Image(systemName: "bell.fill")
                        .font(.title)
                        .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                        .overlay(
                            Text("1") // Número de notificaciones
                                .font(.caption2)
                                .foregroundColor(.white)
                                .padding(5)
                                .background(Color.red)
                                .clipShape(Circle())
                                .offset(x: 10, y: -10)
                        )
                }
                .padding(.trailing, 30)
                .padding(.top, 30)
            }
            .navigationBarHidden(true) // Oculta la barra de navegación por defecto
        }
    }
}

#Preview {
    ScreenHome()
}
