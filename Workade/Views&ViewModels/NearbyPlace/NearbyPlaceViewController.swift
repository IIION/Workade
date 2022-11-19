//
//  NearbyPlaceView.swift
//  Workade
//
//  Created by ryu hyunsun on 2022/10/19.
//

import UIKit

protocol InnerTouchPresentDelegate: AnyObject {
    func touch(officeModel: OfficeModel)
}

class NearbyPlaceViewController: UIViewController {
    var officeModel: OfficeModel
    let nearbyPlaceImageView: NearbyPlaceImageView
    let nearbyPlaceDetailView: NearbyPlaceDetailView
    let galleryViewModel = GalleryViewModel()
    
    // 스크롤 뷰 하나에서, 세그먼트 컨트롤의 스티키 효과를 주기위해 2가지의 constraints 사용.
    var segmentedControlTopConstraintsToNavbar: NSLayoutConstraint!
    var segmentedControlTopConstraintsToImage: NSLayoutConstraint!
    
    let segmentedControllerHeight: CGFloat = 50
    var customNavigationBarHeight: CGFloat!
    let imageHeight: CGFloat = 375

    init(officeModel: OfficeModel) {
        self.officeModel = officeModel
        self.nearbyPlaceImageView = NearbyPlaceImageView(officeModel: officeModel)
        self.nearbyPlaceDetailView = NearbyPlaceDetailView(officeModel: officeModel)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var customNavigationBar = CustomNavigationBar()
    private var defaultScrollYOffset: CGFloat = 0
    
    // Gallery 관련 프로퍼티
    let transitionManager = CardTransitionMananger()
    var columnSpacing: CGFloat = 20
    var isLoading: Bool = false
    
    lazy var totalScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    let contentsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .theme.background
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton().closeButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(clickedCloseButton), for: .touchUpInside)
        
        return button
    }()
    
    lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = CustomSegmentedControl(items: ["소개", "특징", "갤러리", "주변"])
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.theme.quaternary,
            NSAttributedString.Key.font: UIFont.customFont(for: .headline)],
                                                for: .normal)
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.theme.primary,
            NSAttributedString.Key.font: UIFont.customFont(for: .headline)],
                                                for: .selected)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(indexChanged(_ :)), for: UIControl.Event.valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        segmentedControl.backgroundColor = .white
        
        return segmentedControl
    }()
    
    private let segmentUnderLine: UIView = {
        let segmentUnderLine = UIView()
        segmentUnderLine.backgroundColor = UIColor.theme.quaternary
        segmentUnderLine.translatesAutoresizingMaskIntoConstraints = false
        
        return segmentUnderLine
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .theme.background
        nearbyPlaceImageView.delegate = self
        
        setupDelegate()
        
        setupScrollViewLayout()
        setupLayout()
        setupGalleryView()
        setupCustomNavigationBar()
    }

    func setupDelegate() {
        nearbyPlaceDetailView.galleryView.collectionView.dataSource = self
        nearbyPlaceDetailView.galleryView.collectionView.delegate = self
        nearbyPlaceDetailView.galleryView.layout.delegate = self
        
        totalScrollView.delegate = self
    }
    
    func setupScrollViewLayout() {
        view.addSubview(totalScrollView)
        NSLayoutConstraint.activate([
            totalScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            totalScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            totalScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            totalScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        let scrollViewContentsLayoutGuide = totalScrollView.contentLayoutGuide
        totalScrollView.addSubview(contentsContainerView)
        NSLayoutConstraint.activate([
            contentsContainerView.topAnchor.constraint(equalTo: scrollViewContentsLayoutGuide.topAnchor),
            contentsContainerView.leadingAnchor.constraint(equalTo: scrollViewContentsLayoutGuide.leadingAnchor),
            contentsContainerView.trailingAnchor.constraint(equalTo: scrollViewContentsLayoutGuide.trailingAnchor),
            contentsContainerView.bottomAnchor.constraint(equalTo: scrollViewContentsLayoutGuide.bottomAnchor),
            contentsContainerView.widthAnchor.constraint(equalTo: totalScrollView.widthAnchor)
        ])
    }
    
    func setupLayout() {
        contentsContainerView.addSubview(nearbyPlaceImageView)
        
        // constraint 깨지는 것을 방지하기 위해 우선순위 높이기.
        let imageViewTopConstraint = nearbyPlaceImageView.imageView.topAnchor.constraint(equalTo: view.topAnchor)
        imageViewTopConstraint.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            imageViewTopConstraint,
            nearbyPlaceImageView.topAnchor.constraint(equalTo: contentsContainerView.topAnchor),
            nearbyPlaceImageView.leadingAnchor.constraint(equalTo: contentsContainerView.leadingAnchor),
            nearbyPlaceImageView.trailingAnchor.constraint(equalTo: contentsContainerView.trailingAnchor),
            nearbyPlaceImageView.heightAnchor.constraint(equalToConstant: .topSafeArea + imageHeight)
        ])

        contentsContainerView.addSubview(nearbyPlaceDetailView)
        NSLayoutConstraint.activate([
            nearbyPlaceDetailView.topAnchor.constraint(equalTo: nearbyPlaceImageView.bottomAnchor, constant: 52),
            nearbyPlaceDetailView.bottomAnchor.constraint(equalTo: contentsContainerView.bottomAnchor),
            nearbyPlaceDetailView.leadingAnchor.constraint(equalTo: contentsContainerView.leadingAnchor),
            nearbyPlaceDetailView.trailingAnchor.constraint(equalTo: contentsContainerView.trailingAnchor),
            contentsContainerView.bottomAnchor.constraint(equalTo: nearbyPlaceDetailView.contensContainerView.bottomAnchor)
        ])
        
        segmentedControlTopConstraintsToImage = segmentedControl.topAnchor.constraint(equalTo: nearbyPlaceImageView.bottomAnchor)
        contentsContainerView.addSubview(segmentedControl)
        NSLayoutConstraint.activate([
            segmentedControlTopConstraintsToImage,
            segmentedControl.leadingAnchor.constraint(equalTo: contentsContainerView.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: contentsContainerView.trailingAnchor),
            segmentedControl.heightAnchor.constraint(equalToConstant: 50)
        ])

        contentsContainerView.addSubview(segmentUnderLine)
        NSLayoutConstraint.activate([
            segmentUnderLine.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            segmentUnderLine.leadingAnchor.constraint(equalTo: contentsContainerView.leadingAnchor),
            segmentUnderLine.trailingAnchor.constraint(equalTo: contentsContainerView.trailingAnchor),
            segmentUnderLine.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
    
    private func setupCustomNavigationBar() {
        customNavigationBar = CustomNavigationBar(titleText: officeModel.officeName, rightButtonImage: SFSymbol.mapInNavigation.image)
        customNavigationBar.officeModel = officeModel
        customNavigationBar.dismissAction = { [weak self] in self?.presentingViewController?.dismiss(animated: true)}
        customNavigationBar.delegate = self
        customNavigationBar.view.alpha = 0
        customNavigationBarHeight = customNavigationBar.view.bounds.height
        
        view.addSubview(customNavigationBar.view)
        
        // 스크롤시, 스티키한 효과를 주기위해 세그먼트 컨트롤러를 네브바 아래에 붙을 수 있도록 설정.
        segmentedControlTopConstraintsToNavbar = segmentedControl.topAnchor.constraint(equalTo: customNavigationBar.view.bottomAnchor)
        segmentedControlTopConstraintsToNavbar.priority = .defaultHigh
        
        view.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: .topSafeArea + 8),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.widthAnchor.constraint(equalToConstant: 44),
            closeButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc
    func clickedCloseButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func indexChanged(_ segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            totalScrollView.isScrollEnabled = true
            nearbyPlaceImageView.isHidden = false
            nearbyPlaceDetailView.introduceView.isHidden = false
            nearbyPlaceDetailView.featureView.isHidden = true
            nearbyPlaceDetailView.galleryView.isHidden = true
            nearbyPlaceDetailView.mapView.isHidden = true
            nearbyPlaceDetailView.galleryBottomConstraints.isActive = false
            nearbyPlaceDetailView.featureBottomConstraints.isActive = false
            nearbyPlaceDetailView.introduceBottomConstraints.isActive = true
            nearbyPlaceDetailView.mapBottomConstrains.isActive = false
        case 1:
            totalScrollView.isScrollEnabled = true
            nearbyPlaceImageView.isHidden = false
            nearbyPlaceDetailView.introduceView.isHidden = true
            nearbyPlaceDetailView.featureView.isHidden = false
            nearbyPlaceDetailView.galleryView.isHidden = true
            nearbyPlaceDetailView.mapView.isHidden = true
            nearbyPlaceDetailView.introduceBottomConstraints.isActive = false
            nearbyPlaceDetailView.featureBottomConstraints.isActive = true
            nearbyPlaceDetailView.galleryBottomConstraints.isActive = false
            nearbyPlaceDetailView.mapBottomConstrains.isActive = false
        case 2:
            totalScrollView.isScrollEnabled = false
            nearbyPlaceImageView.isHidden = true
            // 전체뷰의 스크롤 위치를 이미지가 끝나는 지점으로 맞춰줘야함
            totalScrollView.setContentOffset(CGPoint(x: 0, y: 315), animated: false)
            nearbyPlaceDetailView.introduceView.isHidden = true
            nearbyPlaceDetailView.featureView.isHidden = true
            nearbyPlaceDetailView.galleryView.isHidden = false
            nearbyPlaceDetailView.mapView.isHidden = true
            nearbyPlaceDetailView.mapBottomConstrains.isActive = false
            nearbyPlaceDetailView.galleryBottomConstraints.isActive = true
            nearbyPlaceDetailView.introduceBottomConstraints.isActive = false
            nearbyPlaceDetailView.featureBottomConstraints.isActive = false
        case 3:
            totalScrollView.isScrollEnabled = false
            nearbyPlaceImageView.isHidden = true
            totalScrollView.setContentOffset(CGPoint(x: 0, y: 315), animated: false)
            nearbyPlaceDetailView.introduceView.isHidden = true
            nearbyPlaceDetailView.featureView.isHidden = true
            nearbyPlaceDetailView.galleryView.isHidden = true
            nearbyPlaceDetailView.mapView.isHidden = false
            nearbyPlaceDetailView.introduceBottomConstraints.isActive = false
            nearbyPlaceDetailView.featureBottomConstraints.isActive = false
            nearbyPlaceDetailView.galleryBottomConstraints.isActive = false
            nearbyPlaceDetailView.mapBottomConstrains.isActive = true
        default:
            return
        }
    }
    
    /// 갤러리 사진들 불러오는 함수
    private func setupGalleryView() {
        Task {
            do {
                try await galleryViewModel.requestGalleryData(from: officeModel.galleryURL)
                nearbyPlaceDetailView.galleryView.collectionView.reloadData()
            } catch {
                let error = error as? NetworkError ?? .unknownError
                print(error.message)
            }
        }
    }
}

extension NearbyPlaceViewController: InnerTouchPresentDelegate {
    func touch(officeModel: OfficeModel) {
        let viewController = MapViewController(office: officeModel)
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }
}
// GalleryView(collectionView 델리게이트 익스텐션)
extension NearbyPlaceViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return galleryViewModel.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = GalleryCollectionViewCell.identifier
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? GalleryCollectionViewCell
        cell?.imageView.image = galleryViewModel.images[indexPath.row]
        guard let cell = cell else { fatalError() }
        
        return cell
    }
}

extension NearbyPlaceViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let image = galleryViewModel.images[indexPath.row]
        let viewController = GalleryDetailViewController()
        viewController.image = image
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.transitioningDelegate = transitionManager
        self.present(viewController, animated: true)
        
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == galleryViewModel.images.count - 1, galleryViewModel.isCanLoaded {
            Task { [weak self] in
                await self?.galleryViewModel.fetchImages()
                self?.nearbyPlaceDetailView.galleryView.collectionView.reloadData()
            }
        }
    }
}

extension NearbyPlaceViewController: TwoLineLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let image = galleryViewModel.images[indexPath.row]
        let aspectR = image.size.width / image.size.height
        
        return (collectionView.frame.width - columnSpacing * 3) / 2 * 1 / aspectR
    }
}

extension NearbyPlaceViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let totalOffset = scrollView.contentOffset.y
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            if totalOffset < -.topSafeArea {
                self.dismiss(animated: true, completion: nil)
            }
        default:
            break
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let totalOffset = scrollView.contentOffset.y
        
        switch scrollView {
        case totalScrollView:
            if totalOffset > 0 {
                customNavigationBar.view.alpha = totalOffset / (.topSafeArea + 259)
                nearbyPlaceImageView.alpha = 1 - (totalOffset / (.topSafeArea + 259))
                // 이미지 뷰의 크기 + safeareator + segmentcontrol크기 + 네비게이션 바 위치.
                if totalOffset > nearbyPlaceImageView.imageView.bounds.height + segmentedControllerHeight + .topSafeArea + customNavigationBarHeight {
                    segmentedControlTopConstraintsToImage.isActive = false
                    segmentedControlTopConstraintsToNavbar.isActive = true
                } else {
                    segmentedControlTopConstraintsToImage.isActive = true
                    segmentedControlTopConstraintsToNavbar.isActive = false
                }
            } else {
                customNavigationBar.view.alpha = 0
                nearbyPlaceImageView.alpha = 1
            }
        default:
            break
        }
    }
}
