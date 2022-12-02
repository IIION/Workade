//
//  StickerModel.swift
//  Workade
//
//  Created by 김예훈 on 2022/12/02.
//

import Foundation

struct StickerModel: Codable {
    let date: Date
    let title: StickerTitle
    let region: Region
}

enum StickerTitle: String, Codable {
    case halLaBong
    case halLaSan
    case dolHaReuBang
    case horse
    
    var name: String {
        switch self {
        case .halLaBong:
            return "한라봉 스티커"
        case .halLaSan:
            return "한라산 스티커"
        case .dolHaReuBang:
            return "돌하르방 스티커"
        case .horse:
            return "제주말 스티커"
        }
    }
}
