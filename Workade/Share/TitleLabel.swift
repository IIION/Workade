//
//  TitleView.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/10/26.
//

import UIKit

/// 마이페이지, 설정, 매거진, 체크리스트에서 공통적으로 사용하는 최상단 Title파트의 Label
final class TitleLabel: UILabel {
    convenience init(title: String) {
        self.init(frame: .zero)
        text = title
        font = .customFont(for: .title3)
        textColor = .theme.primary
        translatesAutoresizingMaskIntoConstraints = false
    }
}
