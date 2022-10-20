//
//  Font+.swift
//  Workade
//
//  Created by 김예훈 on 2022/10/19.
//

import Foundation
import UIKit

// MARK: Font
// label.font = .customFont(for: .title1)
extension UIFont {
    static func customFont(for customStyle: CustomTextStyle) -> UIFont {
        var customFont: UIFont!
        switch customStyle {
        case .title1:
            customFont = UIFont(name: CustomFont.pretendardBold.rawValue, size: 28)!
            
        case .title2:
            customFont = UIFont(name: CustomFont.pretendardBold.rawValue, size: 24)!
            
        case .title3:
            customFont = UIFont(name: CustomFont.pretendardBold.rawValue, size: 20)!
            
        case .headline:
            customFont = UIFont(name: CustomFont.pretendardSemiBold.rawValue, size: 17)!
            
        case .subHeadline:
            customFont = UIFont(name: CustomFont.pretendardRegular.rawValue, size: 15)!
            
        case .articleBody:
            customFont = UIFont(name: CustomFont.pretendardSemiBold.rawValue, size: 15)!
            
        case .footnote:
            customFont = UIFont(name: CustomFont.pretendardMedium.rawValue, size: 13)!
            
        case .caption:
            customFont = UIFont(name: CustomFont.pretendardRegular.rawValue, size: 12)!
        }
        
        return customFont
    }
}

enum CustomFont: String {
    case pretendardBold = "Pretendard-Bold"
    case pretendardSemiBold = "Pretendard-SemiBold"
    case pretendardMedium = "Pretendard-Medium"
    case pretendardRegular = "Pretendard-Regular"
}

enum CustomTextStyle {
    case title1
    case title2
    case title3
    case headline
    case subHeadline
    case articleBody
    case footnote
    case caption
}
