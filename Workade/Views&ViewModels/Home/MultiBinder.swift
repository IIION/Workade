//
//  MultiBinder.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/10/28.
//

import Foundation

enum Place {
    case home
    case magazine
    case myPage
    case detail
}

final class MultiBinder<T> {
    typealias Block = (T) -> Void

    struct Listener {
        var place: Place
        let block: Block?
    }

    private var listeners = [Listener]()
    
    func bind(at place: Place, _ block: Block?) {
        listeners = listeners.filter { $0.place != place }
        listeners.append(Listener(place: place, block: block))
    }
    
    func bindAndFire(at place: Place, _ block: Block?) {
        listeners = listeners.filter { $0.place != place }
        listeners.append(Listener(place: place, block: block))
        fire()
    }

    func remove(at place: Place) {
        listeners = listeners.filter { $0.place != place }
    }

    private func fire() {
        for listener in listeners {
            listener.block?(value)
        }
    }

    var value: T {
        didSet {
            fire()
        }
    }

    init(_ value: T) {
        self.value = value
    }
}
