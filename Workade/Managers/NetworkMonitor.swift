//
//  NetworkMonitor.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/12/03.
//

import Combine
import Network

final class NetworkMonitor {
    // Role - trigger&interface
    let becomeSatisfied = PassthroughSubject<Void, Never>()
    
    private var monitor: NWPathMonitor?
    private var status = NWPath.Status.satisfied {
        didSet {
            if oldValue == .unsatisfied && status == .satisfied {
                becomeSatisfied.send()
            }
        }
    }
    
    init() {
        startMonitoring()
    }
    
    private func startMonitoring() {
        monitor = NWPathMonitor()
        monitor?.start(queue: DispatchQueue.global(qos: .background))
        monitor?.pathUpdateHandler = { [weak self] path in
            self?.status = path.status
        }
    }
    
    private func stopMonitoring() {
        monitor?.cancel()
        monitor = nil
    }
}
