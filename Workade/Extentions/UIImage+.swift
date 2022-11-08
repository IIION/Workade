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

// NSCashe의 기본 특성 상 앱이 background환경으로 가면 모든 캐시메모리가 비워집니다.
// 캐시에 저장할 타입에 NSDiscardableContent(= 버려질 수 있는 컨텐츠) 프로토콜을 채택한 후, access를 true로 주고, discarded를 false로 주면, 캐시가 비워지지않도록 조절할 수 있습니다.
// 공식문서 상의 내용을 보면, NSCashe는 메모리가 과해질 경우 알아서 초과되는 캐시를 비워나간다고 말하고 있으나, 명시적으로 하기위해 ImageCasheManager의 NSCashe의 countLimit을 200으로 세팅해두었습니다.
extension UIImage: NSDiscardableContent {
    // True if the content is still available and have been successfully accessed.
    public func beginContentAccess() -> Bool {
        return true
    }

    // Called when the content is no longer being accessed.
    public func endContentAccess() {}

    // If our counter is 0, we can discard the image.
    public func discardContentIfPossible() {}

    // True if the content has been discarded.
    public func isContentDiscarded() -> Bool {
        return false
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
    case bookmarkInDetail
    case bookmarkFillInDetail
    case bookmarkInNavigation
    case bookmarkFillInNavigation

    var image: UIImage {
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium, scale: .default)
        
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
        case .bookmarkInDetail:
            return .fromSystemImage(name: "bookmark", font: .systemFont(ofSize: 22, weight: .medium), color: .white)!
        case .bookmarkFillInDetail:
            return .fromSystemImage(name: "bookmark.fill", font: .systemFont(ofSize: 22, weight: .medium), color: .white)!
        case .bookmarkInNavigation:
            return .fromSystemImage(name: "bookmark", font: .systemFont(ofSize: 17, weight: .bold), color: .theme.primary)!
        case .bookmarkFillInNavigation:
            return .fromSystemImage(name: "bookmark.fill", font: .systemFont(ofSize: 17, weight: .bold), color: .theme.primary)!
        }
    }
}
