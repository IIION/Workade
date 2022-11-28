//
//  CheckListDetailViewModel.swift
//  Workade
//
//  Created by Wonhyuk Choi on 2022/10/23.
//

import Combine
import CoreData
import UIKit

@MainActor
final class CheckListDetailViewModel {
    private let coreDataManager = CoreDataManager.shared
    
    var todos = [Todo]()
    let addTemplatePublisher = PassthroughSubject<[String], Never>()

    var selectedCheckList: CheckList? {
        didSet {
            loadTodos()
        }
    }
    
    func addTodo(_ content: String = "내용없음") {
        guard let context = coreDataManager.context else { return }
        
        let newTodo = Todo(context: context)
        newTodo.content = content
        newTodo.done = false
        newTodo.editedTime = Date()
        newTodo.parentCheckList = selectedCheckList
        coreDataManager.saveData()
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
    
    func updateTodo(at index: Int, todo: Todo) {
        todos[index] = todo
        todos[index].editedTime = Date()
        coreDataManager.saveData()
    }
    
    func deleteTodo(at index: Int) {
        coreDataManager.deleteData(todos[index])
        todos.remove(at: index)
    }
}
