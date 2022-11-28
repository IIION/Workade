//
//  CellImageView.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/10/22.
//

import UIKit

/**
 이미지 위에 미리 연한 black 레이어를 덮어둔 *UIImageView*

 모든 셀들의 제목 등 텍스트 색상은 하얀색입니다. 밝은 사진이 들어오더라도 텍스트가 잘 보일 수 있도록 black 레이어는 필수적입니다.
 사용 시 frame만 지정해주면 되는데 이미지는 보통 셀에 꽉채우기 때문에 셀 안에서 선언하면서 bounds를 입력하시면 됩니다.
 - 여기서 말하는 bounds == 셀.bounds
 */
final class CellImageView: UIImageView {
    init(bounds: CGRect) {
        super.init(frame: .zero) // 추후 Skeleton에 초기 이미지 넣어도 될 듯함
        contentMode = .scaleAspectFill
        clipsToBounds = true
        layer.cornerRadius = 16
        backgroundColor = .theme.groupedBackground // Skeleton color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
