//
//  Color+.swift
//  Workade
//
//  Created by Inho Choi on 2022/10/18.
//

import UIKit

// MARK: Color
// self.view.backgroundColor = .theme.primary

extension UIColor {
    static let theme = ColorTheme()
    
    static func rgb(_ rgbValue: Int) -> UIColor {
        return UIColor(
            red: CGFloat((Float((rgbValue & 0xff0000) >> 16)) / 255.0),
            green: CGFloat((Float((rgbValue & 0x00ff00) >> 8)) / 255.0),
            blue: CGFloat((Float((rgbValue & 0x0000ff) >> 0)) / 255.0),
            alpha: 1.0)
    }
}

struct ColorTheme {
    let primary = UIColor(named: "Primary") ?? UIColor(.black)
    let secondary = UIColor(named: "Secondary") ?? UIColor(.black)
    let tertiary = UIColor(named: "Tertiary") ?? UIColor(.black)
    let quaternary = UIColor(named: "Quaternary") ?? UIColor(.black)
    
    let background = UIColor(named: "Background") ?? UIColor(.black)
    let labelBackground = UIColor(named: "LabelBackground") ?? UIColor(.black)
    let groupedBackground = UIColor(named: "GroupedBackground") ?? UIColor(.black)
    let subGroupedBackground = UIColor(named: "SubGroupedBackground") ?? UIColor(.black)
}
