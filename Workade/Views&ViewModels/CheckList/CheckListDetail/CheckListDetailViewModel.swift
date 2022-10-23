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
        
        do {
            self.todos = try context.fetch(request)
        } catch {
            print("Error fetching data context \(error)")
        }
    }
    
    mutating func updateTodo(at index: Int, todo: Todo) {
        
    }
    
    mutating func deleteTodo(at index: Int) {
        
    }
}
