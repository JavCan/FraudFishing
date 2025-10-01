//
//  ScreenCreateReport.swift
//  Fraud Fishing
//
//  Created by Javier Canella Ramos on 23/09/25.
//

import SwiftUI
import PhotosUI

// Vista principal que orquesta el flujo de creación de reportes
struct ScreenCreateReport: View {
    @State var reportedURL: String
    @State private var category: String = ""
    @State private var tags: String = ""
    @State private var description: String = ""
    @State private var selectedImage: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    
    @State private var currentPage = 0
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            ZStack {
                // Fondo con gradiente
                LinearGradient(gradient: Gradient(colors: [
                    Color(red: 1, green: 1, blue: 1),
                    Color(red: 0.0, green: 0.71, blue: 0.737)]),
                               startPoint: UnitPoint(x:0.5, y:0.7),
                               endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    // Contenido de la página actual
                    TabView(selection: $currentPage) {
                        Step1_URLView(reportedURL: $reportedURL)
                            .tag(0)
                        Step2_ClassificationView(category: $category, tags: $tags)
                            .tag(1)
                        Step3_DescriptionView(description: $description, selectedImage: $selectedImage, selectedImageData: $selectedImageData)
                            .tag(2)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Oculta los indicadores por defecto

                    // Navegación y botones
                    if currentPage < 2 {
                        // Botón de Siguiente
                        Button(action: {
                            withAnimation {
                                currentPage += 1
                            }
                        }) {
                            Image(systemName: "arrow.right")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color(red: 0.0, green: 0.2, blue: 0.4))
                                .clipShape(Circle())
                                .shadow(radius: 10)
                        }
                        .padding(.bottom, 20)
                    } else {
                        // Botón de Enviar Reporte
                        Button(action: {
                            // Lógica para enviar el reporte
                            print("Reporte enviado")
                        }) {
                            Text("Enviar reporte")
                                .font(.poppinsBold(size: 20))
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.red)
                                .cornerRadius(10)
                                .padding(.horizontal, 30)
                        }
                        .padding(.bottom, 20)
                    }
                    
                    // Indicadores de página personalizados
                    HStack(spacing: 8) {
                        ForEach(0..<3) { index in
                            Capsule()
                                .frame(width: index == currentPage ? 20 : 8, height: 8)
                                .foregroundColor(index == currentPage ? Color(red: 0.0, green: 0.2, blue: 0.4) : .white.opacity(0.8))
                        }
                    }
                    .padding(.bottom, 30)
                }
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        if currentPage > 0 {
                            withAnimation {
                                currentPage -= 1
                            }
                        } else {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color(red: 0.043, green: 0.067, blue: 0.173))
                            .padding(10)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(Circle())
                    }.padding(.top, 25)
                }
            }
        }.navigationBarBackButtonHidden(true)
    }
}

// --- Vistas para cada paso ---

// Paso 1: Confirmar URL
struct Step1_URLView: View {
    @Binding var reportedURL: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Para comenzar...")
                .font(.poppinsMedium(size: 34))
                .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
            
            Text("Confirma el URL de la página.")
                .font(.poppinsRegular(size: 18))
                .foregroundColor(.gray)
            
            StyledTextField(
                label: "URL",
                placeholder: "https://paginafake.com",
                text: $reportedURL,
                iconName: "link"
            )
            
            Spacer()
        }
        .padding(30)
        .navigationBarBackButtonHidden(true)
    }
}

// Paso 2: Clasificar la amenaza
struct Step2_ClassificationView: View {
    @Binding var category: String
    @Binding var tags: String
    let categories = ["Phishing", "Malware", "Scam", "Noticias Falsas", "Otro"]

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Clasifica la amenaza")
                .font(.poppinsMedium(size: 34))
                .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
            
            Text("Escoge una categoría de entre la lista y escribe algunas etiquetas.")
                .font(.poppinsRegular(size: 18))
                .foregroundColor(.gray)
            
            // Selector de Categoría
            VStack(alignment: .leading, spacing: 8) {
                Text("Categoría")
                    .font(.poppinsSemiBold(size: 14))
                    .foregroundColor(.gray)
                
                HStack {
                    Image(systemName: "chevron.down.circle")
                        .foregroundColor(.gray)
                    
                    Picker("Selecciona Categoría", selection: $category) {
                        ForEach(categories, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.menu)
                    .accentColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                }
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray.opacity(0.5))
            }
            
            StyledTextField(
                label: "Etiquetas",
                placeholder: "Escribe las etiquetas",
                text: $tags,
                iconName: "tag"
            )
            
            Spacer()
        }
        .padding(30)
    }
}

// Paso 3: Descripción y Evidencia
struct Step3_DescriptionView: View {
    @Binding var description: String
    @Binding var selectedImage: PhotosPickerItem?
    @Binding var selectedImageData: Data?

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Cuéntanos...")
                .font(.poppinsMedium(size: 34))
                .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
            
            Text("¿Cuál es el motivo de tu reporte?")
                .font(.poppinsRegular(size: 18))
                .foregroundColor(.gray)
            
            // Campo de Descripción
            VStack(alignment: .leading, spacing: 8) {
                Text("Descripción")
                    .font(.poppinsSemiBold(size: 14))
                    .foregroundColor(.gray)
                
                TextEditor(text: $description)
                    .font(.poppinsRegular(size: 18))
                    .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                    .frame(height: 150)
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray.opacity(0.5))
            }
            
            // Selector de Imagen
            VStack(alignment: .leading, spacing: 8) {
                Text("Imagen")
                    .font(.poppinsSemiBold(size: 14))
                    .foregroundColor(.gray)
                
                PhotosPicker(selection: $selectedImage, matching: .images, photoLibrary: .shared()) {
                    VStack {
                        if let data = selectedImageData, let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 150)
                        } else {
                            Image(systemName: "square.and.arrow.up")
                                .font(.largeTitle)
                                .foregroundColor(.gray)
                            Text("Selecciona Imagen")
                                .foregroundColor(.gray)
                        }
                    }
                    .frame(maxWidth: .infinity, minHeight: 100)
                }
                .onChange(of: selectedImage) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                            selectedImageData = data
                        }
                    }
                }
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray.opacity(0.5))
            }
            
            Spacer()
        }
        .padding(30)
    }
}


// --- Componentes Reutilizables ---

// Campo de texto con el estilo de ScreenLogin
struct StyledTextField: View {
    var label: String
    var placeholder: String
    @Binding var text: String
    var iconName: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.poppinsSemiBold(size: 14))
                .foregroundColor(.gray)
            
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.gray)
                
                TextField(placeholder, text: $text)
                    .font(.poppinsRegular(size: 18))
                    .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
            }
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray.opacity(0.5))
        }
    }
}


#Preview {
    ScreenCreateReport(reportedURL: "https://ejemplo.com")
}
