//
//  ExploreViewController.swift
//  Workade
//
//  Created by 김예훈 on 2022/11/21.
//

import UIKit
import SwiftUI

class ExploreViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon")?.withRenderingMode(.alwaysOriginal), primaryAction: nil)
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: infoButton), UIBarButtonItem(customView: openChatButton)]
        setupLayout()
    }
    
    lazy var mainContainerView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .theme.sectionBackground
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = 30
        view.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var regionInfoView: RegionInfoView = {
        let view = RegionInfoView(frame: .zero)
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
        let image = UIImage(named: "map")
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
            mapImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0),
            mapImageView.bottomAnchor.constraint(equalTo: mainContainerView.bottomAnchor, constant: -20)
        ])
        
//        view.addSubview(guideButton)
//        NSLayoutConstraint.activate([
//            guideButton.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
//            guideButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
//        ])
        
        view.addSubview(regionInfoView)
        NSLayoutConstraint.activate([
            regionInfoView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            regionInfoView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            regionInfoView.heightAnchor.constraint(equalToConstant: 170),
            regionInfoView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
            regionInfoView.topAnchor.constraint(equalTo: mainContainerView.bottomAnchor, constant: 4)
        ])
    }
}

class RegionInfoView: UIView {
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "제주도"
        label.font = .customFont(for: .title3)
        label.textColor = .theme.primary
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var subTitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "제주특별자치도"
        label.font = .customFont(for: .caption)
        label.textColor = .theme.primary
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var desciptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "지금 29명의 사람들이\n워케이션 중이에요"
        label.textAlignment = .left
        label.font = .customFont(for: .captionHeadline)
        label.textColor = .theme.primary
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var workationButton: UIButton = {
        let button = UIButton(type: .custom)
        var config = UIButton.Configuration.plain()
        config.cornerStyle = .capsule
        config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 14, bottom: 12, trailing: 14)
        
        var background = UIButton.Configuration.plain().background
        background.backgroundColor = .theme.workadeBlue
        config.background = background
        
        var titleAttr = AttributedString.init("워케이션 하러 가기")
        titleAttr.font = .customFont(for: .caption2)
        titleAttr.foregroundColor = .theme.background
        
        config.attributedTitle = titleAttr
        config.image = UIImage.fromSystemImage(name: "text.book.closed.fill",
                                               font: .systemFont(ofSize: 13, weight: .bold),
                                               color: .theme.background)
        config.imagePadding = 4
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var dismissButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage.fromSystemImage(name: "xmark", font: .systemFont(ofSize: 15, weight: .bold))?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .theme.sectionBackground
        self.layer.cornerCurve = .continuous
        self.layer.cornerRadius = 30
        self.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        
        let labelStackView = UIStackView(arrangedSubviews: [titleLabel, subTitleLabel])
        labelStackView.spacing = 0
        labelStackView.axis = .vertical
        labelStackView.alignment = .leading
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(labelStackView)
        NSLayoutConstraint.activate([
            labelStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            labelStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20)
        ])
        
        self.addSubview(desciptionLabel)
        NSLayoutConstraint.activate([
            desciptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            desciptionLabel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
        
        self.addSubview(workationButton)
        NSLayoutConstraint.activate([
            workationButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            workationButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
        
        self.addSubview(dismissButton)
        NSLayoutConstraint.activate([
            dismissButton.widthAnchor.constraint(equalToConstant: 28),
            dismissButton.heightAnchor.constraint(equalToConstant: 28),
            dismissButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            dismissButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct Representable: UIViewRepresentable {
    func makeUIView(context: Context) -> RegionInfoView {
        let view = RegionInfoView(frame: .zero)
        return view
    }
    
    func updateUIView(_ uiView: RegionInfoView, context: Context) { }
}

struct RegionInfoViewPreview: PreviewProvider {
    static var previews: some View {
        Representable()
            .previewLayout(.fixed(width: 390, height: 150))
            .background(Color(uiColor: .theme.primary))
    }
}
