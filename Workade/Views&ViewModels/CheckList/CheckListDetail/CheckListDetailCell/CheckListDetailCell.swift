//
//  CheckListDetailCell.swift
//  Workade
//
//  Created by Wonhyuk Choi on 2022/10/21.
//

import UIKit
import SwiftUI

class CheckListDetailCell: UITableViewCell {
    var isChecked: Bool = false
    var content: String = ""
    
    private lazy var checkImage: UIImageView = {
        let imageView = UIImageView()
        let image = isChecked ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "circle")
        imageView.image = image
        imageView.tintColor = .theme.primary
        imageView.frame = CGRect(x: 0, y: 0, width: 21, height: 22)
        
        return imageView
    }()
    
    private lazy var contentText: UITextField = {
        let textField = UITextField()
        textField.text = content
        textField.font = .customFont(for: .footnote)
        
        return textField
    }()
    
    private lazy var checkStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [checkImage, contentText])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 9
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CheckListDetailCell {
    private func setupLayout() {
        contentView.addSubview(checkStack)
        
        let guide = contentView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            checkStack.topAnchor.constraint(equalTo: guide.topAnchor, constant: 15),
            checkStack.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -15),
            checkStack.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            checkStack.trailingAnchor.constraint(lessThanOrEqualTo: guide.trailingAnchor, constant: -10)
        ])
    }
}

struct CheckListDetailCellRepresentable: UIViewRepresentable {
    typealias UIViewType = CheckListDetailCell
    
    func makeUIView(context: Context) -> CheckListDetailCell {
        return CheckListDetailCell()
    }
    
    func updateUIView(_ uiView: CheckListDetailCell, context: Context) {}
}

struct CheckListDetailCellPreview: PreviewProvider {
    static var previews: some View {
        CheckListDetailCellRepresentable()
            .ignoresSafeArea()
            .frame(width: 350, height: 52)
            .previewLayout(.sizeThatFits)
    }
}
