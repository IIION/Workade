//
//  WorkerStatusSheetViewModel.swift
//  Workade
//
//  Created by Inho Choi on 2022/12/01.
//

import Combine
import Foundation

@MainActor
class WorkerStatusSheetViewModel {
    var numberOfDesigner = CurrentValueSubject<Int, Never>(0)
    var numberOfDeveloper = CurrentValueSubject<Int, Never>(0)
    var numberOfWriter = CurrentValueSubject<Int, Never>(0)
    var numberOfPM = CurrentValueSubject<Int, Never>(0)
    var numberOfCreator = CurrentValueSubject<Int, Never>(0)
    var numberOfMarketer = CurrentValueSubject<Int, Never>(0)
    var numberOfArtist = CurrentValueSubject<Int, Never>(0)
    var numberOfFreelancer = CurrentValueSubject<Int, Never>(0)
    var numberOfEtc = CurrentValueSubject<Int, Never>(0)
    
    init(region: Region) {
        Task {
            let activeUsers = UserManager.shared.activeUsers[region]
            numberOfPM.value = activeUsers?[Job.PM]?.count ?? 0
            numberOfDesigner.value = activeUsers?[Job.designer]?.count ?? 0
            numberOfDeveloper.value = activeUsers?[Job.developer]?.count ?? 0
            print(numberOfDeveloper.value)
            numberOfWriter.value = activeUsers?[Job.writer]?.count ?? 0
            numberOfCreator.value = activeUsers?[Job.creater]?.count ?? 0
            numberOfMarketer.value = activeUsers?[Job.marketer]?.count ?? 0
            numberOfArtist.value = activeUsers?[Job.artist]?.count ?? 0
            numberOfFreelancer.value = activeUsers?[Job.freelancer]?.count ?? 0
            numberOfEtc.value = activeUsers?[Job.etc]?.count ?? 0
        }
    }
}
