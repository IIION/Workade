//
//  CheckListModel.swift
//  Workade
//
//  Created by Wonhyuk Choi on 2022/10/19.
//

import Foundation

struct CheckListModel {
    let id: String = UUID().uuidString
    let title: String
    let emoji: String
    let travelDate: Date
    let tasks: [Todo]
}

struct Todo {
    let content: String
    let done: Bool
}
