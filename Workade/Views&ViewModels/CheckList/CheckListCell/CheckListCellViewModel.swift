//
//  CheckListCellViewModel.swift
//  Workade
//
//  Created by Wonhyuk Choi on 2022/10/27.
//

import UIKit

@MainActor
final class CheckListCellViewModel {
    private let coreDataManager = CoreDataManager.shared
    
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
    
    func loadTodos(predicate: NSPredicate) -> Int {
        guard let cid = selectedCheckList?.cid else { return 0 }
        
        let checkListPredicate = NSPredicate(format: "parentCheckList.cid MATCHES %@", cid)
        return coreDataManager.loadData(
            with: Todo.fetchRequest(),
            predicate: NSCompoundPredicate(andPredicateWithSubpredicates: [checkListPredicate, predicate])
        ).count
    }
}
