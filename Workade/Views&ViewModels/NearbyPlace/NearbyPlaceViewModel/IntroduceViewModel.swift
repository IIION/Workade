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
    let url: URL
    // 데이터가 받아 진 후, stackView에 데이터를 쌓아주기 위해 다이나믹으로 선언했습니다.
    var introductions: IntroduceViewDynamic<[Content]> = IntroduceViewDynamic([])
    
    init(url: URL) {
        self.url = url
    }
    
    func fetchData() async {
        let result = await networkManager.request(url: url)
        guard let result = result else { return }
        var articles: [Content] = []
        do {
            let searchResult = try? JSONDecoder().decode(DetailDataModel.self, from: result)
            guard let searchResult = searchResult else { return }
            for item in searchResult.content {
                switch item.type {
                case "Image":
                    articles.append(Content(font: nil, type: item.type, context: item.context, color: nil))
                case "Text":
                    articles.append(Content(font: item.font, type: item.type, context: item.context, color: item.color))
                default:
                    break
                }
            }
            introductions.value = articles
        }
    }
    
    func fetchImage(urlString: String) async -> UIImage {
        if let cachedImage = ImageCacheManager.shared.object(id: urlString) {
            return cachedImage
        }
        guard let imageURL = URL(string: urlString) else { return UIImage()}
        let result = await networkManager.request(url: imageURL)
        guard let result = result else { return  UIImage()}
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
