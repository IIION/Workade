//
//  CustomNavigationBar.swift
//  Workade
//
//  Created by Hong jeongmin on 2022/10/25.
//

import UIKit

class CustomNavigationBar: UIViewController {
    let detailViewModel = MagazineDetailViewModel()
        
    var dismissAction: (() -> Void)?
    // Binding
    private var titleText: String?
    private var rightButtonImage: UIImage?
    var magazine: Magazine?
    var office: Office?
    
    // 메모리누수1 : 델리게이트 weak로 선언
    weak var delegate: InnerTouchPresentDelegate?
    
    private let navigationBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(for: .title3)
        label.textColor = .theme.primary
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var closeButton: UIButton = {
        let config = UIImage.SymbolConfiguration(pointSize: 17, weight: .bold, scale: .default)
        
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark", withConfiguration: config), for: .normal)
        button.tintColor = .theme.primary
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(clickedCloseButton(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var rightButton: UIButton = {
        let button = UIButton()
        button.tintColor = .theme.primary
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(clickedRightButton(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var gradientView: GradientView = {
        let view = GradientView()
        view.gradientLayerColors = [UIColor.theme.background.withAlphaComponent(0.01), .theme.background]
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    init(titleText: String?, rightButtonImage: UIImage?) {
        super.init(nibName: nil, bundle: nil)
        self.titleText = titleText
        self.rightButtonImage = rightButtonImage
        
        setupLayout()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.titleText = nil
        self.rightButtonImage = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .theme.background
        self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: .topSafeArea + 60)
        self.rightButton.setImage(rightButtonImage, for: .normal)
        self.titleLabel.text = titleText?.components(separatedBy: ["\n"]).joined(separator: " ")
        
        setupLayout()
    }
    
    private func setupLayout() {
        
        view.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.widthAnchor.constraint(equalToConstant: 44),
            closeButton.heightAnchor.constraint(equalToConstant: 44),
            closeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8)
        ])
        
        view.addSubview(rightButton)
        NSLayoutConstraint.activate([
            rightButton.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -10),
            rightButton.widthAnchor.constraint(equalToConstant: 44),
            rightButton.heightAnchor.constraint(equalToConstant: 44),
            rightButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8)
        ])
        
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.heightAnchor.constraint(equalToConstant: 44),
            titleLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8),
            titleLabel.trailingAnchor.constraint(equalTo: rightButton.leadingAnchor)
            
        ])
        
        view.addSubview(gradientView)
        NSLayoutConstraint.activate([
            gradientView.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            gradientView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            gradientView.trailingAnchor.constraint(equalTo: rightButton.leadingAnchor, constant: 10)
        ])
    }
    
    @objc
    func clickedCloseButton(sender: UIButton) {
        dismissAction?()
        self.dismiss(animated: true)
    }
    
    @objc
    func clickedRightButton(sender: UIButton) {
        switch sender.currentImage {
        case SFSymbol.bookmarkInNavigation.image, SFSymbol.bookmarkFillInNavigation.image :
            detailViewModel.notifyClickedMagazineId(title: magazine?.title ?? "", key: Constants.wishMagazine)
            setupBookmarkImage()
            
        case SFSymbol.mapInNavigation.image:
            guard let safetyOffice = office else { return }
            delegate?.touch(office: safetyOffice)
            
        default:
            return
        }
    }
    
    private func setupBookmarkImage() {
        let userDefault = UserDefaultsManager.shared.loadUserDefaults(key: Constants.wishMagazine).contains(magazine?.title ?? "")
        rightButton.setImage(userDefault ? SFSymbol.bookmarkFillInNavigation.image : SFSymbol.bookmarkInNavigation.image, for: .normal)
    }
}
