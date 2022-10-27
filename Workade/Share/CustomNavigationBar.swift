//
//  CustomNavigationBar.swift
//  Workade
//
//  Created by Hong jeongmin on 2022/10/25.
//

import UIKit

class CustomNavigationBar: UIViewController {
    let safaAreaTop = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 44
    
    var dismissAction: (() -> Void)?
    // Binding
    private var titleText: String?
    private var rightButtonImage: UIImage?
    
    private let navigationBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(for: .title3)
        label.textColor = .theme.primary
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
    
    private lazy var rightButton: UIButton = {
        let button = UIButton()
        button.tintColor = .theme.primary
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(clickedRightButton(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    init(titleText: String?, rightButtonImage: UIImage?) {
        super.init(nibName: nil, bundle: nil)
        self.titleText = titleText
        self.rightButtonImage = rightButtonImage
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .theme.background
        self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: safaAreaTop + 60)
        self.rightButton.setImage(rightButtonImage, for: .normal)
        self.titleLabel.text = titleText?.components(separatedBy: ["\n"]).joined(separator: " ")
        
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.heightAnchor.constraint(equalToConstant: 44),
            titleLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8)
        ])
        
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
    }
    
    @objc
    func clickedCloseButton(sender: UIButton) {
        dismissAction?()
        self.dismiss(animated: true)
    }
    
    @objc
    func clickedRightButton(sender: UIButton) {
        // TODO: 버튼 활성화
        
        print("rightButton Clicked")
    }
}
