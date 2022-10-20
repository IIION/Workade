//
//  CheckListCell.swift
//  Workade
//
//  Created by Wonhyuk Choi on 2022/10/20.
//

import UIKit
import SwiftUI

class CheckListCell: UICollectionViewCell {
    static let identifier = "CheckListCell"
    
    var uncheckCnt: Int = 0
    var checkCnt: Int = 0
    var emoji: String = "🏝"
    var title: String = "제목없음"
    var dDay: Int = 0
    
    private lazy var uncheckStack: UIStackView = {
        let uncheckImage = UIImageView(image: UIImage(systemName: "circle"))
        let uncheckLabel = UILabel()
        
        uncheckImage.tintColor = .black
        uncheckLabel.text = "\(uncheckCnt)"
        uncheckLabel.font = .customFont(for: .footnote)
        
        let stackView = UIStackView(arrangedSubviews: [uncheckImage, uncheckLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 2
        
        return stackView
    }()
    
    private lazy var checkStack: UIStackView = {
        let checkImage = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
        let checkLabel = UILabel()
        
        checkImage.tintColor = .black
        checkLabel.text = "\(checkCnt)"
        checkLabel.font = .customFont(for: .footnote)
        
        let stackView = UIStackView(arrangedSubviews: [checkImage, checkLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 2
        
        return stackView
    }()
    
    private lazy var displayStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [uncheckStack, checkStack])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.text = emoji
        label.font = .systemFont(ofSize: 30)
        
        return label
    }()
    
    private lazy var labelStack: UIStackView = {
        let titleLabel = UILabel()
        let dDayLabel = UILabel()
        
        titleLabel.text = title
        titleLabel.font = .customFont(for: .subHeadline)
        titleLabel.tintColor = .black
        
        dDayLabel.text = "D - \(dDay)"
        dDayLabel.font = .customFont(for: .caption)
        dDayLabel.tintColor = .black
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, dDayLabel])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.spacing = 3
        
        return stackView
    }()
    
    private lazy var verticalStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emojiLabel, labelStack])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.spacing = 6
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = 20
        contentView.layer.borderWidth = 2
        
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CheckListCell {
    private func setupLayout() {
        [displayStack, verticalStack].forEach { subview in
            contentView.addSubview(subview)
        }
        
        let guide = contentView.safeAreaLayoutGuide
        
        let displayStackConstraints = [
            displayStack.topAnchor.constraint(equalTo: guide.topAnchor, constant: 16),
            displayStack.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -16)
        ]
        
        let verticalStackConstraints = [
            verticalStack.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 10),
            verticalStack.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -7)
        ]
        
        NSLayoutConstraint.activate(displayStackConstraints)
        NSLayoutConstraint.activate(verticalStackConstraints)
    }
}

struct CheckListCellRepresentable: UIViewRepresentable {
    typealias UIViewType = CheckListCell
    
    func makeUIView(context: Context) -> CheckListCell {
        return CheckListCell()
    }
    
    func updateUIView(_ uiView: CheckListCell, context: Context) {}
}

@available(iOS 13.0.0, *)
struct CheckListCellPreview: PreviewProvider {
    static var previews: some View {
        CheckListCellRepresentable()
            .ignoresSafeArea()
            .frame(width: 165, height: 165)
            .previewLayout(.sizeThatFits)
    }
}
