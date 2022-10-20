//
//  UICollectionReuableView.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/10/20.
//

import UIKit

// cell class명을 identifier로 사용
extension UICollectionReusableView {
    static var identifier: String {
        return String(describing: Self.self)
    }
}
