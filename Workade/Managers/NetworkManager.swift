//
//  NWManager.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/10/27.
//

// Manager라는 폴더를 다른 사람이 팠으면 폴더트리 conflict날 것 같아서 임시로 소스파일 형태로만 만듭니당.

import Foundation

/// Network관련 최상위 매니저입니다.
///
/// 추상화를 위해 현재는 모든 곳에서 동일하게 사용할 수 있을 정도의 request 메서드만 존재합니다.
/// 좀 더 세부적인 로직은 각 ViewModel에서 View에 뿌리기위해 ViewModel에서 필요한만큼 메서드를 구현하는 방식입니다.
final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func request(url: URL) async -> Data? {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                return nil
            }
            return data
        } catch {
            
        }
        return nil
    }
    
    func fetchHomeData<T: Codable>(_ type: String) async throws -> T {
        guard let url = URL(string: Constants.homeURL + type + ".json") else {
            throw NetworkError.invalidURL
        }
        
        guard let data = await NetworkManager.shared.request(url: url) else {
            throw NetworkError.invalidResponse
        }
    
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            fatalError("Failed json parsing")
        }
    }
}

enum NetworkError: String, Error {
    case invalidURL = "유효하지 않은 url 주소입니다."
    case invalidResponse = "유효하지 않은 response 입니다."
}
