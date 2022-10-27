//
//  NearbyPlaceView.swift
//  Workade
//
//  Created by ryu hyunsun on 2022/10/19.
//

import UIKit

class NearbyPlaceViewController: UIViewController {
    var office: Office
    let nearbyPlaceView = NearbyPlaceView()
    
    init(office: Office) {
        self.office = office
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var customNavigationBar: UIViewController!
    private var defaultScrollYOffset: CGFloat = 0
    let topSafeArea = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 44
    
    // Gallery 관련 프로퍼티
    let galleryVM = GalleryViewModel(url: URL(string: "https://raw.githubusercontent.com/IIION/WorkadeData/main/Office/opiecegallery.json")!)
    let transitionManager = CardTransitionMananger()
    var columnSpacing: CGFloat = 20
    var isLoading: Bool = false
    
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
        view.backgroundColor = .white
        nearbyPlaceView.translatesAutoresizingMaskIntoConstraints = false
        nearbyPlaceView.scrollView.delegate = self
        nearbyPlaceView.detailScrollView.delegate = self
        navigationController?.isNavigationBarHidden = true
        
        // GalleryView 델리게이트 위임
        nearbyPlaceView.galleryView.collectionView.dataSource = self
        nearbyPlaceView.galleryView.collectionView.delegate = self
        nearbyPlaceView.galleryView.layout.delegate = self
        
        setupNearbyPlaceView()
        setupCustomNavigationBar()
        
        // GalleryView 패치
        Task {
            await galleryVM.fetchImages()
            nearbyPlaceView.galleryView.collectionView.reloadData()
        }
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
                } else {
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

// GalleryView(collectionView 델리게이트 익스텐션)
extension NearbyPlaceViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return galleryVM.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = GalleryCollectionViewCell.identifier
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? GalleryCollectionViewCell
        cell?.imageView.image = galleryVM.images[indexPath.row]
        guard let cell = cell else { fatalError() }
        
        return cell
    }
}

extension NearbyPlaceViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let image = galleryVM.images[indexPath.row]
        let viewController = GalleryDetailViewController()
        viewController.image = image
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.transitioningDelegate = transitionManager
        self.present(viewController, animated: true)
        return true
    }
}

extension NearbyPlaceViewController: TwoLineLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let image = galleryVM.images[indexPath.row]
        let aspectR = image.size.width / image.size.height
        
        return (collectionView.frame.width - columnSpacing * 3) / 2 * 1 / aspectR
    }
}
