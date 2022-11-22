//
//  RegionInfoView.swift
//  Workade
//
//  Created by 김예훈 on 2022/11/22.
//

import UIKit

class RegionInfoView: UIView {
    
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
    
    lazy var desciptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        let text = "지금 29명의 사람들이\n워케이션 중이에요"
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.foregroundColor, value: UIColor.theme.workadeBlue, range: (text as NSString).range(of: "29"))
        label.attributedText = attributedString
        label.textAlignment = .left
        label.font = .customFont(for: .captionHeadline)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var workationButton: UIButton = {
        let button = GradientButton(type: .custom)
        var config = UIButton.Configuration.plain()
        config.cornerStyle = .capsule
        config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 14, bottom: 12, trailing: 14)
        
        var titleAttr = AttributedString.init("워케이션 하러 가기")
        titleAttr.font = .customFont(for: .caption2)
        titleAttr.foregroundColor = .theme.background

        config.attributedTitle = titleAttr
        config.image = UIImage(named: "star")
        config.imagePadding = 4
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var dismissButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage.fromSystemImage(name: "xmark", font: .systemFont(ofSize: 15, weight: .bold))?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.selectedRegion.value = nil
        }), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    init(frame: CGRect, selectedRegion: Binder<Region?>) {
        self.selectedRegion = selectedRegion
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
            desciptionLabel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        self.addSubview(workationButton)
        NSLayoutConstraint.activate([
            workationButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            workationButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20)
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
