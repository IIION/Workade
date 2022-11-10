//
//  IntroduceViewModel.swift
//  Workade
//
//  Created by ryu hyunsun on 2022/10/28.
//

import UIKit

@MainActor
class IntroduceViewModel {
    let networkManager = NetworkManager.shared
    // 데이터가 받아 진 후, stackView에 데이터를 쌓아주기 위해 다이나믹으로 선언했습니다.
    var introductions: IntroduceViewDynamic<[OfficeDetail]> = IntroduceViewDynamic([])
    
    func requestOfficeDetailData(urlString: String) {
        Task {
            do {
                let detailResource: OfficeDetailResource = try await networkManager.requestResourceData(urlString: urlString)
                introductions.value = detailResource.content
            } catch {
                let error = error as? NetworkError ?? .unknownError
                print(error.message)
            }
        }
    }
    
    func fetchImage(urlString: String) async throws -> UIImage {
        if let cachedImage = ImageCacheManager.shared.object(id: urlString) {
            return cachedImage
        }
        guard let imageURL = URL(string: urlString) else { return UIImage()}
        let result = try await networkManager.request(url: imageURL)
        guard let image = UIImage(data: result) else { return UIImage()}
        ImageCacheManager.shared.setObject(image: image, id: urlString)
        return image
    }
}

class IntroduceViewDynamic<T> {
    typealias Listener = (T) -> Void
    var listener: Listener?
    
    func bind(_ listener: Listener?) {
        self.listener = listener
    }
    
    func bindAndFire(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ val: T) {
        value = val
    }
}
