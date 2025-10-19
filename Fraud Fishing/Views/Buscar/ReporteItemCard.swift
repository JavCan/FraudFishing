import SwiftUI

struct ReporteItemCard: View {
    @Binding var report: ReportResponse
    @State private var isVoting = false
    @State private var voteError: String? = nil

    var body: some View {
        VStack(spacing: 0) {
            // Header con fecha
            HStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(Color(red: 0.0, green: 0.8, blue: 0.7).opacity(0.15))
                        .frame(width: 32, height: 32)
                    Image(systemName: "calendar")
                        .foregroundColor(Color(red: 0.0, green: 0.8, blue: 0.7))
                        .font(.system(size: 14, weight: .semibold))
                }
                Text(formatDate(report.createdAt))
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.7))
                Spacer()
                
                // Badge de categoría en el header
                HStack(spacing: 4) {
                    Circle()
                        .fill(Color(red: 0.0, green: 0.8, blue: 0.7))
                        .frame(width: 6, height: 6)
                    Text(report.categoryName ?? "Desconocida")
                        .font(.caption2.weight(.semibold))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(Color(red: 0.0, green: 0.8, blue: 0.7, opacity: 0.2))
                        .overlay(
                            Capsule()
                                .stroke(Color(red: 0.0, green: 0.8, blue: 0.7, opacity: 0.3), lineWidth: 1)
                        )
                )
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 16)

            // Imagen con diseño mejorado
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.0, green: 0.8, blue: 0.7).opacity(0.15),
                                Color(red: 0.0, green: 0.6, blue: 0.7).opacity(0.08)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
                
                // Patrón de puntos decorativo
                Canvas { context, size in
                    let dotSize: CGFloat = 2
                    let spacing: CGFloat = 20
                    for x in stride(from: 0, to: size.width, by: spacing) {
                        for y in stride(from: 0, to: size.height, by: spacing) {
                            let rect = CGRect(x: x, y: y, width: dotSize, height: dotSize)
                            context.fill(Path(ellipseIn: rect), with: .color(.white.opacity(0.05)))
                        }
                    }
                }
                
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.08))
                            .frame(width: 70, height: 70)
                        Image(systemName: "photo")
                            .foregroundColor(.white.opacity(0.4))
                            .font(.system(size: 30))
                    }
                    Text("Sin imagen")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.3))
                }
            }
            .frame(height: 180)
            .padding(.horizontal, 20)
            .padding(.bottom, 20)

            // Contenido principal
            VStack(alignment: .leading, spacing: 16) {
                // URL con diseño mejorado
                HStack(spacing: 10) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(red: 0.0, green: 0.8, blue: 0.7).opacity(0.12))
                            .frame(width: 36, height: 36)
                        Image(systemName: "link")
                            .foregroundColor(Color(red: 0.0, green: 0.8, blue: 0.7))
                            .font(.system(size: 14, weight: .semibold))
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text("URL detectada")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.5))
                        Text(report.url)
                            .font(.poppinsBold(size: 13))
                            .foregroundColor(.white)
                            .lineLimit(2)
                            .truncationMode(.tail)
                    }
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.08), lineWidth: 1)
                        )
                )
                
                // Descripción
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 6) {
                        Image(systemName: "text.quote")
                            .foregroundColor(Color(red: 0.0, green: 0.8, blue: 0.7))
                            .font(.system(size: 12, weight: .semibold))
                        Text("Descripción")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.5))
                    }
                    Text(report.description)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.95))
                        .lineLimit(4)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                // Tags con diseño mejorado
                if let tags = report.tags, !tags.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 6) {
                            Image(systemName: "tag.fill")
                                .foregroundColor(Color(red: 0.0, green: 0.8, blue: 0.7))
                                .font(.system(size: 11, weight: .semibold))
                            Text("Etiquetas")
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.5))
                        }
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(tags, id: \.id) { tag in
                                    Text(tag.name)
                                        .font(.caption.weight(.medium))
                                        .foregroundColor(Color(red: 0.0, green: 0.8, blue: 0.7))
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(
                                            Capsule()
                                                .fill(Color(red: 0.0, green: 0.8, blue: 0.7).opacity(0.15))
                                                .overlay(
                                                    Capsule()
                                                        .stroke(Color(red: 0.0, green: 0.8, blue: 0.7).opacity(0.3), lineWidth: 1)
                                                )
                                        )
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)

            // Footer con estadísticas
            Divider()
                .background(Color.white.opacity(0.1))
                .padding(.horizontal, 20)
            
            HStack(spacing: 0) {
                // Botón de votos
                Button {
                    Task { await votar() }
                } label: {
                    HStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(Color(red: 0.0, green: 0.8, blue: 0.7).opacity(0.15))
                                .frame(width: 32, height: 32)
                            Image(systemName: "arrowshape.up.fill")
                                .foregroundColor(Color(red: 0.0, green: 0.8, blue: 0.7))
                                .font(.system(size: 14, weight: .semibold))
                        }
                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(report.voteCount)")
                                .font(.callout.weight(.bold))
                                .foregroundColor(.white)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                }
                .buttonStyle(PlainButtonStyle())
                
                Divider()
                    .background(Color.white.opacity(0.1))
                    .frame(height: 40)
                
                // Comentarios
                HStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(Color(red: 0.0, green: 0.8, blue: 0.7).opacity(0.15))
                            .frame(width: 32, height: 32)
                        Image(systemName: "bubble.right.fill")
                            .foregroundColor(Color(red: 0.0, green: 0.8, blue: 0.7))
                            .font(.system(size: 14, weight: .semibold))
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(report.commentCount)")
                            .font(.callout.weight(.bold))
                            .foregroundColor(.white)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
            }
            .padding(.horizontal, 20)

            if let voteError = voteError {
                Text(voteError)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
            }
        }
        .background(
            ZStack {
                // Fondo principal con gradiente sutil
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.537, green: 0.616, blue: 0.733, opacity: 0.25),
                        Color(red: 0.537, green: 0.616, blue: 0.733, opacity: 0.15)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                // Borde sutil
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.12), lineWidth: 1)
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.black.opacity(0.2), radius: 12, x: 0, y: 6)
        .shadow(color: Color(red: 0.0, green: 0.8, blue: 0.7).opacity(0.08), radius: 20, x: 0, y: 10)
    }

    private func formatDate(_ isoString: String) -> String {
        let iso = ISO8601DateFormatter()
        iso.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = iso.date(from: isoString) {
            let out = DateFormatter()
            out.dateFormat = "dd/MM/yyyy"
            return out.string(from: date)
        }
        return isoString
    }

    private func votar() async {
        isVoting = true
        voteError = nil
        do {
            try await HTTPReport().voteReport(reportId: report.id)
            await MainActor.run { report.voteCount += 1 }
        } catch {
            await MainActor.run {
                voteError = "Error al votar: \(error.localizedDescription)"
            }
        }
        isVoting = false
    }
}

// MARK: - Preview Container
struct ReporteItemCard_PreviewContainer: View {
    @State private var mockReport = ReportResponse(
        id: 1,
        userId: 17,
        categoryId: 1,
        title: "Correo Sospechoso de Banco",
        description: "Recibí un correo sospechoso pidiéndome restablecer mi contraseña. El link me lleva a esta página.",
        url: "https://paginafake.com/login-banco-falso-muy-largo",
        statusId: 2,
        imageUrl: nil,
        voteCount: 42,
        commentCount: 8,
        createdAt: "2025-10-17 14:30:00",
        updatedAt: "2025-10-17 14:30:00",
        tags: [
            TagResponse(id: 1, name: "banco"),
            TagResponse(id: 2, name: "urgente"),
            TagResponse(id: 3, name: "credenciales")
        ],
        categoryName: "Phishing"
    )

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [
                Color(red: 0.043, green: 0.067, blue: 0.173, opacity: 0.88),
                Color(red: 0.043, green: 0.067, blue: 0.173)]),
                           startPoint: UnitPoint(x:0.5, y:0.1),
                           endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            ReporteItemCard(report: $mockReport)
                .padding()
        }
    }
}

#Preview {
    ReporteItemCard_PreviewContainer()
}
