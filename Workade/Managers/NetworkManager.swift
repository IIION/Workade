//
//  NetworkManager.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/10/27.
//

// Manager라는 폴더를 다른 사람이 팠으면 폴더트리 conflict날 것 같아서 임시로 소스파일 형태로만 만듭니당.

import UIKit

/**
 Network관련 최상위 매니저입니다.

 각종 Network Logic과 관련된 메서드들이 존재합니다.
 매니저이니만큼 특정 몇몇을 위한 메서드가 아닌, **필요 시 보편적으로 모든 곳에서 사용할 수 있는 형태의 메서드**로만 구성했습니다.
 각 메서드들은 각종 에러를 던질 수 있고, **모든 에러는 NetworkError타입**으로 던지기 때문에 NetworkError타입으로 캐스팅하여 에러를 출력하면 됩니다.
 */
final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    /**
     url을 기반으로 데이터를 받아오는 메서드로, NetworkManager에서 가장 중추가 되는 메서드입니다.**
    
     throws메서드로써 각종 에러를 throw할 수 있습니다.
     
     **1)** 네트워크가 꺼져있을 때의 오류, **2)** 홈을 찾을 수 없는 url일 때의 오류, **3)** 홈은 찾았으나 잘못된 주소일 때의 오류, **4)** response status code가 200이 아닐 때의 오류 등의 에러를 던질 수 있습니다. ( + unknown error )
     */
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
    
    /**
     **Resource접미사를 가진 모든 모델을 불러오고 파싱하는데 사용할 수 있는 메서드**

     현재 let content: [T] 프로퍼티를 가진 모든 모델을 _Resource접미사 형태로 네이밍 통일한 상태입니다.
     그 모델들을 불러올 수 있습니다.

     총 6가지 형태의 에러를 던질 수 있습니다.  ( + unknown error )
     */
    func requestResourceData<T: Codable>(from urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidStringForURL
        }
        
        let data = try await request(url: url)
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print(url)
            throw NetworkError.failedJsonParsing
        }
    }
    
    /**
     **imageURL 문자열을 기반으로 이미지를 반환하는 메서드입니다.**

     이 메서드 안에서 URL로 가공하고 발생가능한 에러를 던져주기 때문에 url은 String형태로 넘기면 됩니다.

     기본적으로 NSCashe를 이용하는 형태이며, **캐시에 저장되어있으면 API호출을 하지않습니다.**

     총 6가지 형태의 에러를 던질 수 있습니다.  ( + unknown error )
     */
    func fetchImage(from urlString: String) async throws -> UIImage {
        if let cachedImage = ImageCacheManager.shared.object(id: urlString) {
            return cachedImage
        }
        guard let imageURL = URL(string: urlString) else { throw NetworkError.invalidStringForURL }
        let result = try await request(url: imageURL)
        guard let image = UIImage(data: result) else { throw NetworkError.invalidDataForImage }
        ImageCacheManager.shared.setObject(image: image, id: urlString)
        return image
    }
}

/**
 **네트워크 관련해서 발생할 수 있는 에러케이스들을 모은 Error프로토콜 준수 열거형**
 - **invalidStringForURL**: URL로 전환이 불가능한 문자열을 건네주었을 때 발생가능한 에러입니다. ex) 한글 섞인 주소 등.
 - **invalidDataForImage**: Data에서 UIImage로의 전환이 불가능할 때 발생가능한 에러입니다. ex) status code 200으로 받은 데이터이지만, 이미지 관련 데이터가 아니였을 때.
 - **unsupportedURL(_ url: URL)**: 홈 주소를 찾을 수 없는 URL주소일 때 발생가능한 에러입니다. ex) http://www.tammmmnaaaa.com 따위
 - **notConnectedToInternet**: 네트워크환경이 꺼져있을 때 발생가능한 에러입니다.
 - **invalidResponse(_ url: URL)**: response의 status code가 200이 아닐 때 발생하는 에러입니다. (홈주소까진 정상적이나 그 이후 주소의 문제 or 그 외 등등)
 - **failedJsonParsing**: Json데이터를 모델로 parsing하는 과정에서 발생가능한 에러입니다.
 - **unexpectedURLError(_ errorCode: Int)**: 미리 예상하지 못한 URLError타입의 에러입니다. errorCode가 함께 출력됩니다.
 - **unknownError**: URLError도 아니고, 미리 예상한 에러가 아닌 완전 새로운 종류의 에러 발생상황 시 출력할 case입니다.
 */
enum NetworkError: Error {
    case invalidStringForURL
    case invalidDataForImage
    case unsupportedURL(_ url: URL)
    case notConnectedToInternet
    case invalidResponse(_ url: URL)
    case failedJsonParsing
    case unexpectedURLError(_ errorCode: Int)
    case unknownError
    
    /// 에러 메시지입니다. catch문에서 error를 NetworkError로 캐스팅한후 .message로 에러문 출력하면 됩니다.
    var message: String {
        switch self {
        case .invalidStringForURL: return "✍🏻 url로 변환이 불가능한 문자열입니다."
        case .invalidDataForImage: return "🌁 UIImage로 변환이 불가능한 Data입니다."
        case .unsupportedURL(let url): return "📪 지원하지않는 url 주소입니다. URL: \(url)"
        case .notConnectedToInternet: return "💤 네트워크가 꺼져있습니다."
        case .invalidResponse: return "👹 유효하지 않은 response입니다."
        case .failedJsonParsing: return "📑 Json 파싱 작업에 실패했습니다."
        case .unexpectedURLError(let errorCode): return "⁉️ 미리 예상하지못한 URL관련 에러입니다. 에러 코드: \(errorCode)"
        case .unknownError: return "🤯 원인을 알 수 없는 에러입니다!"
        }
    }
    
    /// NetworkManager의 request메서드에서 발생가능한 에러들을 상황별로 구분하여 반환하는 메서드입니다.
    static func throwError(url: URL, _ error: Error) -> NetworkError {
        if let error = error as? URLError {
            switch error.errorCode {
            case -1002:
                return NetworkError.unsupportedURL(url)
            case -1009:
                return NetworkError.notConnectedToInternet
            default:
                return NetworkError.unexpectedURLError(error.errorCode)
            }
        } else {
            return NetworkError.invalidResponse(url)
        }
    }
}
