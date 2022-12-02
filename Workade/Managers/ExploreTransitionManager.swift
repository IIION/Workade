//
//  ExploreTransitionManager.swift
//  Workade
//
//  Created by 김예훈 on 2022/11/29.
//

import UIKit

final class ExploreTransitionManager: NSObject {
    let duration: Double = 0.4
    private var transition: TransitionType = .presentation
}

extension ExploreTransitionManager: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        containerView.subviews.forEach { $0.removeFromSuperview() }
        
        let fromViewController = transitionContext.viewController(forKey: .from)
        let toViewController = transitionContext.viewController(forKey: .to)
        
        guard let exploreViewController = (transition == .presentation ? fromViewController : toViewController)?.children.last as? ExploreViewController,
              let workationViewController = (transition == .dismissal ? fromViewController : toViewController)?.children.last as? WorkationViewController,
              let navigationViewController = (transition == .dismissal ? fromViewController : toViewController) as? UINavigationController
        else {
            transitionContext.completeTransition(true)
            return
        }
        
        let region = exploreViewController.regionInfoView.selectedRegion.value
        let fakeBinder = Binder(region)
        
        let springTiming = UISpringTimingParameters(mass: 1, stiffness: 178, damping: 20, initialVelocity: .init(dx: 0, dy: 0))
        let animator = UIViewPropertyAnimator(duration: duration, timingParameters: springTiming)
        let opacityAnimator = UIViewPropertyAnimator(duration: duration, curve: .easeInOut)
        let fastOpacityAnimator = UIViewPropertyAnimator(duration: duration / 2, curve: .easeInOut)
        
        if transition == .presentation {
            let regionInfoViewCopy = makeRegionInfoViewCopy(selectedRegion: fakeBinder)
            regionInfoViewCopy.peopleCount = exploreViewController.regionInfoView.peopleCount
            regionInfoViewCopy.subviews.forEach { $0.isHidden = true }
            containerView.addSubview(regionInfoViewCopy)
            exploreViewController.regionInfoView.alpha = 0
            
            let heightConstraint = regionInfoViewCopy.heightAnchor.constraint(equalToConstant: exploreViewController.regionInfoViewHeight)
            let bottomConstraint = regionInfoViewCopy.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            
            NSLayoutConstraint.activate([
                regionInfoViewCopy.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                regionInfoViewCopy.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                heightConstraint,
                bottomConstraint
            ])
            
            let workationView = navigationViewController.view
            workationView?.alpha = 0
            if let workationView = workationView {
                containerView.addSubview(workationView)
            }
            workationViewController.topPaneView.backgroundColor = .clear
            
            containerView.layoutIfNeeded()
            
            animator.addAnimations {
                containerView.removeConstraint(heightConstraint)
                containerView.removeConstraint(bottomConstraint)
                
                NSLayoutConstraint.activate([
                    regionInfoViewCopy.topAnchor.constraint(equalTo: containerView.topAnchor),
                    regionInfoViewCopy.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -(320 + 4))
                ])
                containerView.layoutIfNeeded()
            }
            animator.addCompletion { _ in
                regionInfoViewCopy.removeFromSuperview()
                workationViewController.topPaneView.backgroundColor = .theme.background
                transitionContext.completeTransition(true)
            }
            opacityAnimator.addAnimations {
                exploreViewController.view.alpha = 0
                workationView?.alpha = 1
            }
            animator.startAnimation()
            opacityAnimator.startAnimation()
        } else { // transition == .dismissal
            let workationView = workationViewController.view
            let topPaneView = workationViewController.topPaneView
            topPaneView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            let regionInfoViewCopy = makeRegionInfoViewCopy(selectedRegion: fakeBinder)
            regionInfoViewCopy.titleLabel.text = regionInfoViewCopy.selectedRegion.value?.name
            regionInfoViewCopy.subTitleLabel.text = regionInfoViewCopy.selectedRegion.value?.romaName
            
            guard let workationView = workationView else {
                transitionContext.completeTransition(true)
                return
            }
            containerView.addSubview(workationView)
            topPaneView.subviews.forEach { $0.alpha = 0 }
            topPaneView.addSubview(regionInfoViewCopy)
            NSLayoutConstraint.activate([
                regionInfoViewCopy.leadingAnchor.constraint(equalTo: topPaneView.leadingAnchor),
                regionInfoViewCopy.trailingAnchor.constraint(equalTo: topPaneView.trailingAnchor),
                regionInfoViewCopy.topAnchor.constraint(equalTo: topPaneView.topAnchor),
                regionInfoViewCopy.bottomAnchor.constraint(equalTo: topPaneView.bottomAnchor)
            ])
            containerView.layoutIfNeeded()
            
            fastOpacityAnimator.addAnimations {
                workationView.subviews.forEach { $0.alpha = 0 }
                exploreViewController.view.alpha = 1
            }
            
            topPaneView.removeFromSuperview()
            containerView.addSubview(topPaneView)
            animator.addAnimations {
                NSLayoutConstraint.activate([
                    topPaneView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                    topPaneView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                    topPaneView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                    topPaneView.heightAnchor.constraint(equalToConstant: 140 + CGFloat.bottomSafeArea)
                ])
                containerView.layoutIfNeeded()
            }
        }
        
        animator.addCompletion { _ in
            exploreViewController.regionInfoView.alpha = 1
            transitionContext.completeTransition(true)
        }
        
        animator.startAnimation()
        fastOpacityAnimator.startAnimation()
    }
    
    private func makeRegionInfoViewCopy(selectedRegion: Binder<Region?>) -> RegionInfoView {
        let view = RegionInfoView(frame: .zero, peopleCount: 0, selectedRegion: selectedRegion) { }
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }
}

extension ExploreTransitionManager: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition = .presentation
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition = .dismissal
        return self
    }
}
