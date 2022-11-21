//
//  ExploreViewController.swift
//  Workade
//
//  Created by 김예훈 on 2022/11/21.
//

import UIKit

class ExploreViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon")?.withRenderingMode(.alwaysOriginal), primaryAction: nil)
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: infoButton), UIBarButtonItem(customView: openChatButton)]
        setupLayout()
    }
    
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
    
    private func setupLayout() {
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
        ])
    }
}
