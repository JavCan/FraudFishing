//
//  ScreenRegister.swift
//  Fraud Fishing
//
//  Created by Javier Canella Ramos on 16/09/25.
//

import SwiftUI

struct ScreenRegister: View {
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [
                Color(red: 1, green: 1, blue: 1),
                Color(red: 0.0, green: 0.8, blue: 0.7)]),
                           startPoint: UnitPoint(x:0.5, y:0.7),
                           endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
    
            VStack {
                // Placeholder para el logo
                Image("FRAUD FISHING-03") // Reemplazado con la imagen del logo
                    .resizable()
                    .scaledToFill()
                    .frame(width: 400, height: 240) // Ajusta el tamaño según sea necesario
                
                
                // Campo de Nombre
                Text("Nombre")
                    .font(.headline)
                    .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 40)

                TextField("", text: .constant(""))
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(red: 0.0, green: 0.2, blue: 0.4), lineWidth: 1)
                        )
                    .padding(.horizontal, 30)
                    .padding(.bottom, 30)
                
                
                Spacer().frame(height: 5)
                
                
                
                // Campo de Correo
                Text("Correo")
                    .font(.headline)
                    .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 40)

                TextField("", text: .constant(""))
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(red: 0.0, green: 0.2, blue: 0.4), lineWidth: 1)
                        )
                    .padding(.horizontal, 30)
                    .padding(.bottom, 30)
                
                
                Spacer().frame(height: 5)
                
                
                
                // Campo de Contraseña
                Text("Contraseña")
                    .font(.headline)
                    .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 40)

                SecureField("", text: .constant(""))
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(red: 0.0, green: 0.2, blue: 0.4), lineWidth: 1)
                        )
                    .padding(.horizontal, 30)
                    .padding(.bottom, 30)
                
                
                Spacer().frame(height: 55)
                
                
                
                // Botón Iniciar Sesión
                Button(action: {
                    // Acción para iniciar sesión
                }) {
                    Text("Regístrate")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 0.0, green: 0.2, blue: 0.4))
                        .cornerRadius(10)
                        .padding(.horizontal, 30)
                }
                .padding(.bottom, 50)

            
            }
        }
    }
}

#Preview {
    ScreenRegister()
}
