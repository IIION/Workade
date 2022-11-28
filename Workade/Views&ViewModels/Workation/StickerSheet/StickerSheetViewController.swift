//
//  StickerSheetViewController.swift
//  Workade
//
//  Created by Wonhyuk Choi on 2022/11/21.
//

import UIKit

class StickerSheetViewController: UIViewController {
    var viewDidDismiss: (() -> Void)?
    
    private lazy var backgroundView = UIView(frame: view.frame)
    
    private let stickerImage: UIImageView = {
        let image = UIImage(named: "TangerineSticker")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let getStickerLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(for: .captionHeadlineNew)
        label.textColor = .theme.background
        label.text = "새로운 스티커를 획득했어요!"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let stickerNameLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(for: .title1)
        label.textColor = .theme.background
        label.text = "감귤 스티커"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let dateAndPlaceLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(for: .footnote)
        label.textColor = .theme.background
        label.text = "2022.12.03 제주에서 획득"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    @objc private func backgroundViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        presentingViewController?.dismiss(animated: true)
        self.viewDidDismiss?()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundViewTap = UITapGestureRecognizer(target: self, action: #selector(backgroundViewTapped(_:)))
        backgroundView.addGestureRecognizer(backgroundViewTap)
        backgroundView.isUserInteractionEnabled = true
        
        setupLayout()
    }
}

extension StickerSheetViewController {
    private func setupLayout() {
        view.addSubview(backgroundView)
        
        view.addSubview(stickerImage)
        NSLayoutConstraint.activate([
            stickerImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stickerImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stickerImage.heightAnchor.constraint(equalToConstant: 195)
        ])
        
        view.addSubview(getStickerLabel)
        NSLayoutConstraint.activate([
            getStickerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            getStickerLabel.bottomAnchor.constraint(equalTo: stickerImage.topAnchor, constant: -40)
        ])
        
        view.addSubview(stickerNameLabel)
        NSLayoutConstraint.activate([
            stickerNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stickerNameLabel.topAnchor.constraint(equalTo: stickerImage.bottomAnchor, constant: 40)
        ])
        
        view.addSubview(dateAndPlaceLabel)
        NSLayoutConstraint.activate([
            dateAndPlaceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dateAndPlaceLabel.topAnchor.constraint(equalTo: stickerNameLabel.bottomAnchor, constant: 4)
        ])
    }
}
