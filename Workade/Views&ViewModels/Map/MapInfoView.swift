//
//  MapInfoModalView.swift
//  Workade
//
//  Created by Inho Choi on 2022/11/10.
//

import NMapsMap
import UIKit

class MapInfoView: UIView {
    init() {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white
        self.layer.cornerRadius = 30
        
        setLayout()
    }
    
    var titleLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .customFont(for: .captionHeadlineNew)
        title.textColor = .black
        return title
    }()
    
    var markerImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var mapButton: UIButton = {
        let mapButton = UIButton()
        mapButton.translatesAutoresizingMaskIntoConstraints = false
        mapButton.setImage(UIImage(named: "navermapbutton"), for: .normal)
        mapButton.addAction(UIAction(title: "Go") { [weak self] _ in
            self?.naverMapButtonTapped()
        }, for: .touchUpInside)
        
        return mapButton
    }()
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 22),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -22),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 85),
            titleLabel.trailingAnchor.constraint(equalTo: self.leadingAnchor, constant: 200 + 85)
        ])
        
        addSubview(markerImage)
        NSLayoutConstraint.activate([
            markerImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 22),
            markerImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -22),
            markerImage.trailingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16 + 42),
            markerImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16)
        ])
        
        addSubview(mapButton)
        NSLayoutConstraint.activate([
            mapButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 22),
            mapButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -22),
            mapButton.leadingAnchor.constraint(equalTo: self.trailingAnchor, constant: -(16 + 42)),
            mapButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
    }
    
    func setMarkerInfo(marker: NMFMarker) {
        titleLabel.text = marker.captionText
        
        switch marker.tag {
        case Pin.cafe.rawValue: markerImage.image = UIImage(named: "cafeinfo")
        case Pin.sea.rawValue: markerImage.image = UIImage(named: "seainfo")
        case Pin.restaurant.rawValue: markerImage.image = UIImage(named: "restaurantinfo")
        case Pin.nature.rawValue: markerImage.image = UIImage(named: "natureinfo")
        default: markerImage.image = UIImage()
        }
        
        print(marker.tag)
    }
    
    private func naverMapButtonTapped() {
        guard let title = titleLabel.text else { return }
        let urlStr = "nmap://search?query=\(title)"
        guard let encodedStr = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encodedStr)
        else { return }
        UIApplication.shared.open(url, options: [:])
    }
}
