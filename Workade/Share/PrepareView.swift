//
//  PrepareView.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/11/20.
//

import UIKit

enum GuideCategory {
    case office(_ region: String)
    case magazine(_ category: MagazineCategory)
}

/// 현재 아직 컨텐츠가 없는 화면에 띄울 View
final class PrepareView: UIView {
    var category: GuideCategory? {
        didSet {
            setupText(category: category!)
        }
    }
    
    private let prepareImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "folder")) // 임시 이미지. 추후 Asset PR 반영된 후 수정 예정.
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let prepareLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(for: .captionHeadline)
        label.textColor = .theme.primary
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let expectLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(for: .caption2)
        label.textColor = .theme.tertiary
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupText(category: GuideCategory) {
        switch category {
        case .office(let regionName):
            prepareLabel.text = "현재 준비중인 지역입니다."
            expectLabel.text = "\(regionName) 편도 기대해주세요~!"
        case .magazine(let category):
            prepareLabel.text = category == .wishList ? "찜한 매거진이 없네요~!" : "현재 준비중인 컨텐츠입니다."
        }
    }
    
    private func setupLayout() {
        addSubview(prepareImageView)
        addSubview(prepareLabel)
        addSubview(expectLabel)
        
        NSLayoutConstraint.activate([
            prepareImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            prepareImageView.widthAnchor.constraint(equalToConstant: 100),
            prepareImageView.heightAnchor.constraint(equalToConstant: 100),
            prepareImageView.bottomAnchor.constraint(equalTo: prepareLabel.topAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            prepareLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            prepareLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            expectLabel.topAnchor.constraint(equalTo: prepareLabel.bottomAnchor, constant: 10),
            expectLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
