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
    
    var todos = [Todo]()

    var selectedCheckList: CheckList? {
        didSet {
            loadTodos()
        }
    }
    
    private mutating func saveTodos() {
        guard let context = context else { return }
        
        do {
            try context.save()
            self.todos.sort {
                if $0.done == $1.done {
                    if let date1 = $0.editedTime,
                       let date2 = $1.editedTime {
                        return date1 > date2
                    }
                    return false
                } else {
                    return Int(truncating: NSNumber(value: $0.done)) < Int(truncating: NSNumber(value: $1.done))
                }
            }
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    mutating func addTodo() {
        guard let context = context else { return }
        
        let newTodo = Todo(context: context)
        newTodo.content = "내용없음"
        newTodo.done = false
        newTodo.editedTime = Date()
        newTodo.parentCheckList = self.selectedCheckList
        self.todos.append(newTodo)
        
        self.saveTodos()
    }
    
    mutating func loadTodos(with request: NSFetchRequest<Todo> = Todo.fetchRequest()) {
        guard let context = context else { return }
        guard let cid = selectedCheckList?.cid else { return }
        
        let checkListPredicate = NSPredicate(format: "parentCheckList.cid MATCHES %@", cid)
        
        request.predicate = checkListPredicate
        
        do {
            self.todos = try context.fetch(request)
            self.todos.sort {
                if $0.done == $1.done {
                    if let date1 = $0.editedTime,
                       let date2 = $1.editedTime {
                        return date1 > date2
                    }
                    return false
                } else {
                    return Int(truncating: NSNumber(value: $0.done)) < Int(truncating: NSNumber(value: $1.done))
            }
        }
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
        self.todos[index] = todo
        self.todos[index].editedTime = Date()
        
        saveTodos()
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
