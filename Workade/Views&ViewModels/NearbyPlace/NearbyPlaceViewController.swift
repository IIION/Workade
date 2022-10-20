//
//  NearbyPlaceView.swift
//  Workade
//
//  Created by ryu hyunsun on 2022/10/19.
//

import UIKit

class NearbyPlaceViewController: UIViewController {
    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["소개", "갤러리"])
        // TODO: 폰트 컬러, 폰트 사이즈는 머지 이후 작업 하도록 하겠습니다.
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.gray,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .semibold)],
                                                for: .normal)
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .semibold)],
                                                for: .selected)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(indexChanged(_:)), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        return segmentedControl
    }()
    
    private let introduceView: IntroduceView = {
        let view = IntroduceView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let galleryView: TempGalleryView = {
        let view = TempGalleryView()
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let segmentUnderLine: UIView = {
        let segmentUnderLine = UIView()
        segmentUnderLine.backgroundColor = .systemGray5
        segmentUnderLine.translatesAutoresizingMaskIntoConstraints = false
        
        return segmentUnderLine
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
    }
    
    // 레이아웃 설정.
    private func setupLayout() {
        view.addSubview(segmentedControl)
        view.addSubview(segmentUnderLine)
        view.addSubview(galleryView)
        view.addSubview(introduceView)
        
        removeSegmentBackground()
        removeSegmentDivider()
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            segmentedControl.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            segmentUnderLine.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            segmentUnderLine.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            segmentUnderLine.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            segmentUnderLine.heightAnchor.constraint(equalToConstant: 2)
        ])
        
        NSLayoutConstraint.activate([
            introduceView.topAnchor.constraint(equalTo: segmentUnderLine.bottomAnchor, constant: 10),
            introduceView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            introduceView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            introduceView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            galleryView.topAnchor.constraint(equalTo: segmentUnderLine.bottomAnchor, constant: 10),
            galleryView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            galleryView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            galleryView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // segmented controller 액션.
    @objc
    private func indexChanged(_ segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            introduceView.alpha = 1
            galleryView.alpha = 0
            
        case 1:
            introduceView.alpha = 0
            galleryView.alpha = 1
            
        default:
            break
        }
    }
    
    // segmented controller 배경 없애기.
    private func removeSegmentBackground() {
        let image = UIImage()
        segmentedControl.setBackgroundImage(image, for: .normal, barMetrics: .default)
        segmentedControl.setBackgroundImage(image, for: .selected, barMetrics: .default)
        segmentedControl.setBackgroundImage(image, for: .highlighted, barMetrics: .default)
    }
    
    private func removeSegmentDivider() {
        let image = UIImage()
        segmentedControl.setDividerImage(
            image,
            forLeftSegmentState: .selected,
            rightSegmentState: .normal,
            barMetrics: .default)
    }
}
