//
//  SettingViewModel.swift
//  Workade
//
//  Created by Hong jeongmin on 2022/12/01.
//

import Foundation

@MainActor
final class SettingViewModel {
    
    func settingLogOut() {
        FirebaseManager.shared.logOut()
    }
}
