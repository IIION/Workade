//
//  ShareView.swift
//  Workade
//
//  Created by ryu hyunsun on 2022/11/22.
//

import UIKit

class ShareView: UIView {
    var magazine: MagazineModel
    
    private lazy var divider: UIView = {
        let divider = UIView()
        divider.backgroundColor = .rgb(0xF2F2F7)
        divider.translatesAutoresizingMaskIntoConstraints = false
        
        return divider
    }()
    
    private lazy var shareViewContrainer: UIView = {
        let shareViewContrainer = UIView()
        shareViewContrainer.translatesAutoresizingMaskIntoConstraints = false
        
        return shareViewContrainer
    }()
    
    private lazy var shareLabel: UILabel = {
        let label = UILabel()
        label.text = "주변에 공유하기"
        label.font = .customFont(for: .subHeadline)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var buttonsContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var kakaoShareButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "KakaoButton"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var clipboardButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "ClipboardButton"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var defaultShareButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "DefaultButton"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    init(magazine: MagazineModel) {
        self.magazine = magazine
        super.init(frame: .zero)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(shareViewContrainer)
        NSLayoutConstraint.activate([
            shareViewContrainer.topAnchor.constraint(equalTo: topAnchor),
            shareViewContrainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            shareViewContrainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            shareViewContrainer.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        shareViewContrainer.addSubview(shareLabel)
        NSLayoutConstraint.activate([
            shareLabel.topAnchor.constraint(equalTo: shareViewContrainer.topAnchor),
            shareLabel.leadingAnchor.constraint(equalTo: shareViewContrainer.leadingAnchor),
            shareLabel.bottomAnchor.constraint(equalTo: shareViewContrainer.bottomAnchor)
        ])
        
        shareViewContrainer.addSubview(defaultShareButton)
        NSLayoutConstraint.activate([
            defaultShareButton.topAnchor.constraint(equalTo: shareViewContrainer.topAnchor),
            defaultShareButton.trailingAnchor.constraint(equalTo: shareViewContrainer.trailingAnchor),
            defaultShareButton.bottomAnchor.constraint(equalTo: shareViewContrainer.bottomAnchor)
        ])
        
        shareViewContrainer.addSubview(clipboardButton)
        NSLayoutConstraint.activate([
            clipboardButton.topAnchor.constraint(equalTo: shareViewContrainer.topAnchor),
            clipboardButton.trailingAnchor.constraint(equalTo: defaultShareButton.leadingAnchor, constant: -14),
            clipboardButton.bottomAnchor.constraint(equalTo: shareViewContrainer.bottomAnchor)
        ])
        
        shareViewContrainer.addSubview(kakaoShareButton)
        NSLayoutConstraint.activate([
            kakaoShareButton.topAnchor.constraint(equalTo: shareViewContrainer.topAnchor),
            kakaoShareButton.trailingAnchor.constraint(equalTo: clipboardButton.leadingAnchor, constant: -14),
            kakaoShareButton.bottomAnchor.constraint(equalTo: shareViewContrainer.bottomAnchor)
        ])
    }
}
