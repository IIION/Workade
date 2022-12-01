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
    
    
}
