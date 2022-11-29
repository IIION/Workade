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

enum Job: String, CaseIterable, Codable {
    case developer = "개발"
    case designer = "디자인"
    case projectManager = "기획"
    case marketer = "마케팅"
    case creater = "콘텐츠 제작"
    case writer = "작가(글, 웹툰)"
    case artist = "예술가"
    case freelancer = "프리랜서"
    case etc = "기타"
}
