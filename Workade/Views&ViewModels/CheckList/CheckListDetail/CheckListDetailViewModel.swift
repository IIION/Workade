//
//  CheckListDetailViewModel.swift
//  Workade
//
//  Created by Wonhyuk Choi on 2022/10/23.
//

import CoreData
import UIKit

@MainActor
final class CheckListDetailViewModel {
    private let coreDataManager = CoreDataManager.shared
    
    var todos = [Todo]()

    var selectedCheckList: CheckList? {
        didSet {
            loadTodos()
        }
    }
    
    func addTodo(_ content: String = "내용없음") {
        guard let newTodo = coreDataManager.addTodo(content, parentCheckList: selectedCheckList) else { return }
        todos.append(newTodo)
    }
    
    func loadTodos() {
        guard let cid = selectedCheckList?.cid else { return }
        
        let checkListPredicate = NSPredicate(format: "parentCheckList.cid MATCHES %@", cid)
        todos = coreDataManager.loadData(
            with: Todo.fetchRequest(),
            predicate: checkListPredicate
        )
    }
    
    func updateCheckList(checkList: CheckList) {
        NotificationCenter.default.post(
            name: NSNotification.Name("editCheckList"),
            object: checkList,
            userInfo: nil
        )
    }
    
    func updateTodo(at index: Int, todo: Todo) {
        todos[index] = todo
        todos[index].editedTime = Date()
        coreDataManager.saveData()
    }
    
    func deleteCheckList() {
        guard let cid = self.selectedCheckList?.cid else { return }
        NotificationCenter.default.post(
            name: NSNotification.Name("deleteCheckList"),
            object: cid,
            userInfo: nil
        )
    }
    
    func deleteTodo(at index: Int) {
        coreDataManager.deleteData(todos[index])
        todos.remove(at: index)
    }
}
