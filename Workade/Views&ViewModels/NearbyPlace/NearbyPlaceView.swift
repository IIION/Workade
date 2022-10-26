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
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private let contentsContainer: UIView = {
        let contentsContainer = UIView()
        contentsContainer.translatesAutoresizingMaskIntoConstraints = false
        
        return contentsContainer
    }()
    
    private let placeImageContainer: UIView = {
        let placeImageContainer = UIView()
        placeImageContainer.translatesAutoresizingMaskIntoConstraints = false
        
        return placeImageContainer
    }()
    
    private let placeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.gray
        imageView.image = UIImage(named: "officeImage_test")
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = CustomSegmentedControl(items: ["소개", "갤러리"])
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.rgb(0xD1D1D6),
            NSAttributedString.Key.font: UIFont.customFont(for: .headline)],
                                                for: .normal)
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.theme.primary,
            NSAttributedString.Key.font: UIFont.customFont(for: .headline)],
                                                for: .selected)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(indexChanged(_ :)), for: UIControl.Event.valueChanged)
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
        
        // 스크롤 뷰의 영역을 컨텐츠 크기에 따라 dynamic하게 변경하기 위한 설정
        introduceBottomConstraints = introduceView.bottomAnchor.constraint(equalTo: contentsContainer.bottomAnchor, constant: -20)
        galleryBottomConstraints = galleryView.bottomAnchor.constraint(equalTo: contentsContainer.bottomAnchor, constant: -20)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupLayout() {
        setupScrollViewLayout()
        setupNearbyPlaceDetailLayout()
    }
    
    private func setupScrollViewLayout() {
        addSubview(scrollView)
        let scrollViewGuide = scrollView.contentLayoutGuide
        
        // priority 설정을 통해,
        let placeImageViewTopConstraint = placeImageView.topAnchor.constraint(equalTo: topAnchor)
        // layout이 깨지는 것을 방지하기 위한 우선순위 설정
        placeImageViewTopConstraint.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        scrollView.addSubview(contentsContainer)
        NSLayoutConstraint.activate([
            contentsContainer.topAnchor.constraint(equalTo: scrollViewGuide.topAnchor),
            contentsContainer.bottomAnchor.constraint(equalTo: scrollViewGuide.bottomAnchor),
            contentsContainer.leadingAnchor.constraint(equalTo: scrollViewGuide.leadingAnchor),
            contentsContainer.trailingAnchor.constraint(equalTo: scrollViewGuide.trailingAnchor),
            contentsContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        contentsContainer.addSubview(placeImageContainer)
        NSLayoutConstraint.activate([
            placeImageContainer.topAnchor.constraint(equalTo: contentsContainer.topAnchor),
            placeImageContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            placeImageContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            placeImageContainer.heightAnchor.constraint(equalToConstant: 420)
        ])
        
        contentsContainer.addSubview(placeImageView)
        NSLayoutConstraint.activate([
            placeImageViewTopConstraint,
            placeImageView.bottomAnchor.constraint(equalTo: placeImageContainer.bottomAnchor),
            placeImageView.leadingAnchor.constraint(equalTo: placeImageContainer.leadingAnchor),
            placeImageView.trailingAnchor.constraint(equalTo: placeImageContainer.trailingAnchor),
            // heightAnchor 설정을 통해, 세로가 긴 이미지가 들어올때 이미지 영역 깨지는걸 방지.
            placeImageView.heightAnchor.constraint(greaterThanOrEqualTo: placeImageContainer.heightAnchor)
        ])
    }
    
    private func setupNearbyPlaceDetailLayout() {
        contentsContainer.addSubview(segmentedControl)
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: placeImageContainer.bottomAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: contentsContainer.leadingAnchor, constant: 20),
            segmentedControl.trailingAnchor.constraint(equalTo: contentsContainer.trailingAnchor, constant: -20),
            segmentedControl.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        contentsContainer.addSubview(segmentUnderLine)
        NSLayoutConstraint.activate([
            segmentUnderLine.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            segmentUnderLine.leadingAnchor.constraint(equalTo: contentsContainer.leadingAnchor),
            segmentUnderLine.trailingAnchor.constraint(equalTo: contentsContainer.trailingAnchor),
            segmentUnderLine.heightAnchor.constraint(equalToConstant: 2)
        ])
        
        contentsContainer.addSubview(introduceView)
        NSLayoutConstraint.activate([
            introduceView.topAnchor.constraint(equalTo: segmentUnderLine.bottomAnchor, constant: 20),
            introduceView.leadingAnchor.constraint(equalTo: contentsContainer.leadingAnchor, constant: 20),
            introduceView.trailingAnchor.constraint(equalTo: contentsContainer.trailingAnchor, constant: -20),
            introduceBottomConstraints
        ])
        
        contentsContainer.addSubview(galleryView)
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
}
