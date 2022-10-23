//
//  CheckListViewModel.swift
//  Workade
//
//  Created by Wonhyuk Choi on 2022/10/22.
//

import UIKit
import CoreData

struct CheckListViewModel {
    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    var checkList = [CheckList]()
    
    private func saveCheckList() {
        guard let context = context else { return }
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    mutating func addCheckList(title: String = "제목없음", emoji: String = "⚽️") {
        guard let context = context else { return }
        
        let newCheckList = CheckList(context: context)
        newCheckList.cid = UUID().uuidString
        newCheckList.title = title
        newCheckList.emoji = emoji
        self.checkList.append(newCheckList)
        
        self.saveCheckList()
    }
    
    mutating func loadCheckList(with request: NSFetchRequest<CheckList> = CheckList.fetchRequest()) {
        guard let context = context else { return }
        
        do {
            self.checkList = try context.fetch(request)
        } catch {
            print("Error fetching data context \(error)")
        }
    }
    
    mutating func updateCheckList(at index: Int, title: String? = nil, emoji: String? = nil, travelDate: Date? = nil) {
        let targetCheckList = self.checkList[index]
        
        if let title = title {
            targetCheckList.title = title
        }
        if let emoji = emoji {
            targetCheckList.emoji = emoji
        }
        if let travelDate = travelDate {
            targetCheckList.travelDate = travelDate
        }
        
        saveCheckList()
    }
    
    mutating func deleteCheckList(at index: Int) {
        guard let context = context else { return }
        
        context.delete(self.checkList[index])
        self.checkList.remove(at: index)
        
        saveCheckList()
    }
}
