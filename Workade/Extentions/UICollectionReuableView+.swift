//
//  UICollectionReuableView.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/10/20.
//

import UIKit

extension UICollectionReusableView {
    /// 셀 클래스의 이름 그 자체를 식별자로 쓸 수 있도록 지정
    static var identifier: String {
        return String(describing: Self.self)
    }
}
