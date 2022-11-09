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
    
    func requestCheckListTemplateData<T: Codable>() async throws -> T {
        guard let url = URL(string: "https://raw.githubusercontent.com/IIION/WorkadeData/main/Checklist/checkList.json") else {
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

enum NetworkError: Error {
    case invalidStringForURL
    case unsupportedURL(_ url: URL)
    case notConnectedToInternet
    case invalidResponse(_ url: URL)
    case failedJsonParsing
    case unknownError(_ errorCode: Int)
    
    var message: String {
        switch self {
        case .invalidStringForURL: return "url로 변환이 불가능한 문자열입니다."
        case .unsupportedURL(let url): return "지원하지않는 url 주소입니다. URL: \(url)"
        case .notConnectedToInternet: return "네트워크가 꺼져있습니다."
        case .invalidResponse: return "유효하지 않은 response입니다."
        case .failedJsonParsing: return "Json 파싱 작업에 실패했습니다."
        case .unknownError(let errorCode): return "미확인 에러입니다. 에러 코드: \(errorCode)"
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
                return NetworkError.unknownError(error.errorCode)
            }
        } else {
            return NetworkError.invalidResponse(url)
        }
    }
}
