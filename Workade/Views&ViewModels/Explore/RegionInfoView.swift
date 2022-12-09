//
//  RegionInfoView.swift
//  Workade
//
//  Created by 김예훈 on 2022/11/22.
//

import UIKit

final class RegionInfoView: UIView {
    var peopleCount: Int {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                let text = "지금 \(self.peopleCount)명의 사람들이\n워케이션 중이에요"
                let attributedString = NSMutableAttributedString(string: text)
                attributedString.addAttribute(.foregroundColor, value: UIColor.theme.workadeBlue, range: (text as NSString).range(of: "\(self.peopleCount)"))
                self.desciptionLabel.attributedText = attributedString
            }
        }
    }
    let selectedRegion: Binder<Region?>
    
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
    
    private lazy var desciptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        let text = "지금 \(peopleCount)명의 사람들이\n워케이션 중이에요"
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.foregroundColor, value: UIColor.theme.workadeBlue, range: (text as NSString).range(of: "\(peopleCount)"))
        label.attributedText = attributedString
        label.textAlignment = .left
        label.font = .customFont(for: .captionHeadline)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var workationButton: UIButton = {
        let button = GradientButton(type: .custom)
        var config = UIButton.Configuration.plain()
        config.cornerStyle = .capsule
        config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 14, bottom: 12, trailing: 14)
        
        var titleAttr = AttributedString.init("워케이션 하러 가기")
        titleAttr.font = .customFont(for: .caption2)
        titleAttr.foregroundColor = .theme.background

        config.attributedTitle = titleAttr
        config.image = UIImage(named: "Star")
        config.imagePadding = 4
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var dismissButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.selectedRegion.value = nil
        }), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var warningView: UIView = {
        let warningIcon = UIImage.fromSystemImage(name: "exclamationmark.triangle.fill", font: .systemFont(ofSize: 24), color: .white)
        let warningImageView = UIImageView(image: warningIcon)
        warningImageView.contentMode = .scaleAspectFit
        let warningLabel = UILabel(frame: .zero)
        warningLabel.text = "아직 준비중인 지역이에요!"
        warningLabel.font = .customFont(for: .captionHeadline)
        warningLabel.textColor = .white
        
        let stackView = UIStackView(arrangedSubviews: [warningImageView, warningLabel])
        stackView.spacing = 12
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterialDark))
        blurView.translatesAutoresizingMaskIntoConstraints = false
        
        let warningView = UIView(frame: .zero)
        
        warningView.addSubview(blurView)
        NSLayoutConstraint.activate([
            blurView.leadingAnchor.constraint(equalTo: warningView.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: warningView.trailingAnchor),
            blurView.topAnchor.constraint(equalTo: warningView.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: warningView.bottomAnchor)
        ])
        
        warningView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: warningView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: warningView.centerYAnchor)
        ])
        
        warningView.translatesAutoresizingMaskIntoConstraints = false
        
        return warningView
    }()
    
    init(frame: CGRect, peopleCount: Int, selectedRegion: Binder<Region?>, completion: @escaping () -> Void) {
        self.selectedRegion = selectedRegion
        self.peopleCount = peopleCount
        super.init(frame: frame)
        
        self.backgroundColor = .theme.sectionBackground
        self.layer.cornerCurve = .continuous
        self.layer.cornerRadius = 30
        self.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        self.clipsToBounds = true
        
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
            desciptionLabel.topAnchor.constraint(equalTo: self.subTitleLabel.bottomAnchor, constant: 20)
        ])
        
        self.addSubview(workationButton)
        NSLayoutConstraint.activate([
            workationButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            workationButton.topAnchor.constraint(equalTo: self.subTitleLabel.bottomAnchor, constant: 23.5)
        ])
        workationButton.addAction(UIAction { _ in
            completion()
        }, for: .touchUpInside)
        
        self.addSubview(warningView)
        warningView.isHidden = true
        NSLayoutConstraint.activate([
            warningView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            warningView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            warningView.topAnchor.constraint(equalTo: self.topAnchor),
            warningView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
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
