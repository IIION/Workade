//
//  NearbyPlaceView.swift
//  Workade
//
//  Created by ryu hyunsun on 2022/10/21.
//

import UIKit

class NearbyPlaceView: UIView {
    private var introduceBottomConstraints: NSLayoutConstraint!
    private var galleryBottomConstraints: NSLayoutConstraint!
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        // contentInsetAdjustmentBehavior -> safeArea를 ignore
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        return scrollView
    }()
    
    private let contentsContainer: UIView = {
        let contentsContainer = UIView()
        contentsContainer.translatesAutoresizingMaskIntoConstraints = false
        
        return contentsContainer
    }()
    
    private let placeImageView: UIImageView = {
        let imageView = UIImageView()
        // TODO: 임시 배경입니다. 스크롤 시 이미지 애니메이션 효과 적용하며 변경할 예정입니다.
        imageView.backgroundColor = UIColor.gray
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["소개", "갤러리"])
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.rgb(0xD1D1D6),
            NSAttributedString.Key.font: UIFont.customFont(for: .headline)],
                                                for: .normal)
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.theme.primary,
            NSAttributedString.Key.font: UIFont.customFont(for: .headline)],
                                                for: .selected)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(indexChanged(_:)), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        return segmentedControl
    }()
    
    private let segmentUnderLine: UIView = {
        let segmentUnderLine = UIView()
        segmentUnderLine.backgroundColor = UIColor.rgb(0xF2F2F7)
        segmentUnderLine.translatesAutoresizingMaskIntoConstraints = false
        
        return segmentUnderLine
    }()
    
    private let introduceView: IntroduceView = {
        let view = IntroduceView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let galleryView: TempGalleryView = {
        let view = TempGalleryView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        introduceBottomConstraints = introduceView.bottomAnchor.constraint(equalTo: contentsContainer.bottomAnchor, constant: -20)
        galleryBottomConstraints = galleryView.bottomAnchor.constraint(equalTo: contentsContainer.bottomAnchor, constant: -20)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupLayout() {
        // 스크롤 뷰 추가
        addSubview(scrollView)
        let scrollViewGuide = scrollView.contentLayoutGuide
        scrollView.addSubview(contentsContainer)
        
        // 스크롤 뷰에 들어갈 애들
        contentsContainer.addSubview(placeImageView)
        contentsContainer.addSubview(segmentedControl)
        contentsContainer.addSubview(segmentUnderLine)
        contentsContainer.addSubview(introduceView)
        contentsContainer.addSubview(galleryView)
        
        removeSegmentDefaultEffect()
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            contentsContainer.topAnchor.constraint(equalTo: scrollViewGuide.topAnchor),
            contentsContainer.bottomAnchor.constraint(equalTo: scrollViewGuide.bottomAnchor),
            contentsContainer.leadingAnchor.constraint(equalTo: scrollViewGuide.leadingAnchor),
            contentsContainer.trailingAnchor.constraint(equalTo: scrollViewGuide.trailingAnchor),
            contentsContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            placeImageView.topAnchor.constraint(equalTo: contentsContainer.topAnchor),
            placeImageView.leadingAnchor.constraint(equalTo: contentsContainer.leadingAnchor),
            placeImageView.trailingAnchor.constraint(equalTo: contentsContainer.trailingAnchor),
            placeImageView.heightAnchor.constraint(equalToConstant: 420),
            placeImageView.widthAnchor.constraint(equalTo: contentsContainer.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: placeImageView.bottomAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: contentsContainer.leadingAnchor, constant: 20),
            segmentedControl.trailingAnchor.constraint(equalTo: contentsContainer.trailingAnchor, constant: -20),
            segmentedControl.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            segmentUnderLine.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            segmentUnderLine.leadingAnchor.constraint(equalTo: contentsContainer.leadingAnchor),
            segmentUnderLine.trailingAnchor.constraint(equalTo: contentsContainer.trailingAnchor),
            segmentUnderLine.heightAnchor.constraint(equalToConstant: 2)
        ])
        
        NSLayoutConstraint.activate([
            introduceView.topAnchor.constraint(equalTo: segmentUnderLine.bottomAnchor, constant: 20),
            introduceView.leadingAnchor.constraint(equalTo: contentsContainer.leadingAnchor, constant: 20),
            introduceView.trailingAnchor.constraint(equalTo: contentsContainer.trailingAnchor, constant: -20),
            introduceBottomConstraints
        ])
        
        NSLayoutConstraint.activate([
            galleryView.topAnchor.constraint(equalTo: segmentUnderLine.bottomAnchor, constant: 20),
            galleryView.leadingAnchor.constraint(equalTo: contentsContainer.leadingAnchor, constant: 20),
            galleryView.trailingAnchor.constraint(equalTo: contentsContainer.trailingAnchor, constant: -20)
        ])
    }
    
    @objc
    private func indexChanged(_ segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            introduceView.isHidden = false
            galleryView.isHidden = true
            galleryBottomConstraints.isActive = false
            introduceBottomConstraints.isActive = true
        case 1:
            introduceView.isHidden = true
            galleryView.isHidden = false
            introduceBottomConstraints.isActive = false
            galleryBottomConstraints.isActive = true
        default:
            break
        }
    }
    
    private func removeSegmentDefaultEffect() {
        let image = UIImage()
        segmentedControl.setBackgroundImage(image, for: .normal, barMetrics: .default)
        segmentedControl.setBackgroundImage(image, for: .selected, barMetrics: .default)
        segmentedControl.setBackgroundImage(image, for: .highlighted, barMetrics: .default)
        segmentedControl.setDividerImage(
            image,
            forLeftSegmentState: .selected,
            rightSegmentState: .normal,
            barMetrics: .default)
    }
}
