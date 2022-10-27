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

/// 여러 개의 클로저를 수용할 수 있는 Binder
///
/// value의 변화로 여러 클로저를 호출시킬 수 있습니다.
/// 참조 관리와 맺고 끊음 컨트롤이 중요합니다.
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
        print(listeners)
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
