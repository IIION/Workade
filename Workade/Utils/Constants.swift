//
//  Constants.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/10/27.
//

import Foundation

/// 각종 고정값을 저장한 구조체입니다.
enum Constants {
    enum Address {
        static let officeResource = "https://raw.githubusercontent.com/IIION/WorkadeData/main/Home/office.json"
        static let magazineResource = "https://raw.githubusercontent.com/IIION/WorkadeData/main/Home/magazine.json"
        static let checkListResource = "https://raw.githubusercontent.com/IIION/WorkadeData/main/Checklist/checkList.json"
    }
    
    enum Key {
        static let wishMagazine = "wishMagazine"
    }
}
