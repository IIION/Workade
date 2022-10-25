//
//  HomeModel.swift
//  Workade
//
//  Created by Inho Choi on 2022/10/18.
//

import UIKit

struct Office {
    let officeName: String
    let regionName: String
    let profileImage: UIImage
    let latitude: Double
    let longitude: Double
}

/// **매거진 모델**
/// - id: 북마크 상태 추적, 이미지 불러오기, 이미지 캐싱 등에 사용
/// - title: 매거진의 제목
/// - profileImage: 프로필의 이미지 (추후 없어질 수도 있음)
struct Magazine {
    let id: Int
    let title: String
    let profileImage: UIImage
}
// 다른 프로퍼티는 필요한 시점에 추가하겠습니다.
