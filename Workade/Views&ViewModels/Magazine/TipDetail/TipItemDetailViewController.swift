//
//  TipItemDetailViewController.swift
//  Workade
//
//  Created by Hong jeongmin on 2022/10/22.
//

import UIKit

class TipItemDetailViewController: UIViewController {
    // Binding
    var label: String?
    
    let titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        // TODO: 추후 데이터 연결하여 동적으로 이미지 받아오도록 수정
        imageView.image = UIImage(named: "sampleTipImage") ?? UIImage()
        
        return imageView
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton.closeButton
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(clickedCloseButton(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .theme.background
        label.font = .customFont(for: .title1)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var bookmarkButton: UIButton = {
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium, scale: .default)

        let button = UIButton()
        // TODO: 추후 Bookmark 정보 가져올때 북마크 true / false 정보에 따라 갱신
        button.setImage(UIImage(systemName: "bookmark", withConfiguration: config), for: .normal)
        button.tintColor = .theme.background
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(clickedBookmarkButton(sender:)), for: .touchUpInside)

        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .theme.background
        titleLabel.text = label ?? "정보를 불러올 수 없습니다."
        
        setupLayout()
    }
    
    func setupLayout() {
        view.addSubview(titleImageView)
        NSLayoutConstraint.activate([
            titleImageView.topAnchor.constraint(equalTo: view.topAnchor),
            titleImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleImageView.heightAnchor.constraint(equalToConstant: (UIApplication.shared.windows.first?.safeAreaInsets.top ?? 44) + 375)
        ])
        
        view.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: titleImageView.trailingAnchor, constant: -20)
        ])
        
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: titleImageView.leadingAnchor, constant: 20),
            titleLabel.bottomAnchor.constraint(equalTo: titleImageView.bottomAnchor, constant: -20)
        ])
        
        view.addSubview(bookmarkButton)
        NSLayoutConstraint.activate([
            bookmarkButton.trailingAnchor.constraint(equalTo: titleImageView.trailingAnchor, constant: -20),
            bookmarkButton.bottomAnchor.constraint(equalTo: titleImageView.bottomAnchor, constant: -20),
            bookmarkButton.widthAnchor.constraint(equalToConstant: 48),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    @objc
    func clickedCloseButton(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        TipDetailViewController().setupLayout()
    }
    
    @objc
    func clickedBookmarkButton(sender: UIButton) {
        // TODO: 추후 북마크 버튼 눌렀을때 북마크 해제, 추가 로직 구현부
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium, scale: .default)
        
        if sender.currentImage
            == UIImage(systemName: "bookmark", withConfiguration: config) {
            sender.setImage(UIImage(systemName: "bookmark.fill", withConfiguration: config), for: .normal)
        } else {
            sender.setImage(UIImage(systemName: "bookmark", withConfiguration: config), for: .normal)
        }
    }
}
