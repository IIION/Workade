//
//  MegazineCollectionViewCell.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/10/22.
//

import UIKit

/// 매거진을 나열한 컬렉션뷰의 셀
class MagazineCollectionViewCell: UICollectionViewCell {
    var magazineId: Int?
    
    private lazy var backgroundImageView: CellImageView = {
        let imageView = CellImageView(bounds: bounds)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var bookmarkButton: UIButton = {
        let button = UIButton()
        button.setImage(SFSymbol.bookmark.image, for: .normal)
        button.addTarget(self, action: #selector(bookmarkButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .customFont(for: .subHeadline)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayer()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(magazine: Magazine) {
        magazineId = magazine.id
        titleLabel.text = magazine.title
        backgroundImageView.image = magazine.profileImage
    }
    
    @objc func bookmarkButtonTapped() {
        // 다음 PR 때 viewModel 로직 추가할 예정
        // 이번 PR은 UI만.
    }
}

// MARK: UI setup 관련 Methods
extension MagazineCollectionViewCell {
    private func setupLayer() {
        self.layer.cornerRadius = 12
    }
    
    private func setupLayout() {
        addSubview(backgroundImageView)
        addSubview(bookmarkButton)
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            backgroundImageView.widthAnchor.constraint(equalTo: widthAnchor),
            backgroundImageView.heightAnchor.constraint(equalTo: heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            bookmarkButton.topAnchor.constraint(equalTo: topAnchor),
            bookmarkButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            bookmarkButton.widthAnchor.constraint(equalToConstant: 44),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
}
