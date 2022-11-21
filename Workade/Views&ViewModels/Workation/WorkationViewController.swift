//
//  WorkationViewController.swift
//  Workade
//
//  Created by Wonhyuk Choi on 2022/11/17.
//

import UIKit

final class WorkationViewController: UIViewController {
    private let workationViewModel = WorkationViewModel()
    
    var dismissAction: (() -> Void)?
    
    private let titleView = TitleLabel(title: "제주도")
    
    private lazy var closeButton = UIBarButtonItem(
        image: SFSymbol.xmarkInNavigation.image,
        primaryAction: UIAction(handler: { [weak self] _ in
            self?.dismissAction?()
            self?.dismiss(animated: true)
        })
    )
    
    private lazy var guideButton = UIBarButtonItem(
        image: UIImage.fromSystemImage(name: "text.book.closed.fill", font: .systemFont(ofSize: 15, weight: .bold), color: .theme.workadeBlue),
        primaryAction: UIAction(handler: { _ in
        })
    )
    
    // MARK: - Top Pane's Contents
    
    private let topPaneView: UIView = {
        let view = UIView()
        view.backgroundColor = .theme.background
        view.layer.cornerRadius = 30
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let mapImageView: UIImageView = {
        let image = UIImage(named: "Namwon")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var whoAreTheyButton: UIButton = {
        let button = GradientButton(type: .custom)
        var config = UIButton.Configuration.plain()
        config.imagePadding = 4
        config.cornerStyle = .capsule
        config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 18, bottom: 12, trailing: 18)
        
        var attributedText = AttributedString.init("누군지 알아보기")
        attributedText.font = .customFont(for: .footnote2)
        config.attributedTitle = attributedText
        config.image = UIImage.fromSystemImage(name: "person.fill", font: .systemFont(ofSize: 15, weight: .bold), color: .theme.background)
                
        button.configuration = config
        button.tintColor = .theme.background
        button.backgroundColor = .theme.workadeBlue
        button.layer.cornerRadius = 20
        button.addAction(UIAction(handler: { [weak self] _ in
            let workStatusSheetViewController = WorkerStatusSheetViewController()
            workStatusSheetViewController.modalPresentationStyle = .overFullScreen
            
            let dimView = UIView(frame: UIScreen.main.bounds)
            dimView.backgroundColor = .theme.primary.withAlphaComponent(0.7)
            self?.view.addSubview(dimView)
            self?.view.bringSubviewToFront(dimView)
            workStatusSheetViewController.viewDidDissmiss = {
                dimView.removeFromSuperview()
            }
            
            self?.present(workStatusSheetViewController, animated: true)
        }), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let numberOfWorkers: UILabel = {
        let label = UILabel()
        label.font = .customFont(for: .caption2)
        label.textColor = .theme.tertiary
        
        let fullText = "53명이 일하고 있어요"
        let attributedString = NSMutableAttributedString(string: fullText)
        let range = (fullText as NSString).range(of: "53")
        attributedString.addAttribute(.foregroundColor, value: UIColor.theme.workadeBlue, range: range)
        label.attributedText = attributedString
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // MARK: - Bottom Pane's Contents
    
    private let bottomPaneView: UIView = {
        let view = UIView()
        view.backgroundColor = .theme.background
        view.layer.cornerRadius = 30
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let funnyWorkationLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(for: .captionHeadlineNew)
        label.textColor = .theme.primary
        label.text = "즐거운 워케이션이네요!"
        
        return label
    }()
    
    private lazy var endButton: UIButton = {
        let button = UIButton(type: .custom)
        var config = UIButton.Configuration.plain()
        config.imagePadding = 4
        config.cornerStyle = .capsule
        config.contentInsets = NSDirectionalEdgeInsets.init(top: 8, leading: 16, bottom: 8, trailing: 16)
        
        var attributedText = AttributedString.init("끝내기")
        attributedText.font = .customFont(for: .caption)
        config.attributedTitle = attributedText
        config.image = UIImage.fromSystemImage(name: "door.right.hand.open", font: .systemFont(ofSize: 12, weight: .semibold), color: .theme.background)
                
        button.configuration = config
        button.tintColor = .theme.background
        button.backgroundColor = .theme.primary
        button.layer.cornerRadius = 15
        button.addAction(UIAction(handler: { [weak self] _ in
            let stickerShetViewController = StickerSheetViewController()
            stickerShetViewController.modalPresentationStyle = .overFullScreen
            
            let dimView = UIView(frame: UIScreen.main.bounds)
            dimView.backgroundColor = .theme.primary.withAlphaComponent(0.8)
            self?.view.addSubview(dimView)
            self?.view.bringSubviewToFront(dimView)
            stickerShetViewController.viewDidDismiss = {
                dimView.removeFromSuperview()
            }
            
            self?.present( stickerShetViewController, animated: true)
        }), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var bottomTopStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [funnyWorkationLabel, endButton])
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private func reusableStack(title: String, content: String) -> UIStackView {
        let titleLabel = UILabel()
        titleLabel.font = .customFont(for: .footnote)
        titleLabel.textColor = .theme.tertiary
        titleLabel.text = title
        
        let contentLabel = UILabel()
        contentLabel.font = .customFont(for: .subHeadline)
        contentLabel.textColor = .theme.primary
        contentLabel.text = content
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, contentLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        
        return stackView
    }
    
    private lazy var bottomMiddleStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            reusableStack(title: "워케이션을 시작한 지", content: "33일째"),
            reusableStack(title: "내 위치", content: "조천읍 조천2길")
        ])
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var bottomBottomStack: UIStackView = {
        let label = UILabel()
        label.font = .customFont(for: .subHeadline)
        label.textColor = .theme.primary
        label.text = "스티커"
        
        let progressView = UIProgressView()
        progressView.progress = 30/31
        progressView.backgroundColor = .theme.groupedBackground
        progressView.tintColor = .theme.workadeBlue
        
        let stackView = UIStackView(arrangedSubviews: [label, progressView])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .equalCentering
        stackView.layoutMargins = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layer.borderColor = UIColor.theme.groupedBackground.cgColor
        stackView.layer.borderWidth = 1
        stackView.layer.cornerRadius = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .theme.primary
        
        setupLayout()
        setupNavigationBar()
    }
}

private extension WorkationViewController {
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItems = [closeButton, guideButton]
    }
    
    private func setupLayout() {
        let guide = view.safeAreaLayoutGuide
        
        view.addSubview(bottomPaneView)
        NSLayoutConstraint.activate([
            bottomPaneView.heightAnchor.constraint(equalToConstant: 300),
            bottomPaneView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomPaneView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomPaneView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.addSubview(topPaneView)
        NSLayoutConstraint.activate([
            topPaneView.topAnchor.constraint(equalTo: view.topAnchor),
            topPaneView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topPaneView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topPaneView.bottomAnchor.constraint(equalTo: bottomPaneView.topAnchor, constant: -4)
        ])
        
        topPaneView.addSubview(titleView)
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 20),
            titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        topPaneView.addSubview(whoAreTheyButton)
        NSLayoutConstraint.activate([
            whoAreTheyButton.centerXAnchor.constraint(equalTo: topPaneView.centerXAnchor),
            whoAreTheyButton.bottomAnchor.constraint(equalTo: topPaneView.bottomAnchor, constant: -16),
            whoAreTheyButton.heightAnchor.constraint(equalToConstant: 42)
        ])
        
        topPaneView.addSubview(numberOfWorkers)
        NSLayoutConstraint.activate([
            numberOfWorkers.centerXAnchor.constraint(equalTo: topPaneView.centerXAnchor),
            numberOfWorkers.bottomAnchor.constraint(equalTo: whoAreTheyButton.topAnchor, constant: -10)
        ])
        
        topPaneView.addSubview(mapImageView)
        NSLayoutConstraint.activate([
            mapImageView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 60),
            mapImageView.leadingAnchor.constraint(equalTo: topPaneView.leadingAnchor, constant: 20),
            mapImageView.trailingAnchor.constraint(equalTo: topPaneView.trailingAnchor, constant: -20),
            mapImageView.bottomAnchor.constraint(equalTo: numberOfWorkers.topAnchor, constant: -16)
        ])
        
        bottomPaneView.addSubview(bottomTopStack)
        NSLayoutConstraint.activate([
            bottomTopStack.topAnchor.constraint(equalTo: bottomPaneView.topAnchor, constant: 20),
            bottomTopStack.leadingAnchor.constraint(equalTo: bottomPaneView.leadingAnchor, constant: 30),
            bottomTopStack.trailingAnchor.constraint(equalTo: bottomPaneView.trailingAnchor, constant: -20)
        ])
        
        bottomPaneView.addSubview(bottomMiddleStack)
        NSLayoutConstraint.activate([
            bottomMiddleStack.topAnchor.constraint(equalTo: bottomTopStack.bottomAnchor, constant: 18),
            bottomMiddleStack.leadingAnchor.constraint(equalTo: bottomPaneView.leadingAnchor, constant: 30),
            bottomMiddleStack.trailingAnchor.constraint(equalTo: bottomPaneView.trailingAnchor, constant: -30)
        ])
        
        bottomPaneView.addSubview(bottomBottomStack)
        NSLayoutConstraint.activate([
            bottomBottomStack.heightAnchor.constraint(equalToConstant: 138),
            bottomBottomStack.leadingAnchor.constraint(equalTo: bottomPaneView.leadingAnchor, constant: 20),
            bottomBottomStack.trailingAnchor.constraint(equalTo: bottomPaneView.trailingAnchor, constant: -20),
            bottomBottomStack.bottomAnchor.constraint(equalTo: bottomPaneView.bottomAnchor, constant: -34)
        ])
    }
}
