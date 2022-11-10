//
//  CGFloat+.swift
//  Workade
//
//  Created by Hong jeongmin on 2022/11/09.
//

import UIKit

extension CGFloat {
    /// Device 의 SafeArea Top의 높이
    static let topSafeArea: CGFloat = {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first else {
            if UIScreen.main.bounds.height > 736 {
                return 44
            } else {
                return 20
            }
        }
        
        return window.safeAreaInsets.top
    }()
    
    /// Device 의 SafeArea Bottom의 높이
    static let bottomSafeArea: CGFloat = {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first else {
            if UIScreen.main.bounds.height > 736 {
                return 34
            } else {
                return 0
            }
        }
        
        return window.safeAreaInsets.bottom
    }()
}
