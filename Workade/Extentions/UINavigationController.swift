//
//  UINavigationController.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/10/26.
//

import UIKit

// 네비게이션 기본 backButton이 아닌, 커스텀으로 backButton을 만들어도,
// Swipe Pop Gesture가 가능하도록 extension
extension UINavigationController: UIGestureRecognizerDelegate {
    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // rootVC일 경우 pop Swipe 유효하지않도록.
        return viewControllers.count > 1
    }
}
