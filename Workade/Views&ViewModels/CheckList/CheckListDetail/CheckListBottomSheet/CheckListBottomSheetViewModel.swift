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
            checkListTemplateResource = try await NetworkManager.shared.fetchCheckListTemplateData()
            isCompleteFetch.value = true
        }
    }
}
