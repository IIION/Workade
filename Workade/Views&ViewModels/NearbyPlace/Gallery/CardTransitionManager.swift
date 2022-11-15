//
//  CardTransitionManager.swift
//  Workade
//
//  Created by 김예훈 on 2022/10/21.
//

import UIKit

enum CardTransitionType {
    case presentation
    case dismissal
}

class CardTransitionMananger: NSObject {
    let transitionDuration: Double = 0.4
    var transition: CardTransitionType = .presentation
    
    lazy var dimmingView: UIView = {
        let dimmingView = UIView(frame: .zero)
        dimmingView.backgroundColor = .black
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        
        return dimmingView
    }()
    
    private func addDimmingView(to containerView: UIView) {
        dimmingView.frame = containerView.frame
        dimmingView.alpha = 0.0
        containerView.addSubview(dimmingView)
    }
}

extension CardTransitionMananger: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        containerView.subviews.forEach({ $0.removeFromSuperview() })
        addDimmingView(to: containerView)
        
        let fromViewController = transitionContext.viewController(forKey: .from)
        let toViewController = transitionContext.viewController(forKey: .to)

        guard let galleryDetailViewController = (transition == .dismissal) ? (fromViewController as? GalleryDetailViewController) : (toViewController as? GalleryDetailViewController),
              
              let nearbyPlaceViewController = (transition == .presentation) ? (fromViewController as? NearbyPlaceViewController) : (toViewController as? NearbyPlaceViewController),
              
              let indexPath = nearbyPlaceViewController.nearbyPlaceView.galleryView.collectionView.indexPathsForSelectedItems?.first,
              
              let item = nearbyPlaceViewController.nearbyPlaceView.galleryView.collectionView.cellForItem(at: indexPath) as? GalleryCollectionViewCell
                
        else {
            transitionContext.completeTransition(true)
            return
        }
        
        let imageViewCopy = makeimageView(by: item.imageView.image ?? UIImage())
        containerView.addSubview(imageViewCopy)
        
        let springTiming = UISpringTimingParameters(dampingRatio: 0.85, initialVelocity: .init(dx: 0, dy: 2))
        let animator = UIViewPropertyAnimator(duration: transitionDuration, timingParameters: springTiming)
        
        if transition == .presentation {
            imageViewCopy.translatesAutoresizingMaskIntoConstraints = false
            makeCellSize(for: imageViewCopy, item: item)
            animator.addAnimations {
                self.dimmingView.alpha = 0.8
                imageViewCopy.layer.cornerRadius = 0
                self.makeDetailSize(for: imageViewCopy, to: containerView)
                containerView.layoutIfNeeded()
            }
            animator.addCompletion { _ in
                containerView.addSubview(galleryDetailViewController.view)
                imageViewCopy.isHidden = true
                transitionContext.completeTransition(true)
            }
            animator.startAnimation()
        } else { // transition == .dismissal
            imageViewCopy.isHidden = true
            item.isHidden = false
            self.dimmingView.alpha = 0.8
            animator.addAnimations {
                self.dimmingView.alpha = 0
            }
            animator.addCompletion { _ in
                transitionContext.completeTransition(true)
            }
            animator.startAnimation()
        }
    }
    
    private func makeimageView(by image: UIImage) -> UIImageView {
        let copy = UIImageView(image: image)
        copy.contentMode = .scaleAspectFill
        copy.clipsToBounds = true
        copy.layer.cornerRadius = 12
        
        return copy
    }
    
    private func makeDetailSize(for imageView: UIImageView, to containerView: UIView) {
        let aspectR = (imageView.image?.size.width ?? 0) / (imageView.image?.size.height ?? 0)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            imageView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1/aspectR),
            imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
    
    private func makeCellSize(for imageView: UIImageView, item: GalleryCollectionViewCell) {
        let absoluteFrame = item.imageView.convert(item.imageView.frame, to: nil)
        imageView.frame = absoluteFrame
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
