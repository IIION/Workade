//
//  MapInfoModalView.swift
//  Workade
//
//  Created by Inho Choi on 2022/11/10.
//

import NMapsMap
import UIKit

class MapInfoView: UIView {
    var marker: NMFMarker? = nil
    
    init(marker: NMFMarker?) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white
        self.layer.cornerRadius = 30
        
        setLayout(marker: marker)
    }
    
    var titleLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .customFont(for: .captionHeadlineNew)
        title.textColor = .black
        return title
    }()
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout(marker: NMFMarker?) {
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 22),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -22),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 85),
            titleLabel.trailingAnchor.constraint(equalTo: self.leadingAnchor, constant: 200 + 85)
        ])
    }
}
