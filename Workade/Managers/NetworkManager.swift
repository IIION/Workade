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
/// 모든 곳에서 동일하게 사용할 수 있을 정도의 request 메서드가 존재합니다.
/// 그 외에 일회성으로 요청하는데에 쓰이는 requestResourceData 메서드가 있는데 모델배열을 content라는 프로퍼티로 갖는 모델을 요청하고 parsing하는데 공통적으로 사용되는 메서드입니다.
final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func request(url: URL) async throws -> Data {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw NetworkError.invalidResponse(url)
            }
            return data
        } catch {
            throw NetworkError.throwError(url: url, error)
        }
    }
    
    func requestResourceData<T: Codable>(urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidStringForURL
        }
        
        let data = try await request(url: url)
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.failedJsonParsing
        }
    }
}

enum NetworkError: Error {
    case invalidStringForURL
    case invalidDataForImage
    case unsupportedURL(_ url: URL)
    case notConnectedToInternet
    case invalidResponse(_ url: URL)
    case failedJsonParsing
    case unknownURLError(_ errorCode: Int)
    case unknownError
    
    var message: String {
        switch self {
        case .invalidStringForURL: return "✍🏻 url로 변환이 불가능한 문자열입니다."
        case .invalidDataForImage: return "🌁 UIImage로 변환이 불가능한 Data입니다."
        case .unsupportedURL(let url): return "📪 지원하지않는 url 주소입니다. URL: \(url)"
        case .notConnectedToInternet: return "💤 네트워크가 꺼져있습니다."
        case .invalidResponse: return "👹 유효하지 않은 response입니다."
        case .failedJsonParsing: return "📑 Json 파싱 작업에 실패했습니다."
        case .unknownURLError(let errorCode): return "⁉️ 미확인 URL관련 에러입니다. 에러 코드: \(errorCode)"
        case .unknownError: return "🤯 원인을 알 수 없는 에러입니다!"
        }
    }
    
    static func throwError(url: URL, _ error: Error) -> NetworkError {
        if let error = error as? URLError {
            switch error.errorCode {
            case -1002:
                return NetworkError.unsupportedURL(url)
            case -1009:
                return NetworkError.notConnectedToInternet
            default:
                return NetworkError.unknownURLError(error.errorCode)
            }
        } else {
            return NetworkError.invalidResponse(url)
        }
    }
}
