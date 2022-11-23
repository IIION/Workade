//
//  RegionModel.swift
//  Workade
//
//  Created by 김예훈 on 2022/11/23.
//

import Foundation

enum RegionModel: String, Hashable {
    case gyeonggido
    case gangwondo
    case chungcheongbukdo
    case chungcheongnamdo
    case jeollabukdo
    case jeollanamdo
    case gyeongsangbukdo
    case gyeongsangnamdo
    case jeju
    
    var name: String {
        switch self {
        case .gyeonggido:
            return "경기도"
        case .gangwondo:
            return "강원도"
        case .chungcheongbukdo:
            return "충청북도"
        case .chungcheongnamdo:
            return "충청남도"
        case .jeollabukdo:
            return "전라북도"
        case .jeollanamdo:
            return "전라남도"
        case .gyeongsangbukdo:
            return "경상북도"
        case .gyeongsangnamdo:
            return "경상남도"
        case .jeju:
            return "제주도"
        }
    }
    
    var imageName: String {
        let backgroundString = "background"
        return self.rawValue + backgroundString
    }
}
