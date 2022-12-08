import Foundation

// MARK: - Request Defunctionalization
struct UrlRequest: Codable {
    var urlRequest: URLRequest {
        .init(url: .init(string: "")!)
    }
}

indirect enum Request: Codable {
    case print(Data)
    case urlRequest(UrlRequest)
}

func apply(
    request: Request,
    urlSession: (URLRequest) async throws -> (Data, URLResponse) = URLSession.shared.data(for:)
) async throws {
    switch request {
    case let .urlRequest(urlRequest):
        let (data, response): (Data, URLResponse)

        do {
            (data, response) = try await urlSession(urlRequest.urlRequest)
            try await apply(request: .print(data))
        } catch {
            throw NetworkError.network(error: error)
        }
        guard let response = response as? HTTPURLResponse else { throw NetworkError.invalidResponse }
        if response.statusCode >= 400 {
            throw NetworkError.httpError(response: response, body: data)
        }
    case let .print(data):
        print(data)
    }
}

// MARK: - Original implementation
enum NetworkError: LocalizedError {
    case httpError(response: HTTPURLResponse, body: Data)
    case invalidResponse
    case network(error: Error)
}

func makeRequest(
    urlRequest: URLRequest,
    urlSession: (URLRequest) async throws -> (Data, URLResponse) = URLSession.shared.data(for:)
) async throws -> (Data, HTTPURLResponse) {
    let (data, response) = try await urlSession(urlRequest)
    guard let response = response as? HTTPURLResponse else { throw NetworkError.invalidResponse }
    return (data, response)
}
