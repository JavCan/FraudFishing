import Foundation

struct CreateReportRequest: Codable {
    let categoryId: Int
    let title: String
    let description: String
    let url: String
    let tagNames: [String]
    let imageUrl: String?
}

struct ReportResponse: Codable {
    let id: Int
    let userId: Int
    let categoryId: Int
    let title: String
    let description: String
    let url: String
    let statusId: Int
    let imageUrl: String?
    let voteCount: Int
    let commentCount: Int
    let createdAt: String
    let updatedAt: String
}

// MARK: - Category Mapping Helper (NUEVA EXTENSIÓN)
// Convierte el nombre de la categoría a su ID entero para el DTO.
extension String {
    func toCategoryId() -> Int? {
        switch self {
        case "Phishing":
            return 1
        case "Malware":
            return 2
        case "Scam":
            return 3
        case "Noticias Falsas":
            return 4
        case "Otro":
            return 5
        default:
            return nil
        }
    }
}
// AÑADIR ESTO a ReportDTO.swift (o un archivo similar)
struct ServerErrorResponse: Decodable {
    let message: String
    let error: String?
    let statusCode: Int
}

// MARK: - Tag Response DTO
struct TagResponse: Codable {
    let id: Int
    let name: String
}

// MARK: - Tags Array Response
// Si el endpoint devuelve un array directamente
typealias TagsResponse = [TagResponse]

