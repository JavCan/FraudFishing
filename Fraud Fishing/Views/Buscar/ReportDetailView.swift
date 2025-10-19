import SwiftUI

struct ReportDetailView: View {
    @Binding var report: ReportResponse

    @State private var comments: [CommentResponse] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var newComment: String = ""
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [
                Color(red: 0.043, green: 0.067, blue: 0.173, opacity: 0.88),
                Color(red: 0.043, green: 0.067, blue: 0.173)
            ]), startPoint: UnitPoint(x:0.5, y:0.1), endPoint: .bottom)
            .edgesIgnoringSafeArea(.all)

            VStack(spacing: 16) {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white).padding(8)
                            .background(Color.white.opacity(0.1)).clipShape(Circle())
                    }
                    Spacer()
                    Text("Detalle del Reporte")
                        .foregroundColor(.white)
                        .font(.title3.bold())
                    Spacer()
                    Color.clear.frame(width: 32, height: 32)
                }
                .padding(.horizontal, 16).padding(.top, 12)

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        estadoBadge(statusId: report.statusId)
                        Spacer()
                    }
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.08))
                        .frame(height: 120)
                        .overlay(
                            Image(systemName: "photo")
                                .foregroundColor(.white.opacity(0.6))
                                .font(.system(size: 36))
                        )
                    infoRow(icon: "link", title: "URL reportada", content: report.url)
                    infoRow(icon: "text.quote", title: "Descripción del reporte", content: report.description)
                    infoRow(icon: "tag", title: "Categoría", content: report.categoryName ?? "Categoría \(report.categoryId)")
                    if let tags = report.tags, !tags.isEmpty {
                        infoRow(
                            icon: "number",
                            title: "Etiquetas",
                            content: "#" + tags.map { $0.name }.joined(separator: " #")
                        )
                    }
                    infoRow(icon: "calendar", title: "Fecha de reporte", content: report.createdAt)
                }
                .padding(16)
                .background(Color.white.opacity(0.06))
                .cornerRadius(12)
                .padding(.horizontal, 16)

                Divider().background(Color.white.opacity(0.1)).padding(.horizontal, 16)

                if isLoading {
                    ProgressView("Cargando comentarios...")
                        .tint(Color(red: 0.0, green: 0.71, blue: 0.737))
                        .foregroundColor(.white)
                        .padding(.top, 12)
                } else if let errorMessage {
                    Text(errorMessage).foregroundColor(.red).padding(.horizontal, 16)
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            if comments.isEmpty {
                                Text("Sin comentarios aún")
                                    .foregroundColor(.white.opacity(0.8))
                            } else {
                                ForEach(comments) { comment in
                                    VStack(alignment: .leading, spacing: 6) {
                                        HStack(spacing: 8) {
                                            Image(systemName: "person.circle")
                                                .foregroundColor(.white.opacity(0.8))
                                            Text("Usuario \(comment.userId ?? 0)")
                                                .foregroundColor(.white.opacity(0.9))
                                                .font(.footnote)
                                            Spacer()
                                            HStack(spacing: 6) {
                                                Image(systemName: "calendar")
                                                    .foregroundColor(.white.opacity(0.8))
                                                Text(comment.createdAt)
                                                    .foregroundColor(.white.opacity(0.9))
                                                    .font(.footnote)
                                            }
                                        }
                                        Text(comment.text)
                                            .foregroundColor(.white)
                                            .fixedSize(horizontal: false, vertical: true)
                                    }
                                    .padding(12)
                                    .background(Color.white.opacity(0.06))
                                    .cornerRadius(12)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 12)
                    }
                }

                VStack(spacing: 10) {
                    HStack(spacing: 8) {
                        Image(systemName: "bubble.right")
                            .foregroundColor(.white.opacity(0.8))
                        Text("Añadir comentario")
                            .foregroundColor(.white.opacity(0.9))
                            .font(.subheadline)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 16)

                    TextEditor(text: $newComment)
                        .frame(height: 100)
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Color.white.opacity(0.06))
                        .cornerRadius(12)
                        .padding(.horizontal, 16)

                    Button {
                        Task { await addComment() }
                    } label: {
                        Text("Enviar")
                            .foregroundColor(.white)
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(newComment.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Color.gray : Color(red: 0.0, green: 0.71, blue: 0.737))
                            .cornerRadius(10)
                    }
                    .disabled(newComment.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                }
            }
        }
        .task { await loadComments() }
    }

    private func loadComments() async {
        isLoading = true
        errorMessage = nil
        do {
            let list = try await HTTPComment().fetchComments(reportId: report.id)
            comments = list
        } catch {
            errorMessage = "No se pudieron cargar los comentarios."
        }
        isLoading = false
    }

    private func addComment() async {
        let text = newComment.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        isLoading = true
        errorMessage = nil
        do {
            _ = try await HTTPComment().createComment(reportId: report.id, text: text)
            newComment = ""
            await loadComments()
        } catch {
            errorMessage = "No se pudo enviar el comentario."
        }
        isLoading = false
    }

    private func infoRow(icon: String, title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Label(title, systemImage: icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.gray)
            Text(content)
                .font(.system(size: 14))
                .foregroundColor(.white)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private func estadoBadge(statusId: Int) -> some View {
        let (text, color): (String, Color) = {
            switch statusId {
            case 2: return ("Verificado", .green)
            case 1: return ("En revisión", .orange)
            default: return ("Desconocido", .gray)
            }
        }()

        return HStack(spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.white)
            Text(text)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 7)
        .background(color)
        .cornerRadius(20)
    }
}