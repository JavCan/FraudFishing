import SwiftUI


// MARK: - ScreenReportesPendientes
struct ScreenReportesPendientes: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var controller = ReportesController()
    
    var body: some View {
        ZStack {
            // MARK: - Fondo
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
                // MARK: - Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white).padding(10)
                            .background(Color.white.opacity(0.1)).clipShape(Circle())
                    }
                    Spacer()
                    Text("Reportes Pendientes")
                        .font(.title2).fontWeight(.bold).foregroundColor(.white)
                    Spacer()
                    Color.clear.frame(width: 40, height: 40)
                }
                .padding(.horizontal)
                .padding(.vertical)
                
                // MARK: - Contenido
                if controller.isLoading {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                    Spacer()
                } else if let errorMessage = controller.errorMessage {
                    Spacer()
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 50))
                            .foregroundColor(.red.opacity(0.7))
                        Text(errorMessage)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                        Button("Reintentar") {
                            Task { await controller.fetchReportesPendientes() }
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.cyan)
                        .cornerRadius(8)
                    }
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            if controller.reportesPendientes.isEmpty {
                                EmptyStateView(
                                    icon: "clock.badge.questionmark",
                                    message: "No tienes reportes pendientes",
                                    description: "Tus reportes aparecerán aquí mientras son revisados"
                                )
                                .padding(.top, 100)
                            } else {
                                ForEach(controller.reportesPendientes) { reporte in
                                    NavigationLink(destination: DetalleReporteView(reporte: reporte)) {
                                        ReporteCard(reporte: reporte)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .task {
            await controller.fetchReportesPendientes()
        }
    }
}

// MARK: - ScreenReportesVerificados
struct ScreenReportesVerificados: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var controller = ReportesController()
    
    var body: some View {
        ZStack {
            // MARK: - Fondo
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
                // MARK: - Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white).padding(10)
                            .background(Color.white.opacity(0.1)).clipShape(Circle())
                    }
                    Spacer()
                    Text("Reportes Verificados")
                        .font(.title2).fontWeight(.bold).foregroundColor(.white)
                    Spacer()
                    Color.clear.frame(width: 40, height: 40)
                }
                .padding(.horizontal)
                .padding(.vertical)
                
                // MARK: - Contenido
                if controller.isLoading {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                    Spacer()
                } else if let errorMessage = controller.errorMessage {
                    Spacer()
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 50))
                            .foregroundColor(.red.opacity(0.7))
                        Text(errorMessage)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                        Button("Reintentar") {
                            Task { await controller.fetchReportesVerificados() }
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.cyan)
                        .cornerRadius(8)
                    }
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            if controller.reportesVerificados.isEmpty {
                                EmptyStateView(
                                    icon: "checkmark.circle",
                                    message: "No tienes reportes verificados",
                                    description: "Tus reportes aceptados aparecerán aquí"
                                )
                                .padding(.top, 100)
                            } else {
                                ForEach(controller.reportesVerificados) { reporte in
                                    NavigationLink(destination: DetalleReporteView(reporte: reporte)) {
                                        ReporteCard(reporte: reporte)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .task {
            await controller.fetchReportesVerificados()
        }
    }
}

// MARK: - Modelo de Datos
struct Reporte: Identifiable {
    let id: String
    let url: String
    let logo: String
    let descripcion: String
    let categoria: String
    let hashtags: String
    let estado: EstadoReporte
    let fechaCreacion: String
    var fechaVerificacion: String?
}

enum EstadoReporte {
    case pendiente
    case verificado
}

// MARK: - Componente ReporteCard
struct ReporteCard: View {
    let reporte: Reporte
    
    var body: some View {
        VStack(spacing: 0) {
            // Header con fecha y badge
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.7))
                    Text(reporte.fechaCreacion)
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Spacer()
                
                HStack(spacing: 6) {
                    Image(systemName: reporte.estado == .pendiente ? "clock.fill" : "checkmark.circle.fill")
                        .font(.system(size: 11))
                    Text(reporte.estado == .pendiente ? "Pendiente" : "Verificado")
                        .font(.system(size: 12, weight: .semibold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 5)
                .background(reporte.estado == .pendiente ? Color.orange : Color.green)
                .cornerRadius(15)
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 12)
            
            Divider()
                .background(Color.white.opacity(0.2))
                .padding(.horizontal, 16)
            
            // URL del sitio
            HStack(spacing: 10) {
                Image(systemName: "link.circle.fill")
                    .foregroundColor(.cyan)
                    .font(.system(size: 16))
                
                Text(reporte.url)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            
            Divider()
                .background(Color.white.opacity(0.2))
                .padding(.horizontal, 16)
            
            // Contenido del reporte
            HStack(alignment: .top, spacing: 12) {
                // Logo/Imagen del sitio
                if !reporte.logo.isEmpty, let url = URL(string: reporte.logo) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white.opacity(0.15))
                            .overlay(
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            )
                    }
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                } else {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white.opacity(0.15))
                        .frame(width: 60, height: 60)
                        .overlay(
                            Image(systemName: "photo.fill")
                                .foregroundColor(.white.opacity(0.3))
                                .font(.system(size: 20))
                        )
                }
                
                // Descripción
                VStack(alignment: .leading, spacing: 4) {
                    Text(reporte.descripcion)
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.9))
                        .lineLimit(3)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            
            Divider()
                .background(Color.white.opacity(0.2))
                .padding(.horizontal, 16)
            
            // Categoría
            VStack(alignment: .leading, spacing: 10) { // Aumentamos el espaciado para mejor separación
                // Categoría (sin cambios)
                HStack(spacing: 8) {
                    Image(systemName: "tag.fill")
                        .font(.system(size: 10))
                        .foregroundColor(.purple)
                    
                    Text(reporte.categoria)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.purple.opacity(0.6))
                        .cornerRadius(5)
                }
                
                // NUEVO ESTILO PARA HASHTAGS
                if !reporte.hashtags.isEmpty {
                    HStack(spacing: 8) {
                        // 1. Añadimos el ícono de "hashtag"
                        Image(systemName: "number")
                            .font(.system(size: 10))
                            .foregroundColor(.cyan)
                        
                        // 2. Mostramos el texto de los hashtags
                        Text(reporte.hashtags)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.cyan)
                            .lineLimit(1) // Limitamos a una línea para que no ocupe mucho espacio
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            // Indicador de "ver más"
            HStack {
                Spacer()
                HStack(spacing: 4) {
                    Text("Ver detalles")
                        .font(.system(size: 12, weight: .medium))
                    Image(systemName: "chevron.right")
                        .font(.system(size: 11, weight: .semibold))
                }
                .foregroundColor(.white.opacity(0.7))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
        .background(Color.white.opacity(0.1))
        .cornerRadius(10)
    }
}

// MARK: - Vista de Estado Vacío
struct EmptyStateView: View {
    let icon: String
    let message: String
    let description: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundColor(.white.opacity(0.4))
            
            Text(message)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            Text(description)
                .font(.body)
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
}

// MARK: - Vista de Detalle del Reporte
struct DetalleReporteView: View {
    @Environment(\.dismiss) private var dismiss
    let reporte: Reporte
    
    var body: some View {
        ZStack {
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
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white).padding(10)
                            .background(Color.white.opacity(0.1)).clipShape(Circle())
                    }
                    Spacer()
                    Text("Detalle del Reporte")
                        .font(.title2).fontWeight(.bold).foregroundColor(.white)
                    Spacer()
                    Color.clear.frame(width: 40, height: 40)
                }
                .padding(.horizontal)
                .padding(.vertical)
                
                ScrollView {
                    VStack(spacing: 20) {
                        VStack(spacing: 0) {
                            HStack {
                                HStack(spacing: 8) {
                                    Image(systemName: reporte.estado == .pendiente ? "clock.fill" : "checkmark.circle.fill")
                                        .font(.system(size: 14))
                                    Text(reporte.estado == .pendiente ? "En revisión" : "Verificado")
                                        .font(.system(size: 14, weight: .semibold))
                                }
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(reporte.estado == .pendiente ? Color.orange : Color.green)
                                .cornerRadius(20)
                                
                                Spacer()
                            }
                            .padding(16)
                            
                            Divider()
                                .background(Color.white.opacity(0.2))
                                .padding(.horizontal, 16)
                            
                            // Imagen del sitio
                            if !reporte.logo.isEmpty, let url = URL(string: reporte.logo) {
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                } placeholder: {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.white.opacity(0.15))
                                        .overlay(ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .white)))
                                }
                                .frame(height: 160)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 16)
                            } else {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white.opacity(0.15))
                                    .frame(height: 160)
                                    .overlay(
                                        Image(systemName: "photo.fill")
                                            .foregroundColor(.white.opacity(0.3))
                                            .font(.system(size: 40))
                                    )
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 16)
                            }
                            
                            Divider().background(Color.white.opacity(0.2)).padding(.horizontal, 16)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                HStack(spacing: 8) {
                                    Image(systemName: "link.circle.fill").foregroundColor(.cyan)
                                    Text("URL reportada").font(.system(size: 12, weight: .semibold)).foregroundColor(.white.opacity(0.7))
                                }
                                Text(reporte.url).font(.system(size: 14, weight: .medium)).foregroundColor(.white).lineLimit(2)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(16)
                            
                            Divider().background(Color.white.opacity(0.2)).padding(.horizontal, 16)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                HStack(spacing: 8) {
                                    Image(systemName: "doc.text.fill").foregroundColor(.cyan)
                                    Text("Descripción del reporte").font(.system(size: 12, weight: .semibold)).foregroundColor(.white.opacity(0.7))
                                }
                                Text(reporte.descripcion).font(.system(size: 14)).foregroundColor(.white.opacity(0.9)).fixedSize(horizontal: false, vertical: true)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(16)
                            
                            Divider().background(Color.white.opacity(0.2)).padding(.horizontal, 16)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                HStack(spacing: 8) {
                                    Image(systemName: "tag.fill").foregroundColor(.purple)
                                    Text("Categoría").font(.system(size: 12, weight: .semibold)).foregroundColor(.white.opacity(0.7))
                                }
                                Text(reporte.categoria).font(.system(size: 13, weight: .semibold)).foregroundColor(.white).padding(.horizontal, 12).padding(.vertical, 6).background(Color.purple.opacity(0.6)).cornerRadius(8)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(16)
                            
                            if !reporte.hashtags.isEmpty {
                                Divider().background(Color.white.opacity(0.2)).padding(.horizontal, 16)
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "number").foregroundColor(.cyan)
                                        Text("Etiquetas").font(.system(size: 12, weight: .semibold)).foregroundColor(.white.opacity(0.7))
                                    }
                                    Text(reporte.hashtags).font(.system(size: 13, weight: .medium)).foregroundColor(.cyan)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(16)
                            }
                            
                            Divider().background(Color.white.opacity(0.2)).padding(.horizontal, 16)
                            
                            VStack(alignment: .leading, spacing: 12) {
                                HStack(spacing: 8) {
                                    Image(systemName: "calendar.badge.plus").foregroundColor(.cyan)
                                    Text("Fecha de reporte:").font(.system(size: 13)).foregroundColor(.white.opacity(0.7))
                                    Spacer()
                                    Text(reporte.fechaCreacion).font(.system(size: 13, weight: .semibold)).foregroundColor(.white)
                                }
                                
                                if let fechaVerificacion = reporte.fechaVerificacion {
                                    HStack(spacing: 8) {
                                        Image(systemName: "calendar.badge.checkmark").foregroundColor(.green)
                                        Text("Fecha de verificación:").font(.system(size: 13)).foregroundColor(.white.opacity(0.7))
                                        Spacer()
                                        Text(fechaVerificacion).font(.system(size: 13, weight: .semibold)).foregroundColor(.white)
                                    }
                                }
                            }
                            .padding(16)
                        }
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview("Reportes Pendientes") {
    NavigationView {
        ScreenReportesPendientes()
    }
}

#Preview("Reportes Verificados") {
    NavigationView {
        ScreenReportesVerificados()
    }
}
