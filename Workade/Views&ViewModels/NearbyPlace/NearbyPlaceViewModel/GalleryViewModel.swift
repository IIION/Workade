//
//  GalleryViewModel.swift
//  Workade
//
//  Created by 김예훈 on 2022/10/24.
//

import UIKit

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
    
    private let manager = NetworkManager.shared
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
