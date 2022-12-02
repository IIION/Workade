//
//  NetworkMonitor.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/12/03.
//

import Combine
import Network

final class NetworkMonitor {
    init() {
        startMonitoring()
    }
    
    // interface 파트
    let becomeSatisfied = PassthroughSubject<Void, Never>()
    
    // 구현 파트
    private var monitor = NWPathMonitor()
    private var status = NWPath.Status.unsatisfied {
        didSet {
            if status == .satisfied {
                becomeSatisfied.send()
            }
        }
    }
    
    private func startMonitoring() {
        monitor.start(queue: DispatchQueue.global(qos: .background))
        monitor.pathUpdateHandler = { [weak self] path in
            self?.status = path.status
        }
    }
}
