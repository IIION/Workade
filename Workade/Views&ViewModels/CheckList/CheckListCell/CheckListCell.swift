//
//  CheckListCell.swift
//  Workade
//
//  Created by Wonhyuk Choi on 2022/10/20.
//

import UIKit

class CheckListCell: UICollectionViewCell {
    var checkListCellViewModel = CheckListCellViewModel()
    
    var isDeleteMode = false {
        didSet {
            if isDeleteMode {
                self.displayStack.isHidden = true
                self.deleteButton.isHidden = false
            } else {
                self.displayStack.isHidden = false
                self.deleteButton.isHidden = true
            }
            self.contentView.layoutIfNeeded()
        }
    }
    
    private var uncheckLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = .customFont(for: .footnote)
        
        return label
    }()
    
    private lazy var uncheckStack: UIStackView = {
        let uncheckImage = UIImageView(image: UIImage(systemName: "circle"))
        uncheckImage.tintColor = .black
        
        let stackView = UIStackView(arrangedSubviews: [uncheckImage, uncheckLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 2
        
        return stackView
    }()
    
    private lazy var checkLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = .customFont(for: .footnote)
        
        return label
    }()
    
    private lazy var checkStack: UIStackView = {
        let checkImage = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
        checkImage.tintColor = .black
        
        let stackView = UIStackView(arrangedSubviews: [checkImage, checkLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 2
        
        return stackView
    }()
    
    private lazy var displayStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [uncheckStack, checkStack])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fill
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    lazy var deleteButton: UIButton = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)
        let image = UIImage(systemName: "xmark.circle.fill", withConfiguration: imageConfig)
        
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.tintColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "제목없음"
        label.font = .customFont(for: .subHeadline)
        label.tintColor = .theme.primary
        
        return label
    }()
    
    private lazy var dateLabel: UILabel  = {
        let padding = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        let label = BasePaddingLabel(padding: padding)
        label.text = "D - \(1)"
        label.font = .customFont(for: .caption)
        label.tintColor = .theme.tertiary
        label.backgroundColor = .theme.subGroupedBackground
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        
        return label
    }()
    
    private lazy var labelStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, dateLabel])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.spacing = 3
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = 20
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.theme.groupedBackground.cgColor
        
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(checkList: CheckList) {
        titleLabel.text = checkList.title ?? "제목없음"
        checkListCellViewModel.selectedCheckList = checkList
        checkLabel.text = "\(checkListCellViewModel.checkCount)"
        uncheckLabel.text = "\(checkListCellViewModel.uncheckCount)"
        
        if let targetDate = checkListCellViewModel.selectedCheckList?.travelDate {
            dateLabel.text = generateDateLabelText(targetDate: targetDate)
        }
    }
    
    private func generateDateLabelText(targetDate: Date) -> String {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        let date1 = calendar.startOfDay(for: Date())
        let date2 = calendar.startOfDay(for: targetDate)
        
        if date1 == date2 {
            return "D - day"
        } else {
            if let dDay = calendar.dateComponents([.day], from: date1, to: date2).day,
               0 < dDay && dDay < 8 {
                return "D - \(dDay)"
            } else {
                dateFormatter.dateFormat = "yyyy.MM.dd"
                return dateFormatter.string(from: targetDate)
            }
        }
    }
}

extension CheckListCell {
    private func setupLayout() {
        [labelStack, displayStack, deleteButton].forEach { subView in
            contentView.addSubview(subView)
        }
        
        let guide = contentView.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            deleteButton.topAnchor.constraint(equalTo: guide.topAnchor, constant: 16),
            deleteButton.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            displayStack.topAnchor.constraint(equalTo: guide.topAnchor, constant: 16),
            displayStack.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            labelStack.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 10),
            labelStack.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -10)
        ])
    }
}
