//
//  UIViewPropertyAnimator+.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/11/24.
//
//  아직까진 완전히 제네릭한 구성은 아니고, 한 세트라고 판단하여 하나의 소스파일에 모았습니다.

import UIKit

/**
 형태 변경 예약과 관련된 구조체 모델
 - **attribute**: alpha, cornerRadius 등 어떤 속성에 대한 값인지 정합니다.
 - **fromValue**: 변경 전 value입니다.
 - **toValue**: 변경 후 value입니다.
 - **animated**: default true입니다. false일 경우, animation 효과는 일어나지않고, 즉시 형태가 변합니다.
 */
struct Reservation {
    let attribute: Attribute
    let fromValue: CGFloat
    let toValue: CGFloat
    var animated: Bool
    
    enum Attribute {
        case alpha
        case cornerRadius
    }
    
    init(_ attribute: Attribute, from value1: CGFloat, to value2: CGFloat, animated: Bool = true) {
        self.attribute = attribute
        self.fromValue = value1
        self.toValue = value2
        self.animated = animated
    }
}

extension UIView {
    /**
     모든 UIView 타입 객체들의 예약된 형태 변화들을 저장하는 프로퍼티
     
     - key: 해당 UIView의 메모리 주소를 key값으로 삼는다. String(describing:)으로 할까 했으나, 이는 해당 객체의 속성이 변하면 값이 변해서 key값으로 적당치않음.
     - value: 해당 UIView에 등록된 예약들이 담긴 배열.
     */
    private static var totalReservations = [String: [Reservation]]()
    
    /// 각 UIView 타입 객체의 예약된 형태 변화들을 담는 프로퍼티
    var reservations: [Reservation] {
        get {
            let address = String(format: "%p", unsafeBitCast(self, to: Int.self))
            return UIView.totalReservations[address] ?? []
        }
        set {
            let address = String(format: "%p", unsafeBitCast(self, to: Int.self))
            UIView.totalReservations[address] = newValue
        }
    }
    
    /// 전달받은 reservation을 기반으로 새로운 value를 UIView 객체에 할당하는 메서드.
    func changeAttribute(reservation: Reservation, isForward: Bool) {
        let oldValue = isForward ? reservation.fromValue : reservation.toValue
        let newValue = isForward ? reservation.toValue : reservation.fromValue
        switch reservation.attribute {
        case .alpha:
            self.alpha = oldValue
            self.alpha = newValue
        case .cornerRadius:
            self.layer.cornerRadius = oldValue
            self.layer.cornerRadius = newValue
        }
    }
}

extension UIViewPropertyAnimator {
    /**
     UIView 객체들의 예약내역들을 확인하고 animated == true인 예약들만을 animation 클로저에 담아주는 메서드.
     - views: 예약 내역이 있는 UIView 객체들. 없는 애들 같이 넣어도 어차피 빈 값이라 괜찮습니다.
     - isForward: 애니메이션이 일어나는 방향. (<-> reversed)
     - animationClosure: Reservation과 관련없는 기타 애니메이션 관련 실행문들을 담을 수 있는 클로저.
     */
    func addAnimation(views: [UIView], isForward: Bool, animationClosure: @escaping () -> Void) {
        views.forEach { view in
            view.reservations.forEach { reservation in
                if reservation.animated {
                    self.addAnimations {
                        view.changeAttribute(reservation: reservation, isForward: isForward)
                    }
                } else {
                    view.changeAttribute(reservation: reservation, isForward: isForward)
                }
            }
        }
        self.addAnimations {
            animationClosure()
        }
    }
}
