//
//  CustomSegmentedControl.swift
//  Workade
//
//  Created by Hong jeongmin on 2022/10/20.
//

import UIKit

class CustomSegmentedControl: UISegmentedControl {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSegmentedControl()
    }
    
    override init(items: [Any]?) {
        super.init(items: items)
        self.setupSegmentedControl()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupSegmentedControl() {
        let image = UIImage()
        self.setBackgroundImage(image, for: .normal, barMetrics: .default)
        self.setBackgroundImage(image, for: .selected, barMetrics: .default)
        self.setBackgroundImage(image, for: .highlighted, barMetrics: .default)
        
        self.setDividerImage(image, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
    }
}
