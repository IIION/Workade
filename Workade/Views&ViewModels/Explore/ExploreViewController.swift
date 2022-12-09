//
//  ExploreViewController.swift
//  Workade
//
//  Created by 김예훈 on 2022/11/21.
//

import Combine
import FirebaseAuth
import SafariServices
import UIKit

final class ExploreViewController: UIViewController {
    private let viewModel = ExploreViewModel()
    private let transitionManager = ExploreTransitionManager()
    private var regionInfoViewBottomConstraint: NSLayoutConstraint?
    private var buttonConstraints: [RegionButton: [NSLayoutConstraint]] = [:]
    private let sectionPadding: CGFloat = 4
    private var anyCancellable = Set<AnyCancellable>()
    let regionInfoViewHeight: CGFloat = 140 + CGFloat.bottomSafeArea
    
    private let animator: UIViewPropertyAnimator = {
        let springTiming = UISpringTimingParameters(mass: 1, stiffness: 178, damping: 20, initialVelocity: .init(dx: 0, dy: 2))
        return UIViewPropertyAnimator(duration: 0.4, timingParameters: springTiming)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon")?.withRenderingMode(.alwaysOriginal), primaryAction: nil)
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: infoButton), UIBarButtonItem(customView: openChatButton)]
        setupLayout()
        
        for region in Region.allCases {
            regionButtons[region]?.peopleCount = UserManager.shared.activeUsers[region]?.count ?? 0
        }
        
        viewModel.selectedRegion.bind { [weak self] region in
            guard let self = self else { return }
            // 선택된 Region에 따라 RegionButton 업데이트
            for region in Region.allCases {
                self.animator.addAnimations {
                    self.regionButtons[region]?.changeLayout()
                }
                self.animator.startAnimation()
            }
            
            self.changeLayout(by: region)
            self.animator.addAnimations {
                self.view.layoutIfNeeded()
                self.setupButtonLayout()
            }
            self.animator.startAnimation()
        }
        
        UserManager.shared.$activeUsers.sink { [weak self] activeUsers in
            guard let self = self else { return }
            for region in Region.allCases {
                guard let users = activeUsers[region] else { continue }
                DispatchQueue.main.async {
                    self.regionButtons[region]?.peopleCount = users.count
                }
                if self.viewModel.selectedRegion.value == region {
                    self.regionInfoView.peopleCount = users.count
                }
            }
        }
        .store(in: &anyCancellable)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupButtonLayout()
    }
    
    private lazy var regionButtons: [Region: RegionButton] = {
        var regionButtons = [Region: RegionButton]()
        
        for region in Region.allCases {
            let newButton = RegionButton(region: region, selectedRegion: viewModel.selectedRegion, peopleCount: 0)
            newButton.translatesAutoresizingMaskIntoConstraints = false
            
            regionButtons[region] = newButton
        }
        
        return regionButtons
    }()
    
    private lazy var mainContainerView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.backgroundColor = .theme.sectionBackground
        view.contentMode = .scaleAspectFill
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = 30
        view.clipsToBounds = true
        view.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var regionInfoView: RegionInfoView = {
        let view = RegionInfoView(frame: .zero,
                                  peopleCount: 0,
                                  selectedRegion: viewModel.selectedRegion
        ) { [weak self] in
            guard let region = self?.viewModel.selectedRegion.value, let count = UserManager.shared.activeUsers[region]?.count else { return }
            let navigationController = UINavigationController(rootViewController: WorkationViewController(region: region, peopleCount: count))
            navigationController.transitioningDelegate = self?.transitionManager
            navigationController.modalPresentationStyle = .custom
            self?.present(navigationController, animated: true)
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var openChatButton: UIButton = {
        let button = UIButton(type: .custom)
        var config = UIButton.Configuration.plain()
        config.cornerStyle = .capsule
        config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 14, bottom: 12, trailing: 14)
        
        var background = UIButton.Configuration.plain().background
        let effect = UIBlurEffect(style: .systemMaterialLight)
        let effectView = UIVisualEffectView(effect: effect)
        background.customView = effectView
        config.background = background
        
        var titleAttr = AttributedString.init("오픈채팅")
        titleAttr.font = .customFont(for: .caption2)
        titleAttr.foregroundColor = .theme.workadeBlue
        config.attributedTitle = titleAttr
        
        config.image = UIImage.fromSystemImage(name: "message.fill",
                                               font: .systemFont(ofSize: 13, weight: .bold),
                                               color: .theme.workadeBlue)
        config.imagePadding = 4
        button.configuration = config
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let blogUrl = URL(string: "https://open.kakao.com/o/gFC1wiEe") else { return }
            let blogSafariView: SFSafariViewController = SFSafariViewController(url: blogUrl)
            self?.present(blogSafariView, animated: true, completion: nil)
        }), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var infoButton: UIButton = {
        let button = UIButton(type: .custom)
        var config = UIButton.Configuration.plain()
        config.cornerStyle = .capsule
        config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 14, bottom: 12, trailing: 14)
        
        var background = UIButton.Configuration.plain().background
        background.backgroundColor = .theme.groupedBackground
        config.background = background
        
        var titleAttr = AttributedString.init("내 정보")
        titleAttr.font = .customFont(for: .caption2)
        titleAttr.foregroundColor = .theme.tertiary
        
        config.attributedTitle = titleAttr
        config.image = UIImage.fromSystemImage(name: "person.fill",
                                               font: .systemFont(ofSize: 13, weight: .bold),
                                               color: .theme.tertiary)
        config.imagePadding = 4
        button.configuration = config
        button.addAction(UIAction(handler: { [weak self] _ in
            if Auth.auth().currentUser != nil {
                self?.navigationController?.pushViewController(MyPageViewController(), animated: true)
            } else {
                let loginViewController = LoginInitViewController(region: nil)
                let loginNavigation = UINavigationController(rootViewController: loginViewController)
                loginNavigation.modalPresentationStyle = .overFullScreen
                self?.present(loginNavigation, animated: true)
            }
        }), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "이번엔 어디로\n떠나볼까요?"
        label.numberOfLines = 0
        label.font = .customFont(for: .title3)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var mapImageView: UIImageView = {
        let image = UIImage(named: "map")?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var guideButton: UIButton = {
        let button = GradientButton(type: .custom)
        button.layerCornerRadius = 24
        var config = UIButton.Configuration.plain()
        config.cornerStyle = .capsule
        config.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 24, bottom: 16, trailing: 24)
        
        var titleAttr = AttributedString.init("가이드 보러 가기")
        titleAttr.font = .customFont(for: .caption2)
        titleAttr.foregroundColor = .theme.background
        
        config.attributedTitle = titleAttr
        config.image = UIImage.fromSystemImage(name: "text.book.closed.fill",
                                               font: .systemFont(ofSize: 13, weight: .bold),
                                               color: .theme.background)
        config.imagePadding = 4
        button.configuration = config
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.navigationController?.pushViewController(GuideHomeViewController(), animated: true)
        }), for: .touchUpInside)
        button.setContentHuggingPriority(.defaultHigh, for: .vertical)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private func setupLayout() {
        view.addSubview(mainContainerView)
        NSLayoutConstraint.activate([
            mainContainerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            mainContainerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            mainContainerView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0)
        ])
        
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20)
        ])
        
        view.addSubview(guideButton)
        NSLayoutConstraint.activate([
            guideButton.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            guideButton.bottomAnchor.constraint(equalTo: mainContainerView.bottomAnchor, constant: -30)
        ])
        
        view.addSubview(mapImageView)
        NSLayoutConstraint.activate([
            mapImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            mapImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            mapImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 30),
            mapImageView.bottomAnchor.constraint(equalTo: guideButton.topAnchor, constant: -10)
        ])
        
        view.addSubview(regionInfoView)
        regionInfoViewBottomConstraint = regionInfoView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: regionInfoViewHeight + sectionPadding)
        NSLayoutConstraint.activate([
            regionInfoView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            regionInfoView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            regionInfoView.heightAnchor.constraint(equalToConstant: regionInfoViewHeight),
            regionInfoViewBottomConstraint!,
            regionInfoView.topAnchor.constraint(equalTo: mainContainerView.bottomAnchor, constant: sectionPadding)
        ])
        for region in Region.allCases {
            guard let button = regionButtons[region] else { continue }
            view.addSubview(button)
        }
    }
    
    private func setupButtonLayout() {
        for region in Region.allCases {
            guard let regionButton = regionButtons[region] else { continue }
            buttonConstraints[regionButton]?.forEach({ constraint in
                self.view.removeConstraint(constraint)
            })
            let constantX = regionButton.region.relativePos.x * mapImageView.frame.width / 100
            let constantY = regionButton.region.relativePos.y * mapImageView.frame.height / 100
            let constraintX = regionButton.leadingAnchor.constraint(equalTo: mapImageView.leadingAnchor, constant: constantX)
            let constraintY = regionButton.centerYAnchor.constraint(equalTo: mapImageView.centerYAnchor, constant: -constantY)
            NSLayoutConstraint.activate([constraintX, constraintY])
            buttonConstraints[regionButton] = [constraintX, constraintY]
        }
    }
    
    private func changeLayout(by region: Region?) {
        let isRegionNil = region == nil
        
        regionInfoViewBottomConstraint?.constant = isRegionNil ? regionInfoViewHeight + sectionPadding : 0
        titleLabel.alpha = isRegionNil ? 1 : 0
        regionInfoView.titleLabel.text = region?.name ?? ""
        regionInfoView.subTitleLabel.text = region?.romaName ?? ""
        regionInfoView.warningView.isHidden = (region?.isCanWorkation ?? true) == true
        mapImageView.tintColor = isRegionNil ? .theme.workadeBlue : .white
        
        if let region = region {
            regionInfoView.peopleCount = UserManager.shared.activeUsers[region]?.count ?? -1
            UIView.transition(with: mainContainerView,
                              duration: 0.25,
                              options: .transitionCrossDissolve,
                              animations: { [weak self] in
                self?.mainContainerView.image = UIImage(named: region.imageName)
            }, completion: nil)
        } else {
            self.mainContainerView.image = UIImage(named: "")
        }
        
        setupDismissButtonColor()
    }
    
    private func setupDismissButtonColor() {
        var image: UIImage? = UIImage()
        
        if regionInfoView.warningView.isHidden {
            image = UIImage.fromSystemImage(name: "xmark", font: .systemFont(ofSize: 15, weight: .bold), color: .theme.primary)?.withRenderingMode(.alwaysOriginal)
        } else {
            image = UIImage.fromSystemImage(name: "xmark", font: .systemFont(ofSize: 15, weight: .bold), color: .theme.background)?.withRenderingMode(.alwaysOriginal)
        }
        regionInfoView.dismissButton.setImage(image, for: .normal)
    }
}
