//
//  NearbyPlaceView.swift
//  Workade
//
//  Created by ryu hyunsun on 2022/10/19.
//

import Foundation
import UIKit

class NearbyPlaceViewController: UIViewController {
    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["소개", "갤러리"])
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
    
    private let stackViewUnderLine: UIView = {
        let stackViewUnderLine = UIView()
        stackViewUnderLine.backgroundColor = .gray
        stackViewUnderLine.translatesAutoresizingMaskIntoConstraints = false
        
        return stackViewUnderLine
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
    }
    
    // 레이아웃 설정.
    private func setupLayout() {
        view.addSubview(segmentedControl)
        view.addSubview(stackViewUnderLine)
        view.addSubview(galleryView)
        view.addSubview(introduceView)
        
        removeSegmentBackgroundAndDivider()
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            segmentedControl.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            stackViewUnderLine.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10),
            stackViewUnderLine.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackViewUnderLine.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackViewUnderLine.heightAnchor.constraint(equalToConstant: 2)
        ])
        
        NSLayoutConstraint.activate([
            introduceView.topAnchor.constraint(equalTo: stackViewUnderLine.bottomAnchor, constant: 10),
            introduceView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            introduceView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            introduceView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            galleryView.topAnchor.constraint(equalTo: stackViewUnderLine.bottomAnchor, constant: 10),
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
    private func removeSegmentBackgroundAndDivider() {
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
