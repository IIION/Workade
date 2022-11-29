//
//  UserModel.swift
//  Workade
//
//  Created by Inho Choi on 2022/11/26.
//

import Foundation

struct User: Codable {
    let id: String
    let name: String
    let email: String
    let job: Job
}

struct ActiveUser: Codable {
    let id: String
    let email: String
    let region: Region
}

enum Region: String, CaseIterable, Codable {
    case gyeongGiDo
    case jeJuDo
    case gangWonDo
    case chungCheongNamDo
    case chungCheongBukDo
    case jeolLaNamDo
    case jeolLBbukDo
    case gyeongSangNamDo
    case gyeongSangBukDo
}
