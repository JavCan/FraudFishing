//
//  ScreenCreateReport.swift
//  Fraud Fishing
//
//  Created by Javier Canella Ramos on 23/09/25.
//

import SwiftUI
import PhotosUI // Necesario para PhotosPicker

struct ScreenCreateReport: View {
    @State var reportedURL: String // Para recibir la URL de ScreenHome
    @State private var selectedCategory: String = "Phishing"
    @State private var descriptionInput: String = ""
    @State private var selectedImage: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil

    let categories = ["Phishing", "Malware", "Scam", "Fake News", "Otro"]

    var body: some View {
        NavigationView {
            ZStack(alignment: .topTrailing) {
                LinearGradient(gradient: Gradient(colors: [
                    Color(red: 1, green: 1, blue: 1),
                    Color(red: 0.0, green: 0.8, blue: 0.7)]),
                               startPoint: UnitPoint(x:0.5, y:0.7),
                               endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)

                ScrollView { // Envuelve el contenido principal en un ScrollView
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Creación de reporte")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                            .padding(.horizontal, 30)
                            .padding(.top, 10)

                        // Campo URL de la página
                        VStack(alignment: .leading) {
                            Text("URL")
                                .font(.headline)
                                .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                            TextField("URL", text: $reportedURL)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(15)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color(red: 0.0, green: 0.2, blue: 0.4, opacity: 0.7), lineWidth: 1)
                                )
                                .disabled(true) // La URL viene de la pantalla anterior
                        }
                        .padding(.horizontal, 30)

                        // Campo Categoría
                        VStack(alignment: .leading) {
                            Text("Categoría")
                                .font(.headline)
                                .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                            Picker("Selecciona una categoría", selection: $selectedCategory) {
                                ForEach(categories, id: \.self) { category in
                                    Text(category)
                                }
                            }
                            .pickerStyle(.menu)
                            .padding(.horizontal)
                            .background(Color.white)
                            .cornerRadius(15)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color(red: 0.0, green: 0.2, blue: 0.4, opacity: 0.7), lineWidth: 1)
                            )
                        }
                        .padding(.horizontal, 30)

                        // Campo Imagen
                        VStack(alignment: .leading) {
                            Text("Imagen")
                                .font(.headline)
                                .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                            PhotosPicker(
                                selection: $selectedImage,
                                matching: .images,
                                photoLibrary: .shared()
                            ) {
                                VStack {
                                    if let selectedImageData, let uiImage = UIImage(data: selectedImageData) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(maxWidth: .infinity, maxHeight: 150)
                                            .cornerRadius(15)
                                    } else {
                                        Image(systemName: "square.and.arrow.up")
                                            .font(.largeTitle)
                                            .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4, opacity: 0.4))
                                        Text("Seleccionar imagen")
                                            .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4, opacity: 0.4))
                                    }
                                }
                                .frame(maxWidth: .infinity, minHeight: 150)
                                .background(Color.white)
                                .cornerRadius(15)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color(red: 0.0, green: 0.2, blue: 0.4, opacity: 0.7), lineWidth: 1)
                                )
                            }
                            .onChange(of: selectedImage) { newItem in
                                Task {
                                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                        selectedImageData = data
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 30)

                        // Campo Descripción
                        VStack(alignment: .leading) {
                            Text("Descripción")
                                .font(.headline)
                                .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                            TextEditor(text: $descriptionInput)
                                .frame(minHeight: 150, maxHeight: 200)
                                .padding(8)
                                .background(Color.white)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color(red: 0.0, green: 0.2, blue: 0.4, opacity: 0.7), lineWidth: 1)
                                )
                        }
                        .padding(.horizontal, 30)

                        // Botón REPORTAR
                        Button(action: {
                            // Acción para reportar
                            print("Reporte enviado:")
                            print("URL: \(reportedURL)")
                            print("Categoría: \(selectedCategory)")
                            print("Descripción: \(descriptionInput)")
                            if selectedImageData != nil {
                                print("Imagen seleccionada")
                            }
                        }) {
                            Text("REPORTAR")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.red)
                                .cornerRadius(10)
                                .padding(.horizontal, 60)
                        }
                        .padding(.top, 10) // Añadido padding inferior para separar del borde o barra de navegación
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    ScreenCreateReport(reportedURL: "https://ejemplo.com/phishing")
}
