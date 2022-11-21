//
//  SheetTransitionManager.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/11/22.
//

import UIKit

enum SheetTransitionType {
    case presentation
    case dismissal
}

class SheetTransitionManager: NSObject {
    
}

extension SheetTransitionManager: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
    }
}

extension SheetTransitionManager: UIViewControllerTransitioningDelegate {
    
}
