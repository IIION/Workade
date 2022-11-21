//
//  Divider.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/11/18.
//

import UIKit

final class Divider: UIView {
    init() {
        super.init(frame: .zero)
        backgroundColor = .theme.groupedBackground
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize { // UIScreen.main.bounds를 대신할 수 있는 접근법.
        return CGSize(width: window?.windowScene?.screen.bounds.width ?? 0, height: 1)
    }
}
