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

// TODO: 모델 GalleryModel file로 따로 빼주세요.
struct GalleryResource: Codable {
    let items: [GalleryImage]
    
    enum CodingKeys: String, CodingKey {
        case items = "content"
    }
}

struct GalleryImage: Codable {
    let content: String
    
    enum CodingKeys: String, CodingKey {
        case content = "context"
    }
}

@MainActor class GalleryViewModel {
    
    private let manager = NetworkManager.shared
    private(set) var isLoading = false
    private(set) var content: GalleryResource?
    private(set) var images: [UIImage] = []
    
    var paginationUnit: Int = 10
    var isCanLoaded: Bool {
        if let items = content?.items {
            return images.count < items.count
        } else {
            return false
        }
    }
    
    func requestGalleryData(urlString: String) async throws {
        self.content = try await manager.requestResourceData(urlString: urlString)
        await fetchImages()
    }
    
    func fetchImages() async {
        guard let content = content,
              isLoading == false,
              isCanLoaded else { return }
        isLoading = true
        let fetchedImages = await withTaskGroup(of: Data?.self) { group in
            var tempImages = [UIImage]()
            let paginationEndPoint = min(images.count + paginationUnit, content.items.count)
            
            for index in images.count..<paginationEndPoint {
                guard let url = URL(string: content.items[index].content) else { continue }
                group.addTask { [weak self] in
                    guard let task = try? await self?.manager.request(url: url) else {
                        return nil
                    }
                    return task
                }
            }
            
            for await data in group.compactMap({$0}) {
                if let image = UIImage(data: data) {
                    tempImages.append(image)
                }
            }
            
            return tempImages
        }
        self.images.append(contentsOf: fetchedImages)
        isLoading = false
    }
}
