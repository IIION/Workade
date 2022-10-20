//
//  CustopSegmentController.swift
//  Workade
//
//  Created by Hong jeongmin on 2022/10/20.
//

import UIKit

class CustopSegmentController: UISegmentedControl {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSegmentControl()
    }
    
    override init(items: [Any]?) {
        super.init(items: items)
        self.setupSegmentControl()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupSegmentControl() {
        let image = UIImage()
        self.setBackgroundImage(image, for: .normal, barMetrics: .default)
        self.setBackgroundImage(image, for: .selected, barMetrics: .default)
        self.setBackgroundImage(image, for: .highlighted, barMetrics: .default)
        
        self.setDividerImage(image, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
    }
}
