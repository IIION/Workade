//
//  Color+.swift
//  Workade
//
//  Created by Inho Choi on 2022/10/18.
//

import Foundation
import UIKit

// MARK: Color
// self.view.backgroundColor = .theme.primary

extension UIColor {
    static let theme = ColorTheme()
    
    static func rgb(_ rgbValue: Int) -> UIColor! {
        return UIColor(
            red: CGFloat((Float((rgbValue & 0xff0000) >> 16)) / 255.0),
            green: CGFloat((Float((rgbValue & 0x00ff00) >> 8)) / 255.0),
            blue: CGFloat((Float((rgbValue & 0x0000ff) >> 0)) / 255.0),
            alpha: 1.0)
    }
}

struct ColorTheme {
    let primary = UIColor(named: "Primary")!
    let secondary = UIColor(named: "Secondary")!
    let tertiary = UIColor(named: "Tertiary")!
    let quaternary = UIColor(named: "Quaternary")!
    
    let background = UIColor(named: "Background")!
    let labelBackground = UIColor(named: "LabelBackground")!
    let groupedBackground = UIColor(named: "GroupedBackground")!
    let subGroupedBackground = UIColor(named: "SubGroupedBackground")!
}
