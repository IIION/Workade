//
//  UIView+.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/10/18.
//

import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        for view in views {
            self.addSubview(view)
        }
    }
}
