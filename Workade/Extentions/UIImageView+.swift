//
//  UIImageView+.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/10/27.
//

import UIKit

extension UIImageView {
    /// 이미지뷰에 **직접 비동기로 이미지를 삽입하는** 메서드를 생성
    /// - **title id**: 오피스의 경우 officeName이 고유 id가 되고, 매거진의 경우 title이 고유 id가 됩니다. 이 id는 이후 NSCashe에 저장하는 Key값으로 사용됩니다.
    /// - **url**: 각 모델이 가지고 있는 imageURL 혹은 그 외 url 등이 이 전달인자로 전달됩니다.
    ///
    /// ImageCacheManager의 object메서드에 id를 넘겨서 해당 id의 캐시이미지가 존재한다면 넘겨주고 바로 return합니다.
    ///
    /// 캐시에 없다면 url을 가공하고, NetworkManager의 request메서드에 url을 전달하여 data를 받습니다.
    ///
    /// 받은 data를 기반으로 이미지뷰 자기 자신의 image에 바로 비동기적으로 image를 넣어주고, 불러오는데 성공한 해당 이미지를 ImageCacheManager의 setObject 메서드를 이용하여 캐시에 저장합니다.
    ///
    /// 문자열에서 URL로의 전환 실패했을 때, 데이터 요청에 실패했을 때, 데이터에서 이미지로의 전환 실패했을 때 에러를 던집니다.
    func setImageURL(_ urlString: String) async throws {
        if let cachedImage = ImageCacheManager.shared.object(id: urlString) {
            self.image = cachedImage
            return
        }
        guard let url = URL(string: urlString) else { throw NetworkError.invalidStringForURL }
        let data = try await NetworkManager.shared.request(url: url)
        guard let image = UIImage(data: data) else { throw NetworkError.invalidDataForImage }
        DispatchQueue.main.async { [weak self] in
            self?.image = image
        }
        ImageCacheManager.shared.setObject(image: image, id: urlString)
    }
}
