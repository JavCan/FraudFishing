import Foundation

final class HTTPComment {
    private let executor = RequestExecutor()

    func fetchComments(reportId: Int) async throws -> [CommentResponse] {
        guard let url = URL(string: "http://localhost:3000/reports/\(reportId)/comments") else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let (data, _) = try await executor.send(request, requiresAuth: false)
        return try JSONDecoder().decode([CommentResponse].self, from: data)
    }

    func createComment(reportId: Int, text: String) async throws -> CommentResponse {
        guard let url = URL(string: "http://localhost:3000/reports/\(reportId)/comments") else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(CreateCommentRequest(text: text))
        let (data, _) = try await executor.send(request, requiresAuth: true)
        return try JSONDecoder().decode(CommentResponse.self, from: data)
    }
}