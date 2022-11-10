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
    private(set) var isLoading = false
    private(set) var content: GalleryContent?
    private(set) var images: [UIImage] = []
    
    var paginationUnit: Int = 10
    var isCanLoaded: Bool {
        if let items = content?.items {
            return images.count < items.count
        } else {
            return false
        }
    }
    
    func fetchContent(by url: URL) async {
        let result = await manager.request(url: url)
        guard let result = result else { return }
        let searchResult = try? JSONDecoder().decode(GalleryContent.self, from: result)
        guard let searchResult = searchResult else { return }
        self.content = searchResult
        
        await fetchImages()
    }
    
    func fetchImages() async {
        guard
            let content = content,
            isLoading == false,
            isCanLoaded
        else { return }
        
        isLoading = true
        
        let fetchedImages = await withTaskGroup(of: Data?.self) { group in
            var tempImages = [UIImage]()
            let paginationEndPoint = min(images.count + paginationUnit, content.items.count)
            for index in images.count..<paginationEndPoint {
                guard let url = URL(string: content.items[index].context) else { continue }
                group.addTask { [weak self] in
                    return await self?.manager.request(url: url)
                }
            }
            
            for await data in group {
                if let data = data, let image = UIImage(data: data) {
                    tempImages.append(image)
                }
            }
            
            return tempImages
        }
        
        self.images.append(contentsOf: fetchedImages)
        
        isLoading = false
    }
}
