//
//  APIClient.swift
//  shaka
//
//  Created by 박원빈 on 2022/07/27.
//

import Combine
import Foundation

enum NetworkError: Error {
    case invalidURL
}

struct APIClient {
    private let baseURL = "http://3.36.132.159/"

    func checkUser() async throws -> User {
        let path = "user"
        guard let url = URL(string: "\(baseURL)\(path)") else { throw NetworkError.invalidURL }

        var request = URLRequest(url: url)
        request.addValue("Bearer \(KeyChain.read(key: "accessToken")!)", forHTTPHeaderField: "Authorization")
        let (data, _) = try await URLSession.shared.data(for: request)

        return try JSONDecoder().decode(User.self, from: data)
    }
    
    func checkNickname(_ nickname: String) async throws -> Bool {
        let path = "user/check?nickname=\(nickname)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { throw NetworkError.invalidURL }
        guard let url = URL(string: "\(baseURL)\(encodedPath)") else { throw NetworkError.invalidURL }
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(KeyChain.read(key: "accessToken")!)", forHTTPHeaderField: "Authorization")
        let (data, _) = try await URLSession.shared.data(for: request)

        return try JSONDecoder().decode(Bool.self, from: data)
    }
    
    func signup(_ nickname: String) async throws -> User {
        let path = "user"
        guard let url = URL(string: "\(baseURL)\(path)") else { throw NetworkError.invalidURL }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body = "nickname=\(nickname)"
        request.httpBody = body.data(using: .utf8)
        request.addValue("Bearer \(KeyChain.read(key: "accessToken")!)", forHTTPHeaderField: "Authorization")
        let (data, _) = try await URLSession.shared.data(for: request)

        return try JSONDecoder().decode(User.self, from: data)
    }
}
