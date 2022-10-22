//
//  TempGalleryView.swift
//  Workade
//
//  Created by ryu hyunsun on 2022/10/20.
//

import UIKit

// TODO: 세그먼트 컨트롤을 위해 임시로 작성한 뷰 입니다. 에반이 작성 완료하면 삭제하겠습니다.
class TempGalleryView: UIView {
    private let testLabel: UILabel = {
        let label = UILabel()
        label.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry"
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }
    
    private func setupLayout() {
        addSubview(testLabel)
        NSLayoutConstraint.activate([
            testLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            testLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            testLabel.topAnchor.constraint(equalTo: topAnchor),
            testLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            testLabel.heightAnchor.constraint(equalToConstant: 1000)
        ])
    }
}
