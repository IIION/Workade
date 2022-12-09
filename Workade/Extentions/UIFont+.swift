//
//  Font+.swift
//  Workade
//
//  Created by 김예훈 on 2022/10/19.
//

import UIKit

// MARK: Font
// label.font = .customFont(for: .title1)
extension UIFont {
    static func customFont(for customStyle: CustomTextStyle) -> UIFont {
        switch customStyle {
        case .title1:
            return UIFont(name: CustomFont.satoshiBlack.rawValue, size: 28) ?? UIFont.systemFont(ofSize: 28, weight: .bold)
        case .title2:
            return UIFont(name: CustomFont.satoshiBlack.rawValue, size: 24) ?? UIFont.systemFont(ofSize: 24, weight: .bold)
        case .title3:
            return UIFont(name: CustomFont.satoshiBold.rawValue, size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .bold)
        case .headline:
            return UIFont(name: CustomFont.satoshiMedium.rawValue, size: 17) ?? UIFont.systemFont(ofSize: 17, weight: .semibold)
        case .captionHeadline:
            return UIFont(name: CustomFont.satoshiBlack.rawValue, size: 17) ?? UIFont.systemFont(ofSize: 17, weight: .semibold)
        case .subHeadline:
            return UIFont(name: CustomFont.satoshiBold.rawValue, size: 15) ?? UIFont.systemFont(ofSize: 15, weight: .bold)
        case .articleBody:
            return UIFont(name: CustomFont.satoshiMedium.rawValue, size: 15) ?? UIFont.systemFont(ofSize: 15, weight: .semibold)
        case .footnote:
            return UIFont(name: CustomFont.satoshiMedium.rawValue, size: 13) ?? UIFont.systemFont(ofSize: 13, weight: .medium)
        case .footnote2:
            return UIFont(name: CustomFont.satoshiBold.rawValue, size: 13) ?? UIFont.systemFont(ofSize: 13, weight: .medium)
        case .caption:
            return UIFont(name: CustomFont.satoshiRegular.rawValue, size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .regular)
        case .caption2:
            return UIFont(name: CustomFont.satoshiBold.rawValue, size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .regular)
        case .tag:
            return UIFont(name: CustomFont.satoshiRegular.rawValue, size: 10) ?? UIFont.systemFont(ofSize: 10, weight: .regular)
        }
    }
}

enum CustomFont: String {
    case pretendardBold = "Pretendard-Bold"
    case pretendardSemiBold = "Pretendard-SemiBold"
    case pretendardMedium = "Pretendard-Medium"
    case pretendardRegular = "Pretendard-Regular"
    
    case satoshiBlack = "Satoshi-Black"
    case satoshiBold = "Satoshi-Bold"
    case satoshiMedium = "Satoshi-Medium"
    case satoshiRegular = "Satoshi-Regular"
}

enum CustomTextStyle: String {
    case title1
    case title2
    case title3
    case headline
    case captionHeadline
    case subHeadline
    case articleBody
    case footnote
    case footnote2
    case caption
    case caption2
    case tag
}
