//
//  HomeViewModel.swift
//  Workade
//
//  Created by Inho Choi on 2022/10/18.
//

import UIKit

@MainActor
final class HomeViewModel {
    var officeResource = OfficeResource(context: [])
    var magazineResource = MagazineResource(content: [])
    
    /// 모델 데이터 fetch가 완료되었을 때, HomeViewController에 알려주는 역할을 할 Binder 타입의 변수
    var isCompleteFetch = Binder(false)
    
    init() {
        fetchData()
    }
    
    private func fetchData() {
        Task {
            officeResource = try await fetchHomeData("office")
            magazineResource = try await fetchHomeData("magazine")
            isCompleteFetch.value = true
        }
    }
    
    private func fetchHomeData<T: Codable>(_ type: String) async throws -> T {
        guard let url = URL(string: Constants.homeURL + type + ".json") else {
            throw NetworkError.invalidURL
        }
        
        guard let data = await NetworkManager.shared.request(url: url) else {
            throw NetworkError.invalidResponse
        }
    
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            fatalError("Failed json parsing")
        }
    }
}
