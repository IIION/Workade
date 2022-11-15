//
//  NearbyPlaceView.swift
//  Workade
//
//  Created by ryu hyunsun on 2022/10/19.
//

import UIKit

protocol InnerTouchPresentDelegate: AnyObject {
    func touch(office: Office)
}

class NearbyPlaceViewController: UIViewController {
    var office: Office
    let nearbyPlaceImageView: NearbyPlaceImageView
    let nearbyPlaceDetailView: NearbyPlaceDetailView
    let galleryViewModel = GalleryViewModel()
    
    init(office: Office) {
        self.office = office
        self.nearbyPlaceImageView = NearbyPlaceImageView(office: office)
        self.nearbyPlaceDetailView = NearbyPlaceDetailView(office: office)
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
        let segmentedControl = CustomSegmentedControl(items: ["소개", "갤러리"])
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
        setupGalleryView()
        setupLayout()
        setupCustomNavigationBar()
    }
    
    func setupDelegate() {
        nearbyPlaceDetailView.galleryView.collectionView.dataSource = self
        nearbyPlaceDetailView.galleryView.collectionView.delegate = self
        nearbyPlaceDetailView.galleryView.layout.delegate = self
        
        totalScrollView.delegate = self
        nearbyPlaceDetailView.scrollView.delegate = self
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
        NSLayoutConstraint.activate([
            nearbyPlaceImageView.imageView.topAnchor.constraint(equalTo: view.topAnchor),
            nearbyPlaceImageView.topAnchor.constraint(equalTo: contentsContainerView.topAnchor),
            nearbyPlaceImageView.leadingAnchor.constraint(equalTo: contentsContainerView.leadingAnchor),
            nearbyPlaceImageView.trailingAnchor.constraint(equalTo: contentsContainerView.trailingAnchor),
            nearbyPlaceImageView.heightAnchor.constraint(equalToConstant: .topSafeArea + 375)
        ])
        
        contentsContainerView.addSubview(segmentedControl)
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: nearbyPlaceImageView.bottomAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: nearbyPlaceImageView.leadingAnchor, constant: 20),
            segmentedControl.trailingAnchor.constraint(equalTo: nearbyPlaceImageView.trailingAnchor, constant: -20),
            segmentedControl.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        contentsContainerView.addSubview(segmentUnderLine)
        NSLayoutConstraint.activate([
            segmentUnderLine.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            segmentUnderLine.leadingAnchor.constraint(equalTo: contentsContainerView.leadingAnchor),
            segmentUnderLine.trailingAnchor.constraint(equalTo: contentsContainerView.trailingAnchor),
            segmentUnderLine.heightAnchor.constraint(equalToConstant: 2)
        ])
        
        contentsContainerView.addSubview(nearbyPlaceDetailView)
        NSLayoutConstraint.activate([
            nearbyPlaceDetailView.topAnchor.constraint(equalTo: segmentUnderLine.bottomAnchor),
            nearbyPlaceDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            nearbyPlaceDetailView.leadingAnchor.constraint(equalTo: contentsContainerView.leadingAnchor),
            nearbyPlaceDetailView.trailingAnchor.constraint(equalTo: contentsContainerView.trailingAnchor),
            contentsContainerView.bottomAnchor.constraint(equalTo: nearbyPlaceDetailView.contensContainerView.bottomAnchor, constant: 375)
        ])
    }
    
    private func setupCustomNavigationBar() {
        customNavigationBar = CustomNavigationBar(titleText: office.officeName, rightButtonImage: SFSymbol.mapInNavigation.image)
        customNavigationBar.office = office
        customNavigationBar.dismissAction = { [weak self] in self?.presentingViewController?.dismiss(animated: true)}
        customNavigationBar.delegate = self
        customNavigationBar.view.alpha = 0
        
        view.addSubview(customNavigationBar.view)
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
            nearbyPlaceDetailView.scrollView.isScrollEnabled = true
            nearbyPlaceDetailView.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            totalScrollView.isScrollEnabled = true
            nearbyPlaceDetailView.introduceView.isHidden = false
            nearbyPlaceDetailView.galleryView.isHidden = true
            nearbyPlaceDetailView.galleryBottomConstraints.isActive = false
            nearbyPlaceDetailView.introduceBottomConstraints.isActive = true
        case 1:
            // 갤러리 누르면 세그먼트 위치로 스크롤 이동.
            nearbyPlaceDetailView.scrollView.isScrollEnabled = false
            nearbyPlaceDetailView.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            // 전체 뷰의 스크롤은 멈춰야함.
            totalScrollView.isScrollEnabled = false
            // 전체뷰의 스크롤 위치를 이미지가 끝나는 지점으로 맞춰줘야함
            totalScrollView.setContentOffset(CGPoint(x: 0, y: 315), animated: false)
            nearbyPlaceDetailView.introduceView.isHidden = true
            nearbyPlaceDetailView.galleryView.isHidden = false
            nearbyPlaceDetailView.introduceBottomConstraints.isActive = false
            nearbyPlaceDetailView.galleryBottomConstraints.isActive = true
        default:
            return
        }
    }
    
    /// 갤러리 사진들 불러오는 함수
    private func setupGalleryView() {
        Task {
            guard let url = URL(string: office.galleryURL) else { return }
            await galleryViewModel.fetchContent(by: url)
            nearbyPlaceDetailView.galleryView.collectionView.reloadData()
        }
    }
}

extension NearbyPlaceViewController: InnerTouchPresentDelegate {
    func touch(office: Office) {
        let viewController = MapViewController(office: office)
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
        if totalOffset < -.topSafeArea {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let totalOffset = scrollView.contentOffset.y
        let detailOffset = nearbyPlaceDetailView.scrollView.contentOffset.y
        
        switch scrollView {
        case totalScrollView:
            if totalOffset > 0 {
                if totalOffset > 315 {
                    scrollView.setContentOffset(CGPoint(x: 0, y: 315), animated: false)
                    // 전체 스크롤 뷰를 막고, 디테일 뷰의 스크롤 뷰를 활성화 시킴.
                    totalScrollView.isScrollEnabled = false
                    nearbyPlaceDetailView.scrollView.isScrollEnabled = true
                } else {
                    if segmentedControl.selectedSegmentIndex == 0 {
                        nearbyPlaceDetailView.scrollView.isScrollEnabled = false
                    }
                    customNavigationBar.view.alpha = totalOffset / (.topSafeArea + 259)
                    nearbyPlaceImageView.alpha = 1 - (totalOffset / (.topSafeArea + 259))
                }
            } else {
                customNavigationBar.view.alpha = 0
                nearbyPlaceImageView.alpha = 1
            }
        case nearbyPlaceDetailView.scrollView:
            if detailOffset <= 0 {
                nearbyPlaceDetailView.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
                if segmentedControl.selectedSegmentIndex == 0 {
                    totalScrollView.isScrollEnabled = true
                }
            }
        default:
            break
        }
    }
}
