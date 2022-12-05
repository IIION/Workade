//
//  PickerTableViewCell.swift
//  Workade
//
//  Created by Hong jeongmin on 2022/11/21.
//

import UIKit

class PickerTableViewCell: UITableViewCell {
    static let cellId = "PickerTableViewCell"
    
    let pickerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .theme.tertiary
        label.font = .customFont(for: .footnote2)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(pickerLabel)
        NSLayoutConstraint.activate([
            pickerLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            pickerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        ])
    }
}
