//
//  CheckListNavigationCell.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/11/18.
//

import UIKit

class CheckListNavigationCell: UICollectionViewCell {
    private lazy var backgroundImageView: CellImageView = {
        let imageView = CellImageView(bounds: bounds)
        imageView.image = UIImage(named: "checkListCell")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let titleStackView: UIStackView = {
        let stackView = UIStackView()
        let label = UILabel()
        label.text = "checklist"
        label.textColor = .white
        label.font = .customFont(for: .captionHeadline)
        let imageView = UIImageView(image: SFSymbol.chevronRightBlue.image)
        imageView.contentMode = .center
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(imageView)
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubview(backgroundImageView)
        contentView.addSubview(titleStackView)
        
        NSLayoutConstraint.activate([
            backgroundImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            backgroundImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            backgroundImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            backgroundImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }
}
