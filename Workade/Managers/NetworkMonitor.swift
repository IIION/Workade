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
    
    deinit {
        stopMonitoring()
    }
    
    // interface 파트
    let becomeSatisfied = PassthroughSubject<Void, Never>()
    
    // 구현 파트
    private var monitor = NWPathMonitor()
    
    private func startMonitoring() {
        monitor.start(queue: DispatchQueue.global(qos: .background))
        monitor.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                self?.becomeSatisfied.send()
            }
        }
    }
    
    private func stopMonitoring() {
        monitor.cancel()
    }
}
