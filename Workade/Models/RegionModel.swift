//
//  RegionModel.swift
//  Workade
//
//  Created by 김예훈 on 2022/11/23.
//

import Foundation

enum RegionModel: String, Hashable, CaseIterable {
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
    
    var relativePos: CGPoint {
        switch self {
        case .gyeonggido:
            return .init(x: 8.65, y: 33)
        case .gangwondo:
            return .init(x: 68.54, y: 32)
        case .chungcheongbukdo:
            return .init(x: 36.94, y: 16)
        case .chungcheongnamdo:
            return .init(x: 4.22, y: 9)
        case .jeollabukdo:
            return .init(x: 26.03, y: -6)
        case .jeollanamdo:
            return .init(x: 4.22, y: -21)
        case .gyeongsangbukdo:
            return .init(x: 69.25, y: 4)
        case .gyeongsangnamdo:
            return .init(x: 60.91, y: -22)
        case .jeju:
            return .init(x: 15.13, y: -42)
        }
    }
}
