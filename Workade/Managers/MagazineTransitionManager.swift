//
//  MagazineTransitionManager.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/11/23.
//

import UIKit

/// **CellItemDetailViewController가 띄어지는 상황에서 Transition애니메이션을 위임해서 맡아주는 매니저.**
final class MagazineTransitionManager: NSObject {
    var cellIndexPath: IndexPath?
    private var transitionType: TransitionType = .presentation
    private var isPresent: Bool {
        return transitionType == .presentation
    }
    private let springTiming = UISpringTimingParameters(dampingRatio: 0.75)
    private var duration: Double {
        return isPresent ? 0.75 : 0.65
    }
    private var cellLabelHeight: CGFloat?
    
    private let blurEffectView: UIView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.reservations = [.init(.alpha, from: 0, to: 1, animated: true)]
        
        return blurEffectView
    }()
    
    private func makeTitleImageView(origin view: MagazineTitleImageView) -> MagazineTitleImageView {
        let magazine = view.magazine
        let copyTitleImageView = MagazineTitleImageView(by: magazine)
        cellTextLabel.text = copyTitleImageView.magazine.title
        copyTitleImageView.backgroundColor = .theme.groupedBackground
        copyTitleImageView.reservations = [.init(.cornerRadius, from: 16, to: 0)]
        copyTitleImageView.titleLabel.reservations = [.init(.alpha, from: 0, to: 1, animated: isPresent)]
        copyTitleImageView.bookmarkButton.reservations = [.init(.alpha, from: 0, to: 1, animated: isPresent)]
        
        return copyTitleImageView
    }
    
    private let whiteView: UIView = {
        let view = UIView()
        view.backgroundColor = .theme.background
        view.translatesAutoresizingMaskIntoConstraints = false
        view.reservations = [.init(.cornerRadius, from: 16, to: 0)]
        
        return view
    }()
    
    private let bookmarkButton: UIButton = {
        let button = UIButton()
        button.setImage(SFSymbol.bookmark.image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.reservations = [.init(.alpha, from: 1, to: 0, animated: false)]
        
        return button
    }()

    private let cellTextLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(for: .caption2)
        label.textColor = .white
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        label.reservations = [.init(.alpha, from: 1, to: 0, animated: false)]
        
        return label
    }()
}

extension MagazineTransitionManager: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        containerView.subviews.forEach { $0.removeFromSuperview() }
        blurEffectView.frame = containerView.frame
        
        let fromVC = transitionContext.viewController(forKey: .from)
        let toVC = transitionContext.viewController(forKey: .to)
        
        var collectionView: UICollectionView?
        if let guideHomeVC = (isPresent ? fromVC : toVC)?.children.last as? GuideHomeViewController {
            collectionView = guideHomeVC.guideCollectionView
        } else if let magazineVC = (isPresent ? fromVC : toVC)?.children.last as? MagazineViewController {
            collectionView = magazineVC.magazineCollectionView
        }
        
        guard let cellItemDetailVC = (isPresent ? toVC : fromVC) as? CellItemDetailViewController,
              let collectionView = collectionView,
              let indexPath = cellIndexPath,
              let cell = collectionView.cellForItem(at: indexPath) as? MagazineCollectionViewCell else {
            transitionContext.completeTransition(true)
            return
        }
        
        let cellFrame = cell.backgroundImageView.convert(cell.backgroundImageView.frame, to: nil)
        cellLabelHeight = cell.titleLabel.intrinsicContentSize.height
        
        let copyTitleImageView = makeTitleImageView(origin: cellItemDetailVC.titleImageView)
        
        let magazine = copyTitleImageView.magazine
        let isWishMagazine = UserDefaultsManager.shared.loadUserDefaults(key: Constants.Key.wishMagazine).contains(magazine.title)
        bookmarkButton.setImage(isWishMagazine ? SFSymbol.bookmarkFill.image : SFSymbol.bookmark.image, for: .normal)
        
        [blurEffectView, whiteView, copyTitleImageView, cellTextLabel, bookmarkButton].forEach {
            containerView.addSubview($0)
        }
        
        setupLayoutConstraints(placeView: copyTitleImageView, in: containerView, cellFrame: cellFrame)
        
        let reservedViews = containerView.subviews + [copyTitleImageView.titleLabel, copyTitleImageView.bookmarkButton]
        
        let animator = UIViewPropertyAnimator(duration: duration, timingParameters: springTiming)
        
        animator.addAnimation(views: reservedViews, isForward: isPresent) {
            containerView.layoutIfNeeded()
        }
        
        cell.isHidden = true
        animator.addCompletion { [weak self] _ in
            guard let self = self else { return }
            cell.isHidden = self.isPresent
            containerView.subviews.forEach {
                $0.removeFromSuperview()
                NSLayoutConstraint.deactivate($0.constraints)
            }
            containerView.addSubview(cellItemDetailVC.view)
            transitionContext.completeTransition(true)
        }
        
        animator.startAnimation()
    }
}

extension MagazineTransitionManager: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transitionType = .presentation
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transitionType = .dismissal
        return self
    }
}

// MARK: Auto Layout
private extension MagazineTransitionManager {
    func setupLayoutConstraints(placeView: MagazineTitleImageView, in containerView: UIView, cellFrame: CGRect) {
        let startingLayoutConstraints: [NSLayoutConstraint]?
        if isPresent {
            startingLayoutConstraints = activateDownstairs(titleImageView: placeView, in: containerView, cellFrame: cellFrame)
            containerView.layoutIfNeeded()
            startingLayoutConstraints!.forEach { $0.isActive = false }
            activateUpstairs(titleImageView: placeView, in: containerView, cellFrame: cellFrame)
        } else {
            startingLayoutConstraints = activateUpstairs(titleImageView: placeView, in: containerView, cellFrame: cellFrame)
            containerView.layoutIfNeeded()
            startingLayoutConstraints!.forEach { $0.isActive = false }
            activateDownstairs(titleImageView: placeView, in: containerView, cellFrame: cellFrame)
        }
    }
    
    @discardableResult
    func activateDownstairs(titleImageView: MagazineTitleImageView, in containerView: UIView, cellFrame: CGRect) -> [NSLayoutConstraint] {
        let downstairsConstraints = [
            titleImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: cellFrame.origin.y),
            titleImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: cellFrame.origin.x),
            titleImageView.widthAnchor.constraint(equalToConstant: cellFrame.width),
            titleImageView.heightAnchor.constraint(equalToConstant: cellFrame.height),
            
            bookmarkButton.topAnchor.constraint(equalTo: titleImageView.topAnchor),
            bookmarkButton.trailingAnchor.constraint(equalTo: titleImageView.trailingAnchor),
            bookmarkButton.widthAnchor.constraint(equalToConstant: 44),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 44),
            
            cellTextLabel.leadingAnchor.constraint(equalTo: titleImageView.leadingAnchor, constant: 12),
            cellTextLabel.trailingAnchor.constraint(equalTo: titleImageView.trailingAnchor, constant: -12),
            cellTextLabel.bottomAnchor.constraint(equalTo: titleImageView.bottomAnchor, constant: -16),
            cellTextLabel.heightAnchor.constraint(equalToConstant: cellLabelHeight ?? 30),
            
            whiteView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: cellFrame.origin.y),
            whiteView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: cellFrame.origin.x),
            whiteView.widthAnchor.constraint(equalToConstant: cellFrame.width),
            whiteView.heightAnchor.constraint(equalToConstant: cellFrame.height)
        ]
        NSLayoutConstraint.activate(downstairsConstraints)
        return downstairsConstraints
    }
    
    @discardableResult
    func activateUpstairs(titleImageView: MagazineTitleImageView, in containerView: UIView, cellFrame: CGRect) -> [NSLayoutConstraint] {
        let upstairsConstraints = [
            titleImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            titleImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            titleImageView.heightAnchor.constraint(equalToConstant: .topSafeArea + 375),
            
            bookmarkButton.topAnchor.constraint(equalTo: titleImageView.topAnchor),
            bookmarkButton.trailingAnchor.constraint(equalTo: titleImageView.trailingAnchor),
            bookmarkButton.widthAnchor.constraint(equalToConstant: 44),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 44),
            
            cellTextLabel.leadingAnchor.constraint(equalTo: titleImageView.leadingAnchor, constant: 20),
            cellTextLabel.bottomAnchor.constraint(equalTo: titleImageView.bottomAnchor, constant: -30),
            cellTextLabel.trailingAnchor.constraint(equalTo: titleImageView.trailingAnchor, constant: -20),
            cellTextLabel.heightAnchor.constraint(equalToConstant: 20),
            
            whiteView.topAnchor.constraint(equalTo: containerView.topAnchor),
            whiteView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            whiteView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            whiteView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ]
        NSLayoutConstraint.activate(upstairsConstraints)
        return upstairsConstraints
    }
}
