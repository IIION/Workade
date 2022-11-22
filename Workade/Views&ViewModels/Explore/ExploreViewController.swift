//
//  ExploreViewController.swift
//  Workade
//
//  Created by 김예훈 on 2022/11/21.
//

import UIKit

class ExploreViewController: UIViewController {
    
    let viewModel = ExploreViewModel()
    var regionInfoViewBottomConstraint: NSLayoutConstraint?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon")?.withRenderingMode(.alwaysOriginal), primaryAction: nil)
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: infoButton), UIBarButtonItem(customView: openChatButton)]
        setupLayout()
        let springTiming = UISpringTimingParameters(dampingRatio: 0.85, initialVelocity: .init(dx: 0, dy: 2))
        let animator = UIViewPropertyAnimator(duration: 0.6, timingParameters: springTiming)
        viewModel.selectedRegion.bind { [weak self] region in
            if let region = region {
                self?.regionInfoViewBottomConstraint?.constant = 0
                self?.regionInfoView.titleLabel.text = region.name
                self?.regionInfoView.subTitleLabel.text = region.rawValue
                self?.mainContainerView.image = UIImage(named: region.imageName)
                self?.mapImageView.tintColor = .white
            } else {
                self?.regionInfoViewBottomConstraint?.constant = 180
                self?.mainContainerView.image = UIImage(named: "")
                self?.mapImageView.tintColor = .theme.workadeBlue
            }
            animator.addAnimations {
                self?.view.layoutIfNeeded()
            }
            animator.startAnimation()
        }
    }
    
    lazy var mainContainerView: UIImageView = {
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
        let view = RegionInfoView(frame: .zero, selectedRegion: viewModel.selectedRegion)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var openChatButton: UIButton = {
        let button = UIButton(type: .custom)
        var config = UIButton.Configuration.plain()
        config.cornerStyle = .capsule
        config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 14, bottom: 12, trailing: 14)
        
        var background = UIButton.Configuration.plain().background
        background.strokeWidth = 1
        background.strokeColor = .theme.groupedBackground
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
        
        return button
    }()
    
    lazy var infoButton: UIButton = {
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
            if self?.viewModel.selectedRegion.value == nil {
                self?.viewModel.selectedRegion.value = .busan
            } else {
                self?.viewModel.selectedRegion.value = nil
            }
        }), for: .touchUpInside)
        
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "이번엔 어디로\n떠나볼까요?"
        label.numberOfLines = 0
        label.font = .customFont(for: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var mapImageView: UIImageView = {
        let image = UIImage(named: "map")?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    lazy var guideButton: UIButton = {
        let button = UIButton(type: .custom)
        var config = UIButton.Configuration.plain()
        config.cornerStyle = .capsule
        config.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 24, bottom: 16, trailing: 24)
        
        var background = UIButton.Configuration.plain().background
        config.background = background
        
        var titleAttr = AttributedString.init("가이드 보러 가기")
        titleAttr.font = .customFont(for: .caption2)
        titleAttr.foregroundColor = .theme.tertiary
        
        config.attributedTitle = titleAttr
        config.image = UIImage.fromSystemImage(name: "text.book.closed.fill",
                                               font: .systemFont(ofSize: 13, weight: .bold),
                                               color: .theme.tertiary)
        config.imagePadding = 4
        button.configuration = config
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
        
        view.addSubview(mapImageView)
        NSLayoutConstraint.activate([
            mapImageView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            mapImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            mapImageView.bottomAnchor.constraint(equalTo: mainContainerView.bottomAnchor, constant: -20)
        ])
        
//        view.addSubview(guideButton)
//        NSLayoutConstraint.activate([
//            guideButton.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
//            guideButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
//        ])
        
        view.addSubview(regionInfoView)
        regionInfoViewBottomConstraint = regionInfoView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 180)
        NSLayoutConstraint.activate([
            regionInfoView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            regionInfoView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            regionInfoView.heightAnchor.constraint(equalToConstant: 140 + CGFloat.bottomSafeArea),
            regionInfoViewBottomConstraint!,
            regionInfoView.topAnchor.constraint(equalTo: mainContainerView.bottomAnchor, constant: 4)
        ])
    }
}
