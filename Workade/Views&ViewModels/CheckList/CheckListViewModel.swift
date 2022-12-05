//
//  CheckListViewModel.swift
//  Workade
//
//  Created by Wonhyuk Choi on 2022/10/22.
//

import Combine
import UIKit

@MainActor
final class CheckListViewModel {
    private let coreDataManager = CoreDataManager.shared
    
    var checkList = [CheckList]()
    let editCheckListPublisher = PassthroughSubject<CheckList, Never>()
    let deleteCheckListPublisher = PassthroughSubject<String, Never>()
    
    func addCheckList() {
        guard let context = coreDataManager.context else { return }
        
        let newCheckList = CheckList(context: context)
        newCheckList.cid = UUID().uuidString
        newCheckList.title = "제목없음"
        newCheckList.travelDate = Date()
        coreDataManager.saveData()
        checkList.append(newCheckList)
        sortCheckList()
    }
    
    func loadCheckList() {
        checkList = coreDataManager.loadData(with: CheckList.fetchRequest())
        sortCheckList()
    }
    
    func updateCheckList(at index: Int, checkList: CheckList) {
        self.checkList[index] = checkList
        coreDataManager.saveData()
        sortCheckList()
    }
    
    func deleteCheckList(at index: Int) {
        coreDataManager.deleteData(checkList[index])
        checkList.remove(at: index)
        sortCheckList()
    }
    
    func sortCheckList() {
        checkList.sort {
            if let date1 = $0.travelDate,
               let date2 = $1.travelDate {
                return date1 < date2
            }
            return false
        }
    }
}
