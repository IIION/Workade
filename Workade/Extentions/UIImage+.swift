//
//  UIImage+.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/10/18.
//

import UIKit

extension UIImage {
    /// **System Image를 간편하게 구성하고 생성할 수 있도록 하는 메서드**
    /// - name: 시스템 기본 이미지의 이름
    /// - font: font에 정의된 size와 weight로 systemImage를 구성
    /// - color: 색상을 설정. default UIColor.black
    ///
    /// **withTintColor** 및 **withConfiguration**의 경우 반환값을 이용하여 기존 값을 바꾸는 시스템으로 동작하기 때문에 static 타입 메서드로 정의
    /// 인스턴스 메서드 사용 시 self는 불변값이 기에 이같은 방식을 사용하지 못함.
    static func fromSystemImage(name: String, font: UIFont, color: UIColor = .black) -> UIImage? {
        let configuration = UIImage.SymbolConfiguration(font: font)
        var image = UIImage(systemName: name, withConfiguration: configuration)
        image = image?.withTintColor(color, renderingMode: .alwaysOriginal)
        return image
    }

    /// 이미지의 Original 렌더링 세팅을 좀 더 간소화한 버전
    func setOriginal() -> UIImage {
        return self.withRenderingMode(.alwaysOriginal)
    }
}

enum SFSymbol {
    case info
    case mapInCell
    case chevronLeft // in navigationbar
    case chevronRight
    case bookmark
    case bookmarkFill
    case gearshapeFill

    var image: UIImage {
        switch self {
        case .info:
            return .fromSystemImage(name: "info.circle.fill", font: .customFont(for: .headline), color: .theme.primary)!
        case .mapInCell:
            return .fromSystemImage(name: "map", font: .systemFont(ofSize: 16, weight: .bold), color: .white)!
        case .chevronLeft:
            return .fromSystemImage(name: "chevron.left", font: .customFont(for: .headline), color: .theme.primary)!
        case .chevronRight:
            return .fromSystemImage(name: "chevron.right", font: .systemFont(ofSize: 15, weight: .heavy), color: .theme.primary)!
        case .bookmark:
            return .fromSystemImage(name: "bookmark", font: .customFont(for: .headline), color: .white)!
        case .bookmarkFill:
            return .fromSystemImage(name: "bookmark.fill", font: .customFont(for: .headline), color: .white)!
        case .gearshapeFill:
            return .fromSystemImage(name: "gearshape.fill", font: .customFont(for: .subHeadline))!
        }
    }
}
