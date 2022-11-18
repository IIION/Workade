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
    
    static func hexStringToUIColor (hex: String) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        if (cString.count) != 6 {
            return UIColor.gray
        }

        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

struct ColorTheme {
    fileprivate init() {}
    
    let workadeBlue = UIColor(named: "WorkadeBlue") ?? UIColor.black
    
    let primary = UIColor(named: "Primary") ?? UIColor.black
    let secondary = UIColor(named: "Secondary") ?? UIColor.black
    let tertiary = UIColor(named: "Tertiary") ?? UIColor.black
    let quaternary = UIColor(named: "Quaternary") ?? UIColor.black
    let background = UIColor(named: "Background") ?? UIColor.black
    let labelBackground = UIColor(named: "LabelBackground") ?? UIColor.black
    let sectionBackground = UIColor(named: "SectionBackground") ?? UIColor.black
    let groupedBackground = UIColor(named: "GroupedBackground") ?? UIColor.black
    let subGroupedBackground = UIColor(named: "SubGroupedBackground") ?? UIColor.black
    
    let contentRed = UIColor(named: "Red") ?? UIColor.black
    let contentYellow = UIColor(named: "Yellow") ?? UIColor.black
    let contentGreen = UIColor(named: "Green") ?? UIColor.black
    let contentBlue = UIColor(named: "Blue") ?? UIColor.black
    let contentPurple = UIColor(named: "Purple") ?? UIColor.black
    let contentPink = UIColor(named: "Pink") ?? UIColor.black
}
