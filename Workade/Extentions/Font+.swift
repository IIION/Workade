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
        switch customStyle {
        case .title1:
            return UIFont(name: CustomFont.pretendardBold.rawValue, size: 28) ?? UIFont.systemFont(ofSize: 28, weight: .bold)
        case .title2:
            return UIFont(name: CustomFont.pretendardBold.rawValue, size: 24) ?? UIFont.systemFont(ofSize: 24, weight: .bold)
        case .title3:
            return UIFont(name: CustomFont.pretendardBold.rawValue, size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .bold)
        case .headline:
            return UIFont(name: CustomFont.pretendardSemiBold.rawValue, size: 17) ?? UIFont.systemFont(ofSize: 17, weight: .semibold)
        case .subHeadline:
            return UIFont(name: CustomFont.pretendardRegular.rawValue, size: 15) ?? UIFont.systemFont(ofSize: 15, weight: .regular)
        case .articleBody:
            return UIFont(name: CustomFont.pretendardSemiBold.rawValue, size: 15) ?? UIFont.systemFont(ofSize: 15, weight: .semibold)
        case .footnote:
            return UIFont(name: CustomFont.pretendardMedium.rawValue, size: 13) ?? UIFont.systemFont(ofSize: 13, weight: .medium)
        case .caption:
            return UIFont(name: CustomFont.pretendardRegular.rawValue, size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .regular)
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
