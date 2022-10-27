//
//  MegazineCollectionViewCell.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/10/22.
//

import UIKit

/// 매거진을 나열한 컬렉션뷰의 셀
final class MagazineCollectionViewCell: UICollectionViewCell {
    private var magazineId: String?
    private var task: Task<Void, Error>?
    
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
    
    // 이미지를 nil로 처리해도 빠른 스크롤의 경우 이미지 꼬임 현상을 완벽하게 해결하진 못합니다.
    // 재사용 셀 큐를 지난후 prepare단계 때 task를 취소시켜줌으로써, 이미지 꼬임 현상을 완벽하게 막을 수 있습니다.
    // 주의 - prepareForReuse 안에는 셀을 구성하는 컨텐트(컴포넌트 등)의 값은 핸들링하지않는 것을 공식문서에서 권장합니다.
    override func prepareForReuse() {
        task?.cancel()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayer()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(magazine: Magazine) {
        magazineId = magazine.title
        titleLabel.text = magazine.title
        backgroundImageView.image = nil
        // 이렇게 최초 구성 이미지를 nil로 해주면, 빠른 스크롤 시에 이전 이미지가 들어가있는 이미지 꼬임 현상을 다소 막아줄 수 있습니다. 그 후 불러와진 이미지가 정상적으로 자리잡게 됩니다.
        task = Task {
            await backgroundImageView.setImageURL(title: magazine.title, url: magazine.imageURL)
        }
    }
    
    @objc func bookmarkButtonTapped() {
        // 다음 PR 때 viewModel 로직 추가할 예정
        // 이번 PR은 UI만.
    }
}

// MARK: UI setup 관련 Methods
private extension MagazineCollectionViewCell {
    func setupLayer() {
        self.layer.cornerRadius = 12
    }
    
    func setupLayout() {
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
