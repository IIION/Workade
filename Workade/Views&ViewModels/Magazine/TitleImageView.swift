//
//  TitleImageView.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/11/24.
//

import UIKit
import Combine

class MagazineTitleImageView: UIImageView {
    let magazine: MagazineModel
    var bookmarkPublisher: PassthroughSubject<Void, Never>?
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .theme.background
        label.font = .customFont(for: .title1)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var bookmarkButton: UIButton = {
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium, scale: .default)
        let button = UIButton()
        button.tintColor = .theme.background
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.bookmarkPublisher?.send()
            self?.setupBookmarkImage()
            print("하윙")
        }), for: .touchUpInside)
        
        return button
    }()
    
    init(by magazine: MagazineModel) {
        self.magazine = magazine
        super.init(frame: .zero)
        contentMode = .scaleAspectFill
        clipsToBounds = true
        isUserInteractionEnabled = true
        translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = magazine.title
        
        Task {
            do {
                try await setImageURL(from: magazine.imageURL)
            } catch {
                let error = error as? NetworkError ?? .unknownError
                print(error.message)
            }
        }
        
        setupBookmarkImage()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupBookmarkImage() {
        bookmarkButton.setImage(userDefaultsCheck() ? SFSymbol.bookmarkFillInDetail.image : SFSymbol.bookmarkInDetail.image, for: .normal)
    }
    
    private func userDefaultsCheck() -> Bool {
        return UserDefaultsManager.shared.loadUserDefaults(key: Constants.Key.wishMagazine).contains(magazine.title)
    }
    
    private func setupLayout() {
        addSubview(titleLabel)
        addSubview(bookmarkButton)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            bookmarkButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            bookmarkButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            bookmarkButton.widthAnchor.constraint(equalToConstant: 48),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
}
