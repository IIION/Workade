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
}
