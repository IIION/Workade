//
//  CheckListAddButtonCell.swift
//  Workade
//
//  Created by Wonhyuk Choi on 2022/10/22.
//

import UIKit
import SwiftUI

class CheckListAddButtonCell: UICollectionViewCell {
    private lazy var addImage: UIImageView = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .bold)
        let image = UIImage(systemName: "plus.circle.fill", withConfiguration: imageConfig)
        let imageView = UIImageView(image: image)
        imageView.tintColor = .theme.primary
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = 20
        contentView.backgroundColor = .theme.groupedBackground
        
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CheckListAddButtonCell {
    private func setupLayout() {
        contentView.addSubview(addImage)
        
        let guide = contentView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            addImage.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            addImage.centerYAnchor.constraint(equalTo: guide.centerYAnchor)
        ])
    }
}

struct CheckListAddButtonCellRepresentable: UIViewRepresentable {
    typealias UIViewType = CheckListAddButtonCell
    
    func makeUIView(context: Context) -> CheckListAddButtonCell {
        return CheckListAddButtonCell()
    }
    
    func updateUIView(_ uiView: CheckListAddButtonCell, context: Context) {}
}

@available(iOS 13.0.0, *)
struct CheckListAddButtonCellPreview: PreviewProvider {
    static var previews: some View {
        CheckListAddButtonCellRepresentable()
            .ignoresSafeArea()
            .frame(width: 165, height: 165)
            .previewLayout(.sizeThatFits)
    }
}
