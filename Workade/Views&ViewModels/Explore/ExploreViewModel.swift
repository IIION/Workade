//
//  ExploreViewModel.swift
//  Workade
//
//  Created by 김예훈 on 2022/11/22.
//

import Foundation

enum Region: String, Hashable {
    case seoul
    case incheon
    case gwangju
    case daegu
    case ulsan
    case busan
    case gyeonggido
    case gangwondo
    case chungcheongbukdo
    case chungcheongnamdo
    case jeollabukdo
    case jeollanamdo
    case gyeongsangbukdo
    case gyeongsangnamdo
    case jeju
    case sejong
    
    var name: String {
        switch self {
        case .seoul:
            return "서울"
        case .incheon:
            return "인천"
        case .gwangju:
            return "광주"
        case .daegu:
            return "대구"
        case .ulsan:
            return "울산"
        case .busan:
            return "부산"
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
        case .sejong:
            return "세종"
        }
    }
    
    var imageName: String {
        switch self {
        case .seoul:
            return ""
        case .incheon:
            return ""
        case .gwangju:
            return ""
        case .daegu:
            return ""
        case .ulsan:
            return ""
        case .busan:
            return "launch"
        case .gyeonggido:
            return ""
        case .gangwondo:
            return ""
        case .chungcheongbukdo:
            return ""
        case .chungcheongnamdo:
            return ""
        case .jeollabukdo:
            return ""
        case .jeollanamdo:
            return ""
        case .gyeongsangbukdo:
            return ""
        case .gyeongsangnamdo:
            return ""
        case .jeju:
            return ""
        case .sejong:
            return ""
        }
    }
}

@MainActor
final class ExploreViewModel {   
    var selectedRegion: Binder<Region?> = Binder(nil)
}
