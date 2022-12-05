//
//  UserModel.swift
//  Workade
//
//  Created by Inho Choi on 2022/11/26.
//

import Foundation

struct User: Codable {
    let id: String
    let name: String?
    let email: String?
    let job: Job
    var stickers: [StickerModel]?
    var activeRegion: Region?
}

struct ActiveUser: Codable {
    let id: String
    let job: Job
    let region: Region
    let startDate: Date
    var progressDay: Int? = nil
}

enum Region: String, CaseIterable, Codable {
    case gyeongGiDo
    case jeJuDo
    case gangWonDo
    case chungCheongNamDo
    case chungCheongBukDo
    case jeolLaNamDo
    case jeolLaBukDo
    case gyeongSangNamDo
    case gyeongSangBukDo
    
    var name: String {
        switch self {
        case .gyeongGiDo:
            return "경기도"
        case .gangWonDo:
            return "강원도"
        case .chungCheongBukDo:
            return "충청북도"
        case .chungCheongNamDo:
            return "충청남도"
        case .jeolLaBukDo:
            return "전라북도"
        case .jeolLaNamDo:
            return "전라남도"
        case .gyeongSangBukDo:
            return "경상북도"
        case .gyeongSangNamDo:
            return "경상남도"
        case .jeJuDo:
            return "제주도"
        }
    }
    
    var romaName: String {
        return self.rawValue.prefix(1).uppercased() + self.rawValue.dropFirst().lowercased()
    }
    
    var isCanWorkation: Bool {
        switch self {
        case .jeJuDo:
            return true
        default:
            return false
        }
    }
    
    var imageName: String {
        return self.rawValue + "Background"
    }
    
    var relativePos: CGPoint {
        switch self {
        case .gyeongGiDo:
            return .init(x: 8.65, y: 33)
        case .gangWonDo:
            return .init(x: 68.54, y: 32)
        case .chungCheongBukDo:
            return .init(x: 36.94, y: 16)
        case .chungCheongNamDo:
            return .init(x: 4.22, y: 9)
        case .jeolLaBukDo:
            return .init(x: 26.03, y: -6)
        case .jeolLaNamDo:
            return .init(x: 4.22, y: -21)
        case .gyeongSangBukDo:
            return .init(x: 69.25, y: 4)
        case .gyeongSangNamDo:
            return .init(x: 60.91, y: -22)
        case .jeJuDo:
            return .init(x: 15.13, y: -42)
        }
    }
}
