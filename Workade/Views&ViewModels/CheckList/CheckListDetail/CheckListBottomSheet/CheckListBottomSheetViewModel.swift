//
//  CheckListBottomSheetViewModel.swift
//  Workade
//
//  Created by Wonhyuk Choi on 2022/10/28.
//

import UIKit

@MainActor
final class CheckListBottomSheetViewModel {
    var checkListTemplateResource = CheckListTemplateResource()
    
    var isCompleteFetch = Binder(false)
    
    init() {
        fetchData()
    }
    
    private func fetchData() {
        Task {
            checkListTemplateResource = try await NetworkManager.shared.requestResourceData(from: Constants.Address.checkListResource)
            isCompleteFetch.value = true
        }
    }
    
    @objc func addTemplateTodo(_ todoList: [String]) {
        NotificationCenter.default.post(
            name: NSNotification.Name("addTodoList"),
            object: todoList,
            userInfo: nil
        )
    }
}
