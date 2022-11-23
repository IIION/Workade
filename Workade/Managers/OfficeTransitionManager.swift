//
//  SheetTransitionManager.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/11/22.
//

import UIKit

final class OfficeTransitionManager: NSObject {
    private var transitionType: TransitionType = .presentation
    private var isPresent: Bool {
        return transitionType == .presentation
    }
    
    private let springTiming = UISpringTimingParameters(dampingRatio: 0.75)
    private var duration: Double {
        return isPresent ? 0.75 : 0.65
    }
    
    /// 컬렉션뷰의 Cell로부터 해당 Cell의 frame을 받음.
    var absoluteCellFrame: CGRect?
    
    /// 해당 Cell과 연결. 전환이 이뤄질 때, 실제로 해당 셀이 움직이는 것처럼 보이기위해 isHidden 조절.
    var cellHidden: ((Bool) -> Void)?
    
    /// ContainerView의 배경 블러뷰.
    private let blurEffectView: UIView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        
        return blurEffectView
    }()
    
    /// NearbyVC의 상단 프로필 뷰를 복사하는 메서드.
    private func makePlaceView(origin view: NearbyPlaceImageView) -> NearbyPlaceImageView {
        let officeModel = view.officeModel
        let copyPlaceView = NearbyPlaceImageView(officeModel: officeModel)
        copyPlaceView.layer.masksToBounds = true
        copyPlaceView.translatesAutoresizingMaskIntoConstraints = false
        
        return copyPlaceView
    }
    
    /// NearbyVC의 상단 프로필 뷰 하단의 세그먼트 컨트롤 모형.
    private let segmentControl: UISegmentedControl = {
        let segmentedControl = CustomSegmentedControl(items: ["정보", "특징", "갤러리", "주변"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        return segmentedControl
    }()
    
    /// NearbyVC 세그먼트 컨트롤 하단의 회색 구분선.
    private let segmentUnderLine: UIView = {
        let segmentUnderLine = UIView()
        segmentUnderLine.backgroundColor = .rgb(0xF2F2F7)
        segmentUnderLine.translatesAutoresizingMaskIntoConstraints = false
        
        return segmentUnderLine
    }()
    
    /// NearbyVC의 하단 introduceView가 나타날 배경뷰.
    private let whiteView: UIView = {
        let view = UIView()
        view.backgroundColor = .theme.background
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    /// textLabel 전환 자연스럽게 하기위한 보여주기식 label... 오우 귀찮다... 디테일...
    private let cellTextLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(for: .captionHeadline)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
}

extension OfficeTransitionManager: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        containerView.subviews.forEach { $0.removeFromSuperview() }
        containerView.addSubview(blurEffectView)
        blurEffectView.alpha = isPresent ? 0 : 1
        blurEffectView.frame = containerView.frame
        
        let fromVC = transitionContext.viewController(forKey: .from) // dismiss될 때의 nearbyVC
        let toVC = transitionContext.viewController(forKey: .to) // present될 때의 nearbyVC
        
        guard let nearbyVC = (transitionType == .presentation) ? (toVC as? NearbyPlaceViewController) : (fromVC as? NearbyPlaceViewController),
              let absoluteCellFrame = absoluteCellFrame else {
            transitionContext.completeTransition(true)
            return
        }
        
        let copyPlaceView = makePlaceView(origin: nearbyVC.nearbyPlaceImageView)
        copyPlaceView.layer.cornerRadius = isPresent ? 16 : 0
        copyPlaceView.placeLabel.alpha = isPresent ? 1 : 0
        copyPlaceView.locationLabel.alpha = isPresent ? 1 : 0
        cellTextLabel.alpha = isPresent ? 0 : 1
        cellTextLabel.text = copyPlaceView.placeLabel.text
        whiteView.layer.cornerRadius = isPresent ? 16 : 0
        
        [whiteView, segmentControl, segmentUnderLine, copyPlaceView, cellTextLabel].forEach {
            containerView.addSubview($0)
        }
        
        setupLayoutConstraints(placeView: copyPlaceView, in: containerView, cellFrame: absoluteCellFrame)
        
        let animator = UIViewPropertyAnimator(duration: duration, timingParameters: springTiming)
        animator.addAnimations { [weak self] in
            guard let self = self else { return }
            self.blurEffectView.alpha = self.isPresent ? 1 : 0
            self.whiteView.layer.cornerRadius = self.isPresent ? 0 : 16
            copyPlaceView.layer.cornerRadius = self.isPresent ? 0 : 16
            containerView.layoutIfNeeded() // 시작점 -> 도착점 애니메이션 적용되면서 업데이트.
        }
        animator.addCompletion { [weak self] _ in
            guard let self = self else { return }
            self.cellHidden?(self.isPresent)
            containerView.subviews.forEach {
                $0.removeFromSuperview()
                NSLayoutConstraint.deactivate($0.constraints)
            }
            containerView.addSubview(nearbyVC.view)
            transitionContext.completeTransition(true)
        }
        animator.startAnimation()
    }
}

extension OfficeTransitionManager: UIViewControllerTransitioningDelegate {
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
private extension OfficeTransitionManager {
    func setupLayoutConstraints(placeView: NearbyPlaceImageView, in containerView: UIView, cellFrame: CGRect) {
        let startingLayoutConstraints: [NSLayoutConstraint]?
        if isPresent {
            startingLayoutConstraints = activateDownstairs(placeView: placeView, in: containerView, cellFrame: cellFrame)
            containerView.layoutIfNeeded() // 시작점 레이아웃 즉시 업데이트.
            startingLayoutConstraints!.forEach { $0.isActive = false } // 시작점 잘 잡았으니 이제 false
            activateUpstairs(placeView: placeView, in: containerView, cellFrame: cellFrame)
            placeView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else {
            startingLayoutConstraints = activateUpstairs(placeView: placeView, in: containerView, cellFrame: cellFrame)
            containerView.layoutIfNeeded() // 시작점 레이아웃 즉시 업데이트.
            startingLayoutConstraints!.forEach { $0.isActive = false } // 시작점 잘 잡았으니 이제 false
            activateDownstairs(placeView: placeView, in: containerView, cellFrame: cellFrame)
        }
    }
    
    @discardableResult
    func activateDownstairs(placeView: NearbyPlaceImageView, in containerView: UIView, cellFrame: CGRect) -> [NSLayoutConstraint] {
        let downstairsConstraints = [
            placeView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: cellFrame.origin.y),
            placeView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: cellFrame.origin.x),
            placeView.widthAnchor.constraint(equalToConstant: cellFrame.width),
            placeView.heightAnchor.constraint(equalToConstant: cellFrame.height),
            
            cellTextLabel.leadingAnchor.constraint(equalTo: placeView.leadingAnchor, constant: 20),
            cellTextLabel.bottomAnchor.constraint(equalTo: placeView.bottomAnchor, constant: -20),
            cellTextLabel.trailingAnchor.constraint(equalTo: placeView.trailingAnchor, constant: -20),
            cellTextLabel.heightAnchor.constraint(equalToConstant: 20),
            
            segmentControl.topAnchor.constraint(equalTo: placeView.bottomAnchor, constant: -100),
            segmentControl.leadingAnchor.constraint(equalTo: placeView.leadingAnchor),
            segmentControl.trailingAnchor.constraint(equalTo: placeView.trailingAnchor),
            segmentControl.heightAnchor.constraint(equalToConstant: 50),
            
            segmentUnderLine.topAnchor.constraint(equalTo: segmentControl.bottomAnchor),
            segmentUnderLine.leadingAnchor.constraint(equalTo: segmentControl.leadingAnchor),
            segmentUnderLine.trailingAnchor.constraint(equalTo: segmentControl.trailingAnchor),
            segmentUnderLine.heightAnchor.constraint(equalToConstant: 2),
            
            whiteView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: cellFrame.origin.y),
            whiteView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: cellFrame.origin.x),
            whiteView.widthAnchor.constraint(equalToConstant: cellFrame.width),
            whiteView.heightAnchor.constraint(equalToConstant: cellFrame.height)
        ]
        NSLayoutConstraint.activate(downstairsConstraints)
        return downstairsConstraints
    }
    
    @discardableResult
    func activateUpstairs(placeView: NearbyPlaceImageView, in containerView: UIView, cellFrame: CGRect) -> [NSLayoutConstraint] {
        let upstairsConstraints = [
            placeView.topAnchor.constraint(equalTo: containerView.topAnchor),
            placeView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            placeView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            placeView.heightAnchor.constraint(equalToConstant: 375),
            
            cellTextLabel.leadingAnchor.constraint(equalTo: placeView.leadingAnchor, constant: 20),
            cellTextLabel.bottomAnchor.constraint(equalTo: placeView.bottomAnchor, constant: -30),
            cellTextLabel.trailingAnchor.constraint(equalTo: placeView.trailingAnchor, constant: -20),
            cellTextLabel.heightAnchor.constraint(equalToConstant: 20),
            
            segmentControl.topAnchor.constraint(equalTo: placeView.bottomAnchor),
            segmentControl.leadingAnchor.constraint(equalTo: placeView.leadingAnchor),
            segmentControl.trailingAnchor.constraint(equalTo: placeView.trailingAnchor),
            segmentControl.heightAnchor.constraint(equalToConstant: 50),
            
            segmentUnderLine.topAnchor.constraint(equalTo: segmentControl.bottomAnchor),
            segmentUnderLine.leadingAnchor.constraint(equalTo: segmentControl.leadingAnchor),
            segmentUnderLine.trailingAnchor.constraint(equalTo: segmentControl.trailingAnchor),
            segmentUnderLine.heightAnchor.constraint(equalToConstant: 2),
            
            whiteView.topAnchor.constraint(equalTo: containerView.topAnchor),
            whiteView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            whiteView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            whiteView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ]
        NSLayoutConstraint.activate(upstairsConstraints)
        return upstairsConstraints
    }
}
