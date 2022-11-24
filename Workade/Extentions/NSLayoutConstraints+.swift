//
//  NSLayoutConstraints+.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/11/24.
//

import UIKit

extension NSLayoutConstraint {
    /// 기존 NSLayoutConstraint에서 Items만 변경시킨 새로운 NSLayoutConstraint를 반환하는 메서드
    ///
    /// 추후 사용할 가능성이 있어 넣었습니다. presenting되는 View's 컴포넌트들의 layout을 카피만 하면되서, upstair layout을 작성할 필요가 없어집니다.
    func replaceItem(item view1: UIView, toItem view2: UIView) -> NSLayoutConstraint {
        let replacedConstraints = NSLayoutConstraint(
            item: view1,
            attribute: firstAttribute, // ex) top, bottom
            relatedBy: relation, // ex) equalTo
            toItem: view2,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant
        )
        replacedConstraints.priority = priority
        return replacedConstraints
    }
}
