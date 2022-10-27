//
//  OfficeCollectionViewCell.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/10/20.
//

import UIKit

/// 오피스를 나열한 컬렉션뷰의 셀
final class OfficeCollectionViewCell: UICollectionViewCell {
    var office: Office?
    var task: Task<Void, Error>?
    
    weak var delegate: CollectionViewCellDelegate?
    
    private lazy var backgroundImageView: CellImageView = {
        let imageView = CellImageView(bounds: bounds)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var mapButton: UIButton = {
        let button = UIButton()
        let image = SFSymbol.mapInCell.image
        button.setImage(image, for: .normal)
        button.layer.cornerRadius = 18
        button.layer.backgroundColor = UIColor.black.withAlphaComponent(0.4).cgColor
        button.addTarget(self, action: #selector(tapMapButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let regionNameLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(for: .subHeadline)
        label.textColor = .white
        
        return label
    }()
    
    private let officeNameLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(for: .title3)
        label.textColor = .white
        
        return label
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.addArrangedSubview(regionNameLabel)
        stackView.addArrangedSubview(officeNameLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    // 이미지를 nil로 처리해도 빠른 스크롤의 경우 이미지 꼬임 현상을 완벽하게 해결하진 못합니다.
    // 재사용 셀 큐를 지난후 prepare단계 때 task를 취소시켜줌으로써, 이미지 꼬임 현상을 완벽하게 막을 수 있습니다.
    // 주의 - prepareForReuse 안에는 셀을 구성하는 컨텐트(컴포넌트 등)의 값은 핸들링하지않는 것을 공식문서에서 권장합니다.
    override func prepareForReuse() {
        task?.cancel()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayer()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(office: Office) {
        self.office = office
        regionNameLabel.text = office.regionName
        officeNameLabel.text = office.officeName
        // 이렇게 최초 구성 이미지를 nil로 해주면, 빠른 스크롤 시에 이전 이미지가 들어가있는 이미지 꼬임 현상을 다소 막아줄 수 있습니다. 그 후 불러와진 이미지가 정상적으로 자리잡게 됩니다.
        backgroundImageView.image = nil
        task = Task {
            await backgroundImageView.setImageURL(title: office.officeName, url: office.imageURL)
        }
    }
    
    @objc
    func tapMapButton() {
        guard let office = office else { return }
        delegate?.didTapMapButton(office: office)
    }
}

// MARK: UI setup 관련 Methods
private extension OfficeCollectionViewCell {
    func setupLayer() {
        self.layer.cornerRadius = 12
    }
    
    func setupLayout() {
        contentView.addSubview(backgroundImageView)
        contentView.addSubview(mapButton)
        contentView.addSubview(titleStackView)
        
        NSLayoutConstraint.activate([
            backgroundImageView.widthAnchor.constraint(equalTo: widthAnchor),
            backgroundImageView.heightAnchor.constraint(equalTo: heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            mapButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            mapButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            mapButton.widthAnchor.constraint(equalToConstant: 36),
            mapButton.heightAnchor.constraint(equalToConstant: 36)
        ])
        
        NSLayoutConstraint.activate([
            titleStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
}
