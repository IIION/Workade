//
//  UILabel+.swift
//  Workade
//
//  Created by ryu hyunsun on 2022/10/28.
//

import UIKit

extension UILabel {
    func setLineHeight(lineHeight: CGFloat) {
        guard let text = self.text else { return }
        
        let attributeString = NSMutableAttributedString(string: text)
        let style = NSMutableParagraphStyle()
        
        style.lineSpacing = lineHeight
        attributeString.addAttribute(
            NSAttributedString.Key.paragraphStyle,
            value: style,
            range: NSRange(location: 0, length: attributeString.length))
        
        self.attributedText = attributeString
    }
}
