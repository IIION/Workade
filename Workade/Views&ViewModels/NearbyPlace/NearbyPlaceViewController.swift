//
//  NearbyPlaceView.swift
//  Workade
//
//  Created by ryu hyunsun on 2022/10/19.
//

import UIKit

class NearbyPlaceViewController: UIViewController {
    var office: Office
    //    let nearbyPlaceView: NearbyPlaceView
    let nearbyPlaceImageView: NearbyPlaceImageView
    let galleryViewModel = GalleryViewModel()
    let introduceViewModel: IntroduceViewModel
    
    init(office: Office) {
        self.office = office
        self.nearbyPlaceImageView = NearbyPlaceImageView(office: office)
        self.introduceViewModel = IntroduceViewModel(url: URL(string: office.introduceURL) ?? URL(string: "")!)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var customNavigationBar = CustomNavigationBar()
    private var defaultScrollYOffset: CGFloat = 0
    
    // Gallery 관련 프로퍼티
    //    let transitionManager = CardTransitionMananger()
    var columnSpacing: CGFloat = 20
    var isLoading: Bool = false
    
    lazy var closeButton: UIButton = {
        let button = UIButton().closeButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(clickedCloseButton(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
    func setupLayout() {
        view.addSubview(nearbyPlaceImageView)
        NSLayoutConstraint.activate([
            nearbyPlaceImageView.topAnchor.constraint(equalTo: view.topAnchor),
            nearbyPlaceImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nearbyPlaceImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nearbyPlaceImageView.heightAnchor.constraint(equalToConstant: .topSafeArea + 375)
        ])
        
        view.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: .topSafeArea + 8),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.widthAnchor.constraint(equalToConstant: 44),
            closeButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc
    func clickedCloseButton(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
