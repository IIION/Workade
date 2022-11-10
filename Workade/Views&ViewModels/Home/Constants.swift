//
//  Constants.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/10/27.
//

import Foundation

/// 각종 고정값을 저장한 구조체입니다.
///
/// 실수 방지를 위해 따로 빼봤는데 현재는 homeURL만 있습니다.
struct Constants {
    static let officeResourceAddress = "https://raw.githubusercontent.com/IIION/WorkadeData/main/Home/office.json"
    static let magazineResourceAddress = "https://raw.githubusercontent.com/IIION/WorkadeData/main/Home/magazine.json"
    static let checkListResourceAddress = "https://raw.githubusercontent.com/IIION/WorkadeData/main/Checklist/checkList.json"
    
    static let wishMagazine = "wishMagazine"
}
