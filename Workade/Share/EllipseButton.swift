//
//  EllipseButton.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/11/19.
//

import UIKit

/// 타원 모양의 버튼. EllipseSegmentControl에서 쓸 수 있도록 만들어졌습니다.
///
/// 원하면 그 외에서도 사용이 가능하지만, 현재 강조 색상 및 평소 색상은 고정되어있습니다.
final class EllipseButton: UIButton {
    init(title: String) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        setTitleColor(.theme.tertiary, for: .normal)
        titleLabel?.font = .customFont(for: .footnote)
        backgroundColor = .theme.groupedBackground
        layer.cornerRadius = intrinsicContentSize.height/2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        var padding: CGFloat?
        let count = titleLabel?.text?.count ?? 1
        switch count {
        case 1: padding = 8 // 글자 수마다 너비 대략 11 차이.
        case 2: padding = 19
        default: padding = 28 // 3이상부터는 28로 고정.
        } // button의 intrinsic size 최소 30. '한 글자와 두 글자가 동일' 및 '두 글자일 때와 세 글자일 때가 큰 차이 없음'. 고로 해당 케이스들만 커스텀.
        return CGSize(width: super.intrinsicContentSize.width + padding!, height: 34)
    }
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? .theme.workadeBlue : .theme.groupedBackground
            setTitleColor(isSelected ? .theme.background : .theme.tertiary, for: .normal)
        }
    }
}
