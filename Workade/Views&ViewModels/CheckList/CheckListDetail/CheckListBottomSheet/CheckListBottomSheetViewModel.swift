//
//  CheckListBottomSheetViewModel.swift
//  Workade
//
//  Created by Wonhyuk Choi on 2022/10/28.
//

import UIKit

@MainActor
final class CheckListBottomSheetViewModel {
    var checkListTemplateResource = CheckListTemplateResource(context: [])
    
    var isCompleteFetch = Binder(false)
    
    init() {
        fetchData()
    }
    
    private func fetchData() {
        Task {
            checkListTemplateResource = try await fetchCheckListTemplateData()
            isCompleteFetch.value = true
        }
    }
    
    private func fetchCheckListTemplateData<T: Codable>() async throws -> T {
        guard let url = URL(string: "https://raw.githubusercontent.com/IIION/WorkadeData/main/Checklist/checkList.json") else {
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
