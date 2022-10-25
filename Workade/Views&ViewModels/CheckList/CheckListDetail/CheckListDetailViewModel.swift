//
//  CheckListDetailViewModel.swift
//  Workade
//
//  Created by Wonhyuk Choi on 2022/10/23.
//

import UIKit
import CoreData

struct CheckListDetailViewModel {
    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    private var checkListViewModel = CheckListViewModel()
    
    var todos = [Todo]()

    var selectedCheckList: CheckList? {
        didSet {
            loadTodos()
        }
    }
    
    init() {
        checkListViewModel.loadCheckList()
    }
    
    private func saveTodos() {
        guard let context = context else { return }
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    mutating func addTodo() {
        
    }
    
    mutating func loadTodos(with request: NSFetchRequest<Todo> = Todo.fetchRequest()) {
        guard let context = context else { return }
        guard let cid = selectedCheckList?.cid else { return }
        
        let checkListPredicate = NSPredicate(format: "parentCheckList.cid MATCHES %@", cid)
        
        request.predicate = checkListPredicate
        
        do {
            self.todos = try context.fetch(request)
        } catch {
            print("Error fetching data context \(error)")
        }
    }
    
    mutating func updateCheckList(checkList: CheckList) {
        NotificationCenter.default.post(
            name: NSNotification.Name("editCheckList"),
            object: checkList,
            userInfo: nil
        )
    }
    
    mutating func updateTodo(at index: Int, todo: Todo) {
        
    }
    
    mutating func deleteCheckList() {
        guard let cid = self.selectedCheckList?.cid else { return }
        NotificationCenter.default.post(
            name: NSNotification.Name("deleteCheckList"),
            object: cid,
            userInfo: nil
        )
    }
    
    mutating func deleteTodo(at index: Int) {
        guard let context = context else { return }
        
        context.delete(self.todos[index])
        self.todos.remove(at: index)
        
        saveTodos()
    }
}
