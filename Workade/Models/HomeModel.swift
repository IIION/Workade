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

// 식별자로 북마크 여부 판단 및 마이페이지에서 찜한 애들만 불러옴
// Int는 아니어도 무관 (고유한 값이기만 하면 됩니다.)
struct Megazine {
    let id: Int
    let title: String
    let profileImage: UIImage
}
// 다른 프로퍼티는 필요한 시점에 추가하겠습니다.
