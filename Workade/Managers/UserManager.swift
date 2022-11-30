//
//  UserManager.swift
//  Workade
//
//  Created by Inho Choi on 2022/11/30.
//

import Combine
import Foundation

class UserManager {
    private init() { }
    
    static let shared = UserManager()
    
    var user = CurrentValueSubject<User?, Never>(nil)
}
