//
//  NearbyPlaceView.swift
//  Workade
//
//  Created by ryu hyunsun on 2022/10/19.
//

import UIKit

class NearbyPlaceViewController: UIViewController {
    var office: Office
    let nearbyPlaceView: NearbyPlaceView
    let galleryViewModel: GalleryViewModel
    let introduceVM: IntroduceViewModel
    
    init(office: Office) {
        self.office = office
        self.nearbyPlaceView = NearbyPlaceView(office: office)
        self.galleryViewModel = GalleryViewModel()
        self.introduceVM = IntroduceViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var customNavigationBar: CustomNavigationBar!
    private var defaultScrollYOffset: CGFloat = 0
    let topSafeArea = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 44
    
    // Gallery 관련 프로퍼티
    let transitionManager = CardTransitionMananger()
    var columnSpacing: CGFloat = 20
    var isLoading: Bool = false
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "O - Peace"
        label.textColor = .theme.background
        label.font = .customFont(for: .title1)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // FIXME: 현재 안 쓰는 버튼처럼 보이는데 일단 주석 남깁니다.
    private lazy var mapButton: UIButton = {
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium, scale: .default)
        
        let button = UIButton()
        button.setImage(UIImage(systemName: "map", withConfiguration: config), for: .normal)
        button.tintColor = .theme.background
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(clickedMapButton(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton().closeButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(clickedCloseButton(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        nearbyPlaceView.translatesAutoresizingMaskIntoConstraints = false
        nearbyPlaceView.scrollView.delegate = self
        nearbyPlaceView.delegate = self
        nearbyPlaceView.detailScrollView.delegate = self
        navigationController?.isNavigationBarHidden = true
        
        // GalleryView 델리게이트 위임
        nearbyPlaceView.galleryView.collectionView.dataSource = self
        nearbyPlaceView.galleryView.collectionView.delegate = self
        nearbyPlaceView.galleryView.layout.delegate = self
        
        setupOfficeTitle()
        setupNearbyPlaceView()
        setupCustomNavigationBar()
        setupGalleryView()
        setupIntroduceView()
    }
    
    private func setupOfficeTitle() {
        titleLabel.text = office.officeName
    }
    
    private func setupGalleryView() {
        Task {
            try await galleryViewModel.fetchGalleryData(urlString: office.galleryURL)
            nearbyPlaceView.galleryView.collectionView.reloadData()
        }
    }
    
    private func setupIntroduceView() {
        introduceVM.requestOfficeDetailData(urlString: office.introduceURL)
        introduceVM.introductions.bind { contents in
            for content in contents {
                switch content.type {
                case "Text":
                    let label = UILabel()
                    label.text = content.content
                    if let font = content.font {
                        label.font = .customFont(for: CustomTextStyle(rawValue: font) ?? .articleBody)
                    }
                    if let color = content.color {
                        label.textColor = UIColor(named: color)
                    }
                    label.lineBreakMode = .byWordWrapping
                    label.numberOfLines = 0
                    label.setLineHeight(lineHeight: 12.0)
                    self.nearbyPlaceView.introduceView.stackView.addArrangedSubview(label)
                case "Image":
                    let imageView = UIImageView()
                    let imageURL = content.content
                    imageView.translatesAutoresizingMaskIntoConstraints = false
                    Task {
                        let image = try await self.introduceVM.fetchImage(urlString: imageURL)
                        imageView.image = image
                        let width = image.size.width
                        let height = image.size.height

                        imageView.contentMode = .scaleToFill
                        imageView.layer.cornerRadius = 20
                        imageView.clipsToBounds = true

                        imageView.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: height/width).isActive = true
                    }
                    self.nearbyPlaceView.introduceView.stackView.addArrangedSubview(imageView)
                default:
                    break
                }
            }
        }
    }
    
    private func setupCustomNavigationBar() {
        // TODO: rightButtonImage에 지도 이미지 넣을 예정입니다. 현재 지도로 바로 이동이 힘들어 빈 이미지로 올립니다.
        customNavigationBar = CustomNavigationBar(titleText: titleLabel.text, rightButtonImage: UIImage())
        customNavigationBar.dismissAction = { [weak self] in self?.presentingViewController?.dismiss(animated: true)}
        customNavigationBar.view.alpha = 0
        view.addSubview(customNavigationBar.view)
        
        view.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: topSafeArea + 8),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.widthAnchor.constraint(equalToConstant: 44),
            closeButton.heightAnchor.constraint(equalToConstant: 44)
        ])
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
    // TODO: 지도 뷰로 이동하는 로직 작성 예정
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
                self?.nearbyPlaceView.galleryView.collectionView.reloadData()
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

extension NearbyPlaceViewController: InnerTouchPresentDelegate {
    func touch(office: Office) {
        let viewController = MapViewController(office: office)
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }
}
