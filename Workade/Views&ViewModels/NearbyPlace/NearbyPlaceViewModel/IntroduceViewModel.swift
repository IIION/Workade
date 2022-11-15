//
//  IntroduceViewModel.swift
//  Workade
//
//  Created by ryu hyunsun on 2022/10/28.
//

import UIKit

@MainActor
class IntroduceViewModel {
    let networkManager = NetworkManager.shared
    // 데이터가 받아 진 후, stackView에 데이터를 쌓아주기 위해 다이나믹으로 선언했습니다.
    var introductions: Binder<[OfficeDetailModel]> = Binder([])
    
    func requestOfficeDetailData(from urlString: String) {
        Task {
            do {
                let detailResource: OfficeDetailResource = try await networkManager.requestResourceData(from: urlString)
                introductions.value = detailResource.content
            } catch {
                let error = error as? NetworkError ?? .unknownError
                print(error.message)
            }
        }
    }
}
