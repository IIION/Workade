//
//  GalleryViewModel.swift
//  Workade
//
//  Created by 김예훈 on 2022/10/24.
//

import UIKit

enum NetworkingError: LocalizedError {
    case badURLResponse(url: URL)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .badURLResponse(url: let url): return "[🔥] Bad URL Response \(url)"
        case .unknown: return "[⚠️] Unknown Error"
        }
    }
}

// TODO: 탐나의 NetworkManager와 기능은 일치합니다. 차후 통일 예정
class NetworkingManager {
    private init() { }
    static let shared = NetworkingManager()
    func request(url: URL) async -> Data? {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                return nil
            }
            return data
        } catch {
            print(error)
        }
        return nil
    }
}

struct GalleryContent: Codable {
    let items: [GalleryImage]
    
    enum CodingKeys: String, CodingKey {
        case items = "content"
    }
}

struct GalleryImage: Codable {
    let context: String
}

@MainActor class GalleryViewModel {
    
    private let manager = NetworkingManager.shared
    private let url: URL
    var images: [UIImage] = []
    
    init(url: URL) {
        self.url = url
    }
    
    func fetchImages() async {
        let result = await manager.request(url: url)
        guard let result = result else { return }
        let searchResult = try? JSONDecoder().decode(GalleryContent.self, from: result)
        guard let searchResult = searchResult else { return }
        
        self.images = await withTaskGroup(of: Data?.self) { group in
            
            var images = [UIImage]()
            
            for item in searchResult.items {
                group.addTask {
                    return await self.manager.request(url: URL(string: item.context)!)
                }
            }
            
            for await data in group {
                if let data = data, let image = UIImage(data: data) {
                    images.append(image)
                }
            }
            
            return images
        }
    }
}
