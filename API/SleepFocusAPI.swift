//
//  SleepFocusAPI.swift
//  Design
//
//  Created by Austin Kim on 1/23/26.
//

import Foundation

enum APIError: Error {
    case badStatus(Int)
}

final class SleepFocusAPI {
    private let baseURL = URL(string: "https://sleepfocusapi.austin.kim")!
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func postInput(_ payload: InputPayload) async throws {
        let url = baseURL.appendingPathComponent("input")
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        req.httpBody = try encoder.encode(payload)

        let (_, resp) = try await session.data(for: req)
        let code = (resp as? HTTPURLResponse)?.statusCode ?? -1
        guard (200...299).contains(code) else { throw APIError.badStatus(code) }
    }
}
