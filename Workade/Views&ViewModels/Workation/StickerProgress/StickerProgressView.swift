//
//  StickerProgressView.swift
//  Workade
//
//  Created by Wonhyuk Choi on 2022/11/23.
//

import Combine
import UIKit

final class StickerProgressView: UIView {
    
    var stickers: [StickerTitle]
    
    var cancellable = Set<AnyCancellable>()
    
    private let workationProgressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progress = 0
        progressView.backgroundColor = .theme.groupedBackground
        progressView.tintColor = .theme.workadeBlue
        progressView.transform = progressView.transform.scaledBy(x: 1, y: 0.1)
        
        return progressView
    }()
    
    private lazy var progressStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [UIView(), workationProgressView])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private func weekStack(image: UIImage?, isUnlocked: Bool, week: Int) -> UIStackView {
        let imageView = isUnlocked ? UIImageView(image: image) : UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        let checkView = isUnlocked ?
        UIImageView(image: UIImage(systemName: "checkmark.circle.fill")) :
        UIImageView(image: UIImage(systemName: "lock.fill"))
        checkView.tintColor = isUnlocked ? .theme.workadeBlue : .theme.primary
        checkView.contentMode = .scaleAspectFit
        checkView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        
        let verticalLine = UILabel()
        verticalLine.text = "|"
        verticalLine.font = .systemFont(ofSize: 8)
        verticalLine.textColor = .theme.primary
        
        let weekLabel = UILabel()
        weekLabel.text = "\(week)주"
        weekLabel.font = .customFont(for: .tag)
        weekLabel.textColor = .theme.primary
        
        let stackView = UIStackView(arrangedSubviews: [
            imageView,
            checkView,
            verticalLine,
            weekLabel
        ])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        
        return stackView
    }
    
    private lazy var lockStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            UIView(),
            weekStack(image: UIImage(named: stickers[0].rawValue), isUnlocked: UserManager.shared.activeMyInfo?.progressDay ?? 0 >= 7, week: 1),
            UIView(),
            weekStack(image: UIImage(named: stickers[1].rawValue), isUnlocked: UserManager.shared.activeMyInfo?.progressDay ?? 0 >= 14, week: 2),
            UIView(),
            weekStack(image: UIImage(named: stickers[2].rawValue), isUnlocked: UserManager.shared.activeMyInfo?.progressDay ?? 0 >= 21, week: 3),
            UIView(),
            weekStack(image: UIImage(named: stickers[3].rawValue), isUnlocked: UserManager.shared.activeMyInfo?.progressDay ?? 0 >= 28, week: 4),
            UIView()
        ])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    init(stickers: [StickerTitle]) {
        self.stickers = stickers
        super.init(frame: .zero)
        
        setupLayout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        let guide = safeAreaLayoutGuide
        
        addSubview(progressStack)
        NSLayoutConstraint.activate([
            progressStack.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            progressStack.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            progressStack.topAnchor.constraint(equalTo: guide.topAnchor),
            progressStack.bottomAnchor.constraint(equalTo: guide.bottomAnchor)
        ])
        
        addSubview(lockStack)
        NSLayoutConstraint.activate([
            lockStack.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            lockStack.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            lockStack.topAnchor.constraint(equalTo: guide.topAnchor),
            lockStack.bottomAnchor.constraint(equalTo: guide.bottomAnchor)
        ])
    }
    
    private func bind() {
        NotificationCenter.default.publisher(for: .NSCalendarDayChanged)
            .sink { [weak self] _ in
                DispatchQueue.main.async {
                    let offsetDate = Date().timeIntervalSince(UserManager.shared.activeMyInfo?.startDate ?? Date())
                    let day = Float(offsetDate/86400)
                    self?.workationProgressView.setProgress(day > 0 ? day/35 : 0, animated: true)
                }
            }
            .store(in: &cancellable)
        
        UserManager.shared.$activeMyInfo
            .sink { [weak self] user in
                guard let self = self, var user = user else { return }
                DispatchQueue.main.async {
                    let offsetDate = Date().timeIntervalSince(user.startDate)
                    let day = Float(offsetDate/86400)
                    self.workationProgressView.setProgress(day > 0 ? day/35 : 0, animated: true)
                }
            }
            .store(in: &cancellable)
    }
}
