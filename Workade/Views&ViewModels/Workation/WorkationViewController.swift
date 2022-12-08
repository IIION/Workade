//
//  WorkationViewController.swift
//  Workade
//
//  Created by Wonhyuk Choi on 2022/11/17.
//

import FirebaseAuth
import Combine
import UIKit

final class WorkationViewController: UIViewController {
    private let workationViewModel = WorkationViewModel()
    
    private let bottomViewHeight: CGFloat = 320
    private var bottomViewHeightConstraints: NSLayoutConstraint?
    private var bottomViewBottomConstraints: NSLayoutConstraint?
    private lazy var panGesture = UIPanGestureRecognizer(target: self, action: #selector(onDrag))
    
    var cancellable = Set<AnyCancellable>()
    
    let canGetStickers: [StickerTitle] = [
        .halLaBong, .dolHaReuBang, .horse, .halLaSan
    ]
    
    private var titleView = TitleLabel(title: "")
    private var region: Region
    
    private lazy var closeButton = UIBarButtonItem(
        image: SFSymbol.xmarkInNavigation.image,
        primaryAction: UIAction(handler: { [weak self] _ in
            self?.dismiss(animated: true)
        })
    )

    private lazy var guideButton = UIBarButtonItem(
        image: UIImage.fromSystemImage(name: "text.book.closed.fill", font: .systemFont(ofSize: 15, weight: .bold), color: .theme.workadeBlue),
        primaryAction: UIAction(handler: { [weak self] _ in
            self?.navigationController?.pushViewController(GuideHomeViewController(), animated: true)
        })
    )
    
    init(region: Region, peopleCount: Int) {
        self.peopleCount = peopleCount
        self.region = region
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Top Pane's Contents
    
    let topPaneView: UIView = {
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
            guard let self = self else { return }
            let workStatusSheetViewController = WorkerStatusSheetViewController(peopleCount: self.peopleCount, region: self.region)
            workStatusSheetViewController.modalPresentationStyle = .overFullScreen
            
            let dimView = UIView(frame: UIScreen.main.bounds)
            dimView.backgroundColor = .theme.primary.withAlphaComponent(0.7)
            self.view.addSubview(dimView)
            self.view.bringSubviewToFront(dimView)
            workStatusSheetViewController.viewDidDissmiss = {
                dimView.removeFromSuperview()
            }
            
            self.present(workStatusSheetViewController, animated: true)
        }), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let numberOfWorkers: UILabel = {
        let label = UILabel()
        label.font = .customFont(for: .caption2)
        label.textColor = .theme.tertiary
        
        let fullText = "00명이 일하고 있어요"
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
    
    private lazy var loginPaneView: LoginView = {
        let login = LoginView(action: UIAction { [weak self] _ in
            guard let self = self else { return }
            let alert = UIAlertController(title: nil, message: "정말로 워케이션을 시작하시겠어요?", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "시작하기", style: .default, handler: { [weak self] _ in
                if Auth.auth().currentUser == nil {
                    let loginInitViewController = LoginInitViewController(region: self?.region)
                    let loginNavigation = UINavigationController(rootViewController: loginInitViewController)
                    loginNavigation.modalPresentationStyle = .overFullScreen
                    self?.present(loginNavigation, animated: true)
                } else {
                    Task { [weak self] in
                        guard let self = self,
                              let uid = Auth.auth().currentUser?.uid,
                              var user = try await FirestoreDAO.shared.getUser(userID: uid)
                        else { return }
                        try await FirestoreDAO.shared.createActiveUser(user: ActiveUser(id: user.id, job: user.job, region: self.region, startDate: .now))
                        try await FirestoreDAO.shared.updateUser(user: User(id: user.id, name: user.name, email: user.email, job: user.job, activeRegion: self.region))
                        try await UserManager.shared.reloadActiveUser(region: self.region)
                    }
                    
                    self?.loginPaneView.isHidden = true
                    self?.bottomPaneView.isHidden = false
                }
            }))
            alert.addAction(UIAlertAction(title: "취소", style: .cancel))
            
            self.present(alert, animated: true)
        }
        )
        login.translatesAutoresizingMaskIntoConstraints = false
        
        return login
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
            let alert = UIAlertController(title: nil, message: "정말로 워케이션을 종료하시겠어요?", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "종료", style: .destructive, handler: { [weak self] _ in
                Task { [weak self] in
                    guard let self = self, var user = UserManager.shared.user.value else { return }
                    try? await FirestoreDAO.shared.deleteActiveUser(userID: user.id, region: self.region)
                    try? await FirestoreDAO.shared.createUser(user: User(id: user.id, name: user.name, email: user.email, job: user.job, stickers: user.stickers, activeRegion: nil))
                }

                UIView.animate(withDuration: 0.3, delay: 0) { [weak self] in
                    self?.loginPaneView.isHidden = false
                    self?.bottomPaneView.isHidden = true
                }
            }))
            alert.addAction(UIAlertAction(title: "취소", style: .cancel))
            
            self?.present(alert, animated: true)
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
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        let offsetDate = Date().timeIntervalSince(UserManager.shared.activeMyInfo?.startDate ?? Date())
        let day = Int(ceil(offsetDate/86400))
        label.font = .customFont(for: .subHeadline)
        label.textColor = .theme.primary
        label.text = "\(day)일째"
        
        return label
    }()
    
    private lazy var periodStack: UIStackView = {
        let titleLabel = UILabel()
        titleLabel.font = .customFont(for: .footnote)
        titleLabel.textColor = .theme.tertiary
        titleLabel.text = "워케이션을 시작한 지"
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, dayLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        
        return stackView
    }()
    
    private let myLocationLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(for: .subHeadline)
        label.textColor = .theme.primary
        label.text = ""
        label.numberOfLines = 2
        
        return label
    }()
    
    private lazy var locationStack: UIStackView = {
        let titleLabel = UILabel()
        titleLabel.font = .customFont(for: .footnote)
        titleLabel.textColor = .theme.tertiary
        titleLabel.text = "내 위치"
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, myLocationLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        
        return stackView
    }()
    
    private lazy var bottomMiddleStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            periodStack,
            locationStack
        ])
        stackView.alignment = .top
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
        
        let progressView = StickerProgressView(stickers: canGetStickers)
        
        let stackView = UIStackView(arrangedSubviews: [label, progressView])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 16
        stackView.layoutMargins = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layer.borderColor = UIColor.theme.groupedBackground.cgColor
        stackView.layer.borderWidth = 1
        stackView.layer.cornerRadius = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let peopleCount: Int
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.addGestureRecognizer(panGesture)
        titleView.text = region.name
        numberOfWorkers.text = "\(peopleCount)명이 일하고 있어요"
        
        setupLayout()
        setupNavigationBar()
        setupProgressDay()
        bind()
    }
    
    //TODO: compareProgressDay()로 대체되었으나 dismiss 로직은 참고할 부분이 많아 ( 코드 정리 되고 테스트 해봐야 함. 남겨둠
//    private func showSticker() {
//        let stickerShetViewController = StickerSheetViewController()
//        stickerShetViewController.modalPresentationStyle = .overFullScreen
//
//        let dimView = UIView(frame: UIScreen.main.bounds)
//        dimView.backgroundColor = .theme.primary.withAlphaComponent(0.8)
//        view.addSubview(dimView)
//        view.bringSubviewToFront(dimView)
//        stickerShetViewController.viewDidDismiss = {
//            dimView.removeFromSuperview()
//        }
//
//        present( stickerShetViewController, animated: true)
//    }
}

private extension WorkationViewController {
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItems = [closeButton, guideButton]
        navigationItem.title = ""
    }
    
    private func setupLayout() {
        let guide = view.safeAreaLayoutGuide
        
        if UserManager.shared.isActive {
            bottomPaneView.isHidden = false
            loginPaneView.isHidden = true
        }
        
        view.addSubview(bottomPaneView)
        bottomViewHeightConstraints = bottomPaneView.heightAnchor.constraint(equalToConstant: 320)
        bottomViewBottomConstraints = bottomPaneView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        NSLayoutConstraint.activate([
            bottomViewHeightConstraints!,
            bottomViewBottomConstraints!,
            bottomPaneView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomPaneView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        view.addSubview(loginPaneView)
        NSLayoutConstraint.activate([
            loginPaneView.heightAnchor.constraint(equalTo: bottomPaneView.heightAnchor),
            loginPaneView.bottomAnchor.constraint(equalTo: bottomPaneView.bottomAnchor),
            loginPaneView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loginPaneView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
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
            bottomBottomStack.heightAnchor.constraint(equalToConstant: 140),
            bottomBottomStack.leadingAnchor.constraint(equalTo: bottomPaneView.leadingAnchor, constant: 20),
            bottomBottomStack.trailingAnchor.constraint(equalTo: bottomPaneView.trailingAnchor, constant: -20),
            bottomBottomStack.topAnchor.constraint(equalTo: bottomMiddleStack.bottomAnchor, constant: 30)
        ])
    }
    
    private func setupProgressDay() {
        guard var user = UserManager.shared.activeMyInfo else { return }
        let offsetDate = Date().timeIntervalSince(user.startDate)
        let day = Int(offsetDate/86400)
        
        if let storedDay = user.progressDay, storedDay != day {
            self.compareProgressDay(presentDay: day, storedDay: storedDay)
            user.progressDay = day
            self.updateActiveUser(user: user)
        }
        self.dayLabel.text = "\(day)일째"
    }
}

extension WorkationViewController {
    private func bind() {
        workationViewModel.$subLocality
            .combineLatest(workationViewModel.$throughfare)
            .sink { [weak self] value1, value2 in
                let subLocality = value1 ?? ""
                let throughfare = value2 ?? ""
                if value1 != value2 {
                    self?.myLocationLabel.text = "\(subLocality) \(throughfare)"
                } else {
                    self?.myLocationLabel.text = "\(subLocality)"
                }
            }
            .store(in: &cancellable)
        
        NotificationCenter.default.publisher(for: .NSCalendarDayChanged)
            .sink { [weak self] _ in
                guard let self = self,
                      var user = UserManager.shared.activeMyInfo
                else { return }
                DispatchQueue.main.async {
                    let offsetDate = Date().timeIntervalSince(user.startDate)
                    let day = Int(ceil(offsetDate/86400))
                    if let storedDay = user.progressDay, storedDay != day {
                        self.compareProgressDay(presentDay: day, storedDay: storedDay)
                        user.progressDay = day
                        self.updateActiveUser(user: user)
                    }
                    self.dayLabel.text = "\(day)일째"
                }
            }
            .store(in: &cancellable)
        
        UserManager.shared.$activeMyInfo
            .sink { [weak self] user in
                guard let self = self, var user = user else { return }
                DispatchQueue.main.async {
                    self.bottomPaneView.isHidden = false
                    self.loginPaneView.isHidden = true
                }
            }
            .store(in: &cancellable)
    }
    
    private func updateActiveUser(user: ActiveUser) {
        Task {
            try await FirestoreDAO.shared.createActiveUser(user: user)
        }
    }
    
    private func compareProgressDay(presentDay: Int, storedDay: Int) {
        let step = presentDay / 7
        let storedStep = storedDay / 7
        if storedStep < step {
            let getStickers = [StickerTitle](canGetStickers[storedStep..<step])
            let stickers = getStickers.map { StickerModel(date: Date(), title: $0, region: self.region) }
            let stickerShetViewController = StickerSheetViewController(stickers: stickers)
            self.present(stickerShetViewController, animated: true)
            let dimView = UIView(frame: UIScreen.main.bounds)
            dimView.backgroundColor = .theme.primary.withAlphaComponent(0.8)
            view.addSubview(dimView)
            view.bringSubviewToFront(dimView)
            stickerShetViewController.viewDidDismiss = {
                dimView.removeFromSuperview()
            }
        }
    }
}

private extension WorkationViewController {
    @objc
    func onDrag(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            let translation = sender.translation(in: view)
            update(using: translation.y)
        case .ended:
            restore()
        default:
            break
        }
    }
    
    func update(using translation: CGFloat) {
        bottomViewHeightConstraints?.constant = bottomViewHeight - min(translation, 0)
        bottomViewBottomConstraints?.constant = max(translation, 0)
        if translation > 50 {
            dismiss(animated: true)
        } else if translation < -30 {
            restore()
        }
    }
    
    func restore() {
        UIView.animate(withDuration: 0.4) { [weak self] in
            guard let self = self else { return }
            self.bottomViewHeightConstraints?.constant = self.bottomViewHeight
            self.bottomViewBottomConstraints?.constant = 0
            self.view.layoutIfNeeded()
        }
    }
}
