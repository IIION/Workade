//
//  LocationButton.swift
//  Workade
//
//  Created by Hong jeongmin on 2022/11/22.
//

import UIKit

// 임시 Enum 추후 삭제 예정
enum TestRegion: String, Hashable {
    case seoul = "서울"
    case incheon = "인천"
    case gwangju = "광주"
    case daegu = "대구"
    case ulsan = "울산"
    case busan = "부산"
    case gyeonggi = "경기"
    case gangwon = "강원"
    case chungcheongbuk = "충북"
    case chungcheongnam = "충남"
    case jeollabuk = "전북"
    case jeollanam = "전남"
    case gyeongsangbuk = "경북"
    case gyeongsangnam = "경남"
}

class LocationButton: UIButton {
    // TODO: ViewModel 에서 region 받아오기
    var region = TestRegion.busan.rawValue
    var selectedRegion: Binder<TestRegion?> = Binder(nil)
    
    // TODO: 인원수 받아오기 ( 뷰컨에서 작업해도 될거같기도 함 )
    let peopleCount = 23
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.text = self.region
        label.font = .customFont(for: .footnote2)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let peopleImage: UIImageView = {
        let peopleImage = UIImageView()
        peopleImage.image = UIImage(systemName: "person.fill")
        peopleImage.tintColor = .theme.primary
        peopleImage.translatesAutoresizingMaskIntoConstraints = false
        
        return peopleImage
    }()
    
    private let peopleCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .theme.primary
        label.font = .customFont(for: .caption2)
        
        return label
    }()
    
    init(region: String) {
        self.region = region
        super.init(frame: .zero)
        
        if selectedRegion.value?.rawValue == region {
            setupSelectLayout()
        } else {
            setupBasicLayout()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBasicLayout() {
        setupButtonScale(scale: 64)
        stackView.addArrangedSubview(peopleImage)
        stackView.addArrangedSubview(peopleCountLabel)
        
        addSubview(locationLabel)
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            locationLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: locationLabel.bottomAnchor),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    private func setupSelectLayout() {
        addSubview(locationLabel)
        NSLayoutConstraint.activate([
            locationLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            locationLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func setupButtonScale(scale: CGFloat) {
        layer.cornerRadius = scale / 2
        
        if scale == 64 {
            backgroundColor = .theme.background
            locationLabel.textColor = .theme.primary
            
            NSLayoutConstraint.activate([
                widthAnchor.constraint(equalToConstant: scale),
                heightAnchor.constraint(equalToConstant: scale)
            ])
        } else {
            backgroundColor = .theme.primary
            locationLabel.textColor = .theme.background
            
            NSLayoutConstraint.activate([
                widthAnchor.constraint(equalToConstant: scale),
                heightAnchor.constraint(equalToConstant: scale)
            ])
        }
    }
}
