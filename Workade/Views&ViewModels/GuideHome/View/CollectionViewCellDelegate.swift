//
//  CollectionViewCellDelegate.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/10/28.
//

import Foundation

// 원래 있는 프로토콜 아님 주의.
protocol CollectionViewCellDelegate: AnyObject {
    func didTapMapButton(office: OfficeModel)
    
    func didTapBookmarkButton(id: String)
}

extension CollectionViewCellDelegate {
    func didTapMapButton(office: OfficeModel) {}
    
    func didTapBookmarkButton(id: String) {}
}
