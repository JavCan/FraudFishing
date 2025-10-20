import Foundation

struct CommentResponse: Codable, Identifiable {
    let id: Int
    let reportId: Int
    let userId: Int?
    let text: String
    let createdAt: String
}

struct CreateCommentRequest: Codable {
    let text: String
}