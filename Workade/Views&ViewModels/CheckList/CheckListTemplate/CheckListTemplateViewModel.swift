//
//  ChecklistTemplateViewModel.swift
//  Workade
//
//  Created by 김예훈 on 2022/10/26.
//

import UIKit

class CheckListTemplateViewModel {
    var todos = [String]()
    
    func addTemplateTodo() {
        NotificationCenter.default.post(
            name: NSNotification.Name("addTodoList"),
            object: todos,
            userInfo: nil
        )
    }
}
