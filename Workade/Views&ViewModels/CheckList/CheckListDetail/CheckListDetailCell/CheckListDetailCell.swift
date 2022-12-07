//
//  CheckListDetailCell.swift
//  Workade
//
//  Created by Wonhyuk Choi on 2022/10/21.
//

import UIKit

class CheckListDetailCell: UITableViewCell {
    lazy var checkButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(systemName: "circle")
        button.setImage(image, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 21, height: 22)
        
        return button
    }()
    
    lazy var contentText: UITextField = {
        let textField = UITextField()
        textField.text = "내용없음"
        textField.font = .customFont(for: .footnote)
        
        return textField
    }()
    
    private lazy var checkStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [checkButton, contentText])
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
    
    func setupCell(todo: Todo) {
        checkButton.setImage(todo.done ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "circle"), for: .normal)
        checkButton.tintColor = todo.done ? .theme.workadeBlue : .theme.primary
        contentText.text = todo.content
        contentText.textColor = todo.content != Optional("내용없음") ? .theme.primary : .lightGray
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
