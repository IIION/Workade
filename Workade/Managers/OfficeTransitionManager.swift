//
//  SheetTransitionManager.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/11/22.
//

import UIKit

/// **NearbyViewController가 띄어지는 상황에서 Transition애니메이션을 위임해서 맡아주는 매니저.**
///
/// Transition될 ViewController의 컴포넌트들을 객체로 캡슐화시킬수록 여기서의 구현코드가 좀 더 짧아집니다.
final class OfficeTransitionManager: NSObject {
    // 상태, 설정 관련 프로퍼티들
    private var transitionType: TransitionType = .presentation
    private var isPresent: Bool {
        return transitionType == .presentation
    }
    private let springTiming = UISpringTimingParameters(dampingRatio: 0.75)
    private var duration: Double {
        return isPresent ? 0.75 : 0.65
    }
    private var cellLabelHeight: CGFloat?
    
    /// ContainerView의 배경 블러뷰.
    private let blurEffectView: UIView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.reservations = [.init(.alpha, from: 0, to: 1, animated: true)]
        
        return blurEffectView
    }()
    
    /// NearbyVC의 상단 프로필 뷰를 복사하는 메서드.
    private func makePlaceView(origin view: NearbyPlaceImageView) -> NearbyPlaceImageView {
        let officeModel = view.officeModel
        let copyPlaceView = NearbyPlaceImageView(officeModel: officeModel)
        copyPlaceView.layer.masksToBounds = true
        cellTextLabel.text = copyPlaceView.placeLabel.text
        copyPlaceView.translatesAutoresizingMaskIntoConstraints = false
        copyPlaceView.reservations = [.init(.cornerRadius, from: 16, to: 0)]
        copyPlaceView.placeLabel.reservations = [.init(.alpha, from: 0, to: 1, animated: isPresent)]
        copyPlaceView.locationLabel.reservations = [.init(.alpha, from: 0, to: 1, animated: isPresent)]
        
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
        view.reservations = [.init(.cornerRadius, from: 16, to: 0)]
        
        return view
    }()
    
    /// dismiss시의 textLabel 전환 자연스럽게 하기위한 보여주기식 label.
    private let cellTextLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(for: .captionHeadline)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.reservations = [.init(.alpha, from: 1, to: 0, animated: false)]
        
        return label
    }()
}

// MARK: Animation 등록
extension OfficeTransitionManager: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // 1. containerView(==transitionView) 초기화 및 blur 배경 설정
        let containerView = transitionContext.containerView
        containerView.subviews.forEach { $0.removeFromSuperview() }
        blurEffectView.frame = containerView.frame
        
        // 2. viewController 탐색
        let fromViewController = transitionContext.viewController(forKey: .from)
        let toViewController = transitionContext.viewController(forKey: .to)
        
        // 3. 다운캐스팅 및 Cell프레임 옵셔널바인딩
        var collectionView: UICollectionView?
        if let guideHomeViewController = (isPresent ? fromViewController : toViewController)?.children.last as? GuideHomeViewController {
            collectionView = guideHomeViewController.guideCollectionView
        } else if let officeViewController = (isPresent ? fromViewController : toViewController)?.children.last as? OfficeViewController {
            collectionView = officeViewController.officeCollectionView
        }
        
        guard let nearybyPlaceViewController = (isPresent ? toViewController : fromViewController) as? NearbyPlaceViewController,
              let collectionView = collectionView,
              let indexPath = collectionView.indexPathsForSelectedItems?.first,
              let cell = collectionView.cellForItem(at: indexPath) as? OfficeCollectionViewCell else {
            transitionContext.completeTransition(true)
            return
        }
        
        let cellFrame = cell.backgroundImageView.convert(cell.backgroundImageView.frame, to: nil)
        cellLabelHeight = cell.officeNameLabel.intrinsicContentSize.height
        
        // 4. NearbyPlaceImageView의 copy본 생성.
        let copyPlaceView = makePlaceView(origin: nearybyPlaceViewController.nearbyPlaceImageView)
        
        // 5. containerView에 각종 컴포넌트 추가.
        [blurEffectView, whiteView, segmentControl, segmentUnderLine, copyPlaceView, cellTextLabel].forEach {
            containerView.addSubview($0)
        }
        
        // 6. 시작점 잡고 즉시 업데이트(해당위치에서 애니메이션 시작하도록.) -> 시작점 해제 -> 도착점 설정 -> 애니메이션 클로저 안에서 업데이트.
        setupLayoutConstraints(placeView: copyPlaceView, in: containerView, cellFrame: cellFrame)
        
        // 7. 애니메이션 설정
        let reservedViews = containerView.subviews + [copyPlaceView.placeLabel, copyPlaceView.locationLabel]
        
        let animator = UIViewPropertyAnimator(duration: duration, timingParameters: springTiming)
        
        animator.addAnimation(views: reservedViews, isForward: isPresent) {
            containerView.layoutIfNeeded() // 애니메이션 적용되면서 레이아웃 업데이트.
        }
        animator.addCompletion { [weak self] _ in
            guard let self = self else { return }
            cell.isHidden = self.isPresent
            containerView.subviews.forEach {
                $0.removeFromSuperview()
                NSLayoutConstraint.deactivate($0.constraints)
            }
            containerView.addSubview(nearybyPlaceViewController.view)
            transitionContext.completeTransition(true)
        }
        animator.startAnimation()
    }
}

// MARK: Present 상태 변경
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
    /// 애니메이션 동작할 컴포넌트의 AutoLayout을 설정하는 메서드.
    ///
    /// 일련의 순서를 분리해서 보여주는 게 가독성이 좋을 듯하여 이와 같이 구성.
    func setupLayoutConstraints(placeView: NearbyPlaceImageView, in containerView: UIView, cellFrame: CGRect) {
        let startingLayoutConstraints: [NSLayoutConstraint]?
        if isPresent {
            startingLayoutConstraints = activateDownstairs(placeView: placeView, in: containerView, cellFrame: cellFrame)
            containerView.layoutIfNeeded() // 시작점 레이아웃 즉시 업데이트.
            startingLayoutConstraints!.forEach { $0.isActive = false } // 시작점 잘 잡았으니 이제 false
            activateUpstairs(placeView: placeView, in: containerView, cellFrame: cellFrame) // 도착점 레이아웃 설정해놓기만.
        } else {
            startingLayoutConstraints = activateUpstairs(placeView: placeView, in: containerView, cellFrame: cellFrame)
            containerView.layoutIfNeeded()
            startingLayoutConstraints!.forEach { $0.isActive = false }
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
            cellTextLabel.heightAnchor.constraint(equalToConstant: cellLabelHeight ?? 30),
            
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
