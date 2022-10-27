//
//  ImageCacheManager.swift
//  Workade_Tamna
//
//  Created by Hyeonsoo Kim on 2022/10/24.
//

import UIKit

/// 이미지 캐시를 위한 Manager입니다.
///
/// Key를 NSString으로 가공하는 과정을 간소화하기위해 기본 제공 메서드를 한 번 덮은 메서드를 만들었습니다.
final class ImageCacheManager: NSObject { // 캐시를 저장할 싱글톤 클래스.
    static let shared = ImageCacheManager()
    
    private let storage = NSCache<NSString, UIImage>()
    
    private override init() {
        super.init()
        // 캐시에 저장할 수 있는 객체 수의 limit
        storage.countLimit = 200
    }
    
    /// 불러온 이미지를 캐시에 저장하는 메서드
    /// - image: 저장할 이미지
    /// - id: 캐시는 딕셔너리 형태입니다. 고유 key값으로 사용될 id입니다.
    func setObject(image: UIImage, id: String) {
        let cashedKey = NSString(string: id)
        self.storage.setObject(image, forKey: cashedKey)
    }
    
    /// 고유 id를 이용하여 캐시에 저장된 이미지를 불러오는 메서드
    ///
    /// 캐시에서 바로 꺼내서 쓰기에 속도가 굉장히 빠릅니다.
    func object(id: String) -> UIImage? {
        let cashedKey = NSString(string: id)
        return self.storage.object(forKey: cashedKey)
    }
}
