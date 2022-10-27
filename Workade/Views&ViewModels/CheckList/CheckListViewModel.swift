//
//  CheckListViewModel.swift
//  Workade
//
//  Created by Wonhyuk Choi on 2022/10/22.
//

import CoreData
import UIKit

// TODO: Coredata Manager 분리 예정

struct CheckListViewModel {
    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    var checkList = [CheckList]()
    
    private mutating func saveCheckList() {
        guard let context = context else { return }
        
        do {
            try context.save()
            self.sortCheckList()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    private func generatRandomEmoji() -> String {
        let item = Int.random(in: 128512...128591)
        let emoji = String(UnicodeScalar(item)!)
        return emoji
    }
    
    mutating func addCheckList() {
        guard let context = context else { return }
        
        let newCheckList = CheckList(context: context)
        newCheckList.cid = UUID().uuidString
        newCheckList.title = "제목없음"
        newCheckList.emoji = generatRandomEmoji()
        newCheckList.travelDate = Date()
        self.checkList.append(newCheckList)
        
        self.saveCheckList()
    }
    
    mutating func loadCheckList(with request: NSFetchRequest<CheckList> = CheckList.fetchRequest()) {
        guard let context = context else { return }
        
        do {
            self.checkList = try context.fetch(request)
            self.sortCheckList()
        } catch {
            print("Error fetching data context \(error)")
        }
    }
    
    mutating func updateCheckList(at index: Int, checkList: CheckList) {
        self.checkList[index] = checkList
        
        saveCheckList()
    }
    
    mutating func deleteCheckList(at index: Int) {
        guard let context = context else { return }
        
        context.delete(self.checkList[index])
        self.checkList.remove(at: index)
        
        saveCheckList()
    }
    
    mutating func sortCheckList() {
        self.checkList.sort {
            if let date1 = $0.travelDate,
               let date2 = $1.travelDate {
                return date1 < date2
            }
            return false
        }
    }
}
