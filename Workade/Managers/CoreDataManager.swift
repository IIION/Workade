//
//  CoreDataManager.swift
//  Workade
//
//  Created by Wonhyuk Choi on 2022/11/22.
//

import CoreData
import UIKit

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    func saveData() {
        guard let context = context else { return }
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    func loadData<T: NSManagedObject>(with request: NSFetchRequest<T>, predicate: NSPredicate? = nil) -> [T] {
        guard let context = context else { return [] }
        
        do {
            if let predicate = predicate {
                request.predicate = predicate
            }
            return try context.fetch(request)
        } catch {
            print("Error fetching data context \(error)")
        }
        
        return []
    }
    
    func deleteData<T: NSManagedObject>(_ data: T) {
        guard let context = context else { return }
        context.delete(data)
        saveData()
    }
    
    // MARK: - CheckList
    
    func addCheckList() -> CheckList? {
        guard let context = context else { return nil }
        
        let newCheckList = CheckList(context: context)
        newCheckList.cid = UUID().uuidString
        newCheckList.title = "제목없음"
        newCheckList.travelDate = Date()
        saveData()
        
        return newCheckList
    }
    
    // MARK: - Todo
    
    func addTodo(_ content: String, parentCheckList: CheckList?) -> Todo? {
        guard let context = context else { return nil }
        
        let newTodo = Todo(context: context)
        newTodo.content = content
        newTodo.done = false
        newTodo.editedTime = Date()
        newTodo.parentCheckList = parentCheckList
        saveData()
        
        return newTodo
    }
}
