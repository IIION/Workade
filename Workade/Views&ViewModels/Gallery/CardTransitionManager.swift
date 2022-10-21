//
//  CardTransitionManager.swift
//  Workade
//
//  Created by 김예훈 on 2022/10/21.
//

import Foundation
import UIKit

enum CardTransitionType {
    case presentation
    case dismissal
}

class CardTransitionMananger: NSObject {
    let transitionDuration: Double = 0.8
    var transition: CardTransitionType = .presentation
    let shrinkDuration: Double = 0.2
    
    lazy var dimmingView: UIView = {
        let dimmingView = UIView(frame: .zero)
        dimmingView.backgroundColor = .black
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        
        return dimmingView
    }()
    
    private func addDimmingView(to containerView: UIView) {
        dimmingView.frame = containerView.frame
        dimmingView.alpha = 0.8
        containerView.addSubview(dimmingView)
    }
}

extension CardTransitionMananger: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        containerView.subviews.forEach({ $0.removeFromSuperview()  })
        addDimmingView(to: containerView)
        
        let fromViewController = transitionContext.viewController(forKey: .from)
        let toViewController = transitionContext.viewController(forKey: .to)
        
        guard let galleryViewController = (transition == .presentation) ? (fromViewController as? GalleryViewController) : (toViewController as? GalleryViewController) else { return }
        
        let indexPath = galleryViewController.collectionView.indexPathsForSelectedItems
        indexPath?.forEach({ path in
            print(path.row)
        })
        
        transitionContext.completeTransition(true)
    }
}

extension CardTransitionMananger: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition = .presentation
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition = .dismissal
        return self
    }
}
