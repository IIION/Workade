//
//  NearbyPlaceView.swift
//  Workade
//
//  Created by ryu hyunsun on 2022/10/19.
//

import UIKit

class NearbyPlaceViewController: UIViewController {
    private let nearbyPlaceView = NearbyPlaceView()
    
    private var customNavigationBar: UIViewController!
    private var defaultScrollYOffset: CGFloat = 0
    let topSafeArea = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 44
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "O - Peace"
        label.textColor = .theme.background
        label.font = .customFont(for: .title1)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var mapButton: UIButton = {
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium, scale: .default)
        
        let button = UIButton()
        button.setImage(UIImage(systemName: "map", withConfiguration: config), for: .normal)
        button.tintColor = .theme.background
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(clickedMapButton(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view = nearbyPlaceView
        view.backgroundColor = .white
        nearbyPlaceView.translatesAutoresizingMaskIntoConstraints = false
        nearbyPlaceView.scrollView.delegate = self
        nearbyPlaceView.detailScrollView.delegate = self
        navigationController?.isNavigationBarHidden = true
        
        setupNearbyPlaceView()
        setupCustomNavigationBar()
        
    }
    
    // TODO: 머지 이후 치콩이 작성한 네비게이션 바로 변경 예정입니다.
    private func setupCustomNavigationBar() {
        customNavigationBar = TempNavigationBar(titleText: titleLabel.text, rightButtonImage: mapButton.currentImage)
        customNavigationBar.view.alpha = 0
        view.addSubview(customNavigationBar.view)
    }
    
    private func setupNearbyPlaceView() {
        view.addSubview(nearbyPlaceView)
        NSLayoutConstraint.activate([
            nearbyPlaceView.topAnchor.constraint(equalTo: view.topAnchor),
            nearbyPlaceView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            nearbyPlaceView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nearbyPlaceView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension NearbyPlaceViewController: UIScrollViewDelegate {
    @objc
    func clickedCloseButton(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    // 지도 뷰로 이동하는 로직 작성 예정
    @objc
    func clickedMapButton(sender: UIButton) {
        print("지도 클릭")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let totalOffset = scrollView.contentOffset.y
        let detailOffset = nearbyPlaceView.detailScrollView.contentOffset.y
        
        switch scrollView {
        case nearbyPlaceView.scrollView:
            if totalOffset > 0 {
                if totalOffset > 315 {
                    scrollView.setContentOffset(CGPoint(x: 0, y: 315), animated: false)
                    // 전체 스크롤 뷰를 막고, 디테일 뷰의 스크롤 뷰를 활성화 시킴.
                    nearbyPlaceView.scrollView.isScrollEnabled = false
                    nearbyPlaceView.detailScrollView.isScrollEnabled = true
                }
                else {
                    if nearbyPlaceView.segmentedControl.selectedSegmentIndex == 0 {
                        nearbyPlaceView.detailScrollView.isScrollEnabled = false
                    }
                    customNavigationBar.view.alpha = totalOffset / (topSafeArea + 259)
                    nearbyPlaceView.placeImageView.alpha = 1 - (totalOffset / (topSafeArea + 259))
                }
            } else {
                customNavigationBar.view.alpha = 0
                nearbyPlaceView.placeImageView.alpha = 1
            }
        case nearbyPlaceView.detailScrollView:
            if detailOffset <= 0 {
                nearbyPlaceView.detailScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
                if nearbyPlaceView.segmentedControl.selectedSegmentIndex == 0 {
                    nearbyPlaceView.scrollView.isScrollEnabled = true
                }
            }
        default:
            break
            
        }
        
    }
}
