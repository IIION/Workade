//
//  CheckListTemplateCell.swift
//  Workade
//
//  Created by 김예훈 on 2022/10/26.
//

import UIKit
import SwiftUI

class CheckListTemplateCell: UICollectionViewCell {
    var task: Task<Void, Error>?
    
    lazy var plusButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 13, weight: .bold)
        let xmarkImage = UIImage(systemName: "plus", withConfiguration: imageConfig)
        
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialLight))
        blur.isUserInteractionEnabled = false
        blur.clipsToBounds = true
        blur.layer.cornerRadius = 16
        
        button.setImage(xmarkImage, for: .normal)
        button.tintColor = .theme.primary
        button.layer.cornerRadius = 16
        button.insertSubview(blur, at: 0)
        button.addTarget(self, action: #selector(add), for: .touchUpInside)
        
        blur.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        blur.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        if let imageView = button.imageView {
            button.bringSubviewToFront(imageView)
        }
        
        return button
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .theme.primary
        label.numberOfLines = 0
        label.font = .customFont(for: .subHeadline)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let attributedStr = NSMutableAttributedString(string: "하이하이")
        attributedStr.addAttribute(.foregroundColor, value: UIColor.black, range: ("하이하이" as NSString).range(of: "하이"))
        label.attributedText = attributedStr
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupLayout() {
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(plusButton)
        
        self.contentView.backgroundColor = .theme.background
        self.layer.cornerCurve = .continuous
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 15),
            titleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -15)
        ])
        
        NSLayoutConstraint.activate([
            plusButton.widthAnchor.constraint(equalToConstant: 32),
            plusButton.heightAnchor.constraint(equalToConstant: 32),
            plusButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            plusButton.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10)
        ])
    }
    
    func setupCell(checkListTemplate: CheckListTemplateModel) {
        let title = checkListTemplate.title
        let partialText = checkListTemplate.tintString
        let hexString = checkListTemplate.tintColor
        let imageUrl = checkListTemplate.imageURL
        let attributedStr = NSMutableAttributedString(string: title)
        attributedStr.addAttribute(.foregroundColor, value: hexStringToUIColor(hex: hexString), range: (title as NSString).range(of: partialText))
        self.titleLabel.attributedText = attributedStr
        self.imageView.image = nil
        task = Task {
            await self.imageView.setImageURL(title: title, url: imageUrl)
        }
    }
    
    override func prepareForReuse() {
        task?.cancel()
    }
    
    func hexStringToUIColor (hex: String) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        if (cString.count) != 6 {
            return UIColor.gray
        }

        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    @objc
    private func add() { }
}

struct CheckListTemplateCellRepresentable: UIViewRepresentable {
    typealias UIViewType = CheckListTemplateCell
    
    func makeUIView(context: Context) -> CheckListTemplateCell {
        return CheckListTemplateCell()
    }
    
    func updateUIView(_ uiView: CheckListTemplateCell, context: Context) {}
}
