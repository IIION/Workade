//
//  CheckListCellViewModel.swift
//  Workade
//
//  Created by Wonhyuk Choi on 2022/10/27.
//

import CoreData
import UIKit

struct CheckListCellViewModel {
    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    var checkCount = 0
    var uncheckCount = 0
    
    var selectedCheckList: CheckList? {
        didSet {
            let checkPredicate = NSPredicate(format: "done = %d", true)
            let uncheckPredicate = NSPredicate(format: "done = %d", false)
            checkCount = loadTodos(predicate: checkPredicate)
            uncheckCount = loadTodos(predicate: uncheckPredicate)
        }
    }
    
    mutating func loadTodos(with request: NSFetchRequest<Todo> = Todo.fetchRequest(), predicate: NSPredicate) -> Int {
        guard let context = context else { return 0 }
        guard let cid = selectedCheckList?.cid else { return 0 }
        
        let checkListPredicate = NSPredicate(format: "parentCheckList.cid MATCHES %@", cid)
        
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [checkListPredicate, predicate])
        
        do {
            let todos = try context.fetch(request)
            return todos.count
        } catch {
            print("Error fetching data context \(error)")
        }
        return 0
    }
}
