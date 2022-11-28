//
//  StickerProgressView.swift
//  Workade
//
//  Created by Wonhyuk Choi on 2022/11/23.
//

import UIKit

final class StickerProgressView: UIView {
    private let stickerProgressViewModel = StickerProgressViewModel()
    
    private lazy var progressStack: UIStackView = {
        let progressView = UIProgressView()
        progressView.progress = 14/35
        progressView.backgroundColor = .theme.groupedBackground
        progressView.tintColor = .theme.workadeBlue
        progressView.transform = progressView.transform.scaledBy(x: 1, y: 0.1)
        
        let stackView = UIStackView(arrangedSubviews: [UIView(), progressView])
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
            weekStack(image: UIImage(named: "sampleSticker"), isUnlocked: true, week: 1),
            UIView(),
            weekStack(image: UIImage(named: "sampleSticker"), isUnlocked: true, week: 2),
            UIView(),
            weekStack(image: UIImage(named: "sampleSticker"), isUnlocked: false, week: 3),
            UIView(),
            weekStack(image: UIImage(named: "sampleSticker"), isUnlocked: false, week: 4),
            UIView()
        ])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupLayout()
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
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct StickerProgressViewPreview: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            let view = StickerProgressView(frame: .zero)
            return view
        }
        .frame(width: 310, height: 90)
        .previewLayout(.sizeThatFits)
    }
}
#endif

#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct UIViewPreview<View: UIView>: UIViewRepresentable {
    let view: View

    init(_ builder: @escaping () -> View) {
        view = builder()
    }

    // MARK: - UIViewRepresentable

    func makeUIView(context: Context) -> UIView {
        return view
    }

    func updateUIView(_ view: UIView, context: Context) {
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
}
#endif
