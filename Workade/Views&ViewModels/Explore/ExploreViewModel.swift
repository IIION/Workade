//
//  ExploreViewModel.swift
//  Workade
//
//  Created by 김예훈 on 2022/11/22.
//

import Foundation

enum Region: Hashable {
    case seoul
    case incheon
    case gwangju
    case daegu
    case ulsan
    case busan
    case gyeonggi
    case gangwon
    case chungcheongbuk
    case chungcheongnam
    case jeollabuk
    case jeollanam
    case gyeongsangbuk
    case gyeongsangnam
}

@MainActor
final class ExploreViewModel {   
    var selectedRegion: Binder<Region?> = Binder(nil)
}
