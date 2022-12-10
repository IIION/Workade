//
//  StickerSheetViewController.swift
//  Workade
//
//  Created by Wonhyuk Choi on 2022/11/21.
//

import Combine
import UIKit

class StickerSheetViewController: UIViewController {
    
    @Published private var step = 0
    var stickers: [StickerModel]
    private var anyCancellable = Set<AnyCancellable>()
    var viewDidDismiss: (() -> Void)?
    
    init(stickers: [StickerModel]) {
        self.stickers = stickers
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var backgroundView = UIView(frame: view.frame)
    
    private let stickerImage: UIImageView = {
        let image = UIImage(named: "")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let getStickerLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(for: .captionHeadline)
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
        if step < stickers.count-1 {
            step += 1
        } else {
            Task {
                guard var user = UserManager.shared.user.value else { return }
                if user.stickers == nil {
                    user.stickers = stickers
                } else {
                    user.stickers?.append(contentsOf: stickers)
                }
                try await FirestoreDAO.shared.createUser(user: user)
            }
            presentingViewController?.dismiss(animated: true)
            self.viewDidDismiss?()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundViewTap = UITapGestureRecognizer(target: self, action: #selector(backgroundViewTapped(_:)))
        backgroundView.addGestureRecognizer(backgroundViewTap)
        backgroundView.isUserInteractionEnabled = true
        
        setupLayout()
        
        self.$step.sink { [weak self] index in
            if index < self?.stickers.count ?? 0 {
                self?.stickerImage.image = UIImage(named: self?.stickers[index].title.rawValue ?? "")
                self?.stickerNameLabel.text = self?.stickers[index].title.name
                self?.dateAndPlaceLabel.text = Date().formatted(.dateTime.year().month().day()) + (self?.stickers[index].region.name ?? "") + "에서 휙득"
            }
        }
        .store(in: &anyCancellable)
    }
}

extension StickerSheetViewController {
    private func setupLayout() {
        view.addSubview(backgroundView)
        
        view.addSubview(stickerImage)
        NSLayoutConstraint.activate([
            stickerImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stickerImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stickerImage.heightAnchor.constraint(equalToConstant: 195),
            stickerImage.widthAnchor.constraint(equalToConstant: 195)
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
