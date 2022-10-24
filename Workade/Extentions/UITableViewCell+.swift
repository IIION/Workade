//
//  UITableViewCell+.swift
//  Workade
//
//  Created by Wonhyuk Choi on 2022/10/22.
//

import UIKit

public extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
