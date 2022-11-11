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
    var introductions: IntroduceViewDynamic<[OfficeDetailModel]> = IntroduceViewDynamic([])
    
    func requestOfficeDetailData(urlString: String) {
        Task {
            do {
                let detailResource: OfficeDetailResource = try await networkManager.requestResourceData(urlString: urlString)
                introductions.value = detailResource.content
            } catch {
                let error = error as? NetworkError ?? .unknownError
                print(error.message)
            }
        }
    }
}

// TODO: 다음 PR 수정사항.
// 기존 Binder class와 구조가 같아서 다음 PR에서 제거 예정.
class IntroduceViewDynamic<T> {
    typealias Listener = (T) -> Void
    var listener: Listener?
    
    func bind(_ listener: Listener?) {
        self.listener = listener
    }
    
    func bindAndFire(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ val: T) {
        value = val
    }
}