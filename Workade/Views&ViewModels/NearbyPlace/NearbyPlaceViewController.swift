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
    let introduceViewModel: IntroduceViewModel
    
    init(office: Office) {
        self.office = office
        self.nearbyPlaceImageView = NearbyPlaceImageView(office: office)
        self.nearbyPlaceDetailView = NearbyPlaceDetailView(office: office)
        self.introduceViewModel = IntroduceViewModel(url: URL(string: office.introduceURL) ?? URL(string: "")!)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var customNavigationBar = CustomNavigationBar()
    private var defaultScrollYOffset: CGFloat = 0
    
    // Gallery 관련 프로퍼티
    //        let transitionManager = CardTransitionMananger()
    var columnSpacing: CGFloat = 20
    var isLoading: Bool = false
    
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
        
        setupLayout()
        setupCustomNavigationBar()
    }
    
    func setupLayout() {
        view.addSubview(nearbyPlaceImageView)
        NSLayoutConstraint.activate([
            nearbyPlaceImageView.topAnchor.constraint(equalTo: view.topAnchor),
            nearbyPlaceImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nearbyPlaceImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nearbyPlaceImageView.heightAnchor.constraint(equalToConstant: .topSafeArea + 375)
        ])
        
        view.addSubview(segmentedControl)
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: nearbyPlaceImageView.bottomAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: nearbyPlaceImageView.leadingAnchor, constant: 20),
            segmentedControl.trailingAnchor.constraint(equalTo: nearbyPlaceImageView.trailingAnchor, constant: -20),
            segmentedControl.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        view.addSubview(segmentUnderLine)
        NSLayoutConstraint.activate([
            segmentUnderLine.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            segmentUnderLine.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            segmentUnderLine.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            segmentUnderLine.heightAnchor.constraint(equalToConstant: 2)
        ])
        
        view.addSubview(nearbyPlaceDetailView)
        NSLayoutConstraint.activate([
            nearbyPlaceDetailView.topAnchor.constraint(equalTo: segmentUnderLine.bottomAnchor),
            nearbyPlaceDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            nearbyPlaceDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nearbyPlaceDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
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
            //                        scrollView.isScrollEnabled = true
            nearbyPlaceDetailView.introduceView.isHidden = false
            nearbyPlaceDetailView.galleryView.isHidden = true
            nearbyPlaceDetailView.galleryBottomConstraints.isActive = false
            nearbyPlaceDetailView.introduceBottomConstraints.isActive = true
        case 1:
            // 갤러리 누르면 세그먼트 위치로 스크롤 이동.
            nearbyPlaceDetailView.scrollView.isScrollEnabled = false
            nearbyPlaceDetailView.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            // 전체 뷰의 스크롤은 멈춰야함.
            //                        scrollView.isScrollEnabled = false
            // 전체뷰의 스크롤 위치를 이미지가 끝나는 지점으로 맞춰줘야함
            //                        scrollView.setContentOffset(CGPoint(x: 0, y: 315), animated: false)
            nearbyPlaceDetailView.introduceView.isHidden = true
            nearbyPlaceDetailView.galleryView.isHidden = false
            nearbyPlaceDetailView.introduceBottomConstraints.isActive = false
            nearbyPlaceDetailView.galleryBottomConstraints.isActive = true
        default:
            return
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

//        view.backgroundColor = .white
//        nearbyPlaceView.scrollView.delegate = self
//        nearbyPlaceView.delegate = self
//        nearbyPlaceView.detailScrollView.delegate = self
//        navigationController?.isNavigationBarHidden = true
//
//        // GalleryView 델리게이트 위임
//        nearbyPlaceView.galleryView.collectionView.dataSource = self
//        nearbyPlaceView.galleryView.collectionView.delegate = self
//        nearbyPlaceView.galleryView.layout.delegate = self
//
//        setupNearbyPlaceView()
//        setupCustomNavigationBar()
//        setupGalleryView()
//        setupIntroduceView()
//    }
//
//    private func setupGalleryView() {
//        Task {
//            guard let url = URL(string: office.galleryURL) else { return }
//            await galleryViewModel.fetchContent(by: url)
//            nearbyPlaceView.galleryView.collectionView.reloadData()
//        }
//    }
//
//    private func setupIntroduceView() {
//        Task {
//            await introduceViewModel.fetchData()
//        }
//        introduceViewModel.introductions.bind { contents in
//            for content in contents {
//                switch content.type {
//                case "Text":
//                    let label = UILabel()
//                    label.text = content.context
//                    if let font = content.font {
//                        label.font = .customFont(for: CustomTextStyle(rawValue: font) ?? .articleBody)
//                    }
//                    if let color = content.color {
//                        label.textColor = UIColor(named: color)
//                    }
//                    label.lineBreakMode = .byWordWrapping
//                    label.numberOfLines = 0
//                    label.setLineHeight(lineHeight: 12.0)
//                    self.nearbyPlaceView.introduceView.stackView.addArrangedSubview(label)
//                case "Image":
//                    let imageView = UIImageView()
//                    let imageURL = content.context
//                    imageView.translatesAutoresizingMaskIntoConstraints = false
//                    Task {
//                        let image = await self.introduceViewModel.fetchImage(urlString: imageURL)
//                        imageView.image = image
//                        let width = image.size.width
//                        let height = image.size.height
//
//                        imageView.contentMode = .scaleToFill
//                        imageView.layer.cornerRadius = 20
//                        imageView.clipsToBounds = true
//
//                        imageView.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: height/width).isActive = true
//                    }
//                    self.nearbyPlaceView.introduceView.stackView.addArrangedSubview(imageView)
//                default:
//                    break
//                }
//            }
//        }
//    }
//
//    private func setupNearbyPlaceView() {
//        view.addSubview(nearbyPlaceView)
//        NSLayoutConstraint.activate([
//            nearbyPlaceView.topAnchor.constraint(equalTo: view.topAnchor),
//            nearbyPlaceView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            nearbyPlaceView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            nearbyPlaceView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
//        ])
//    }
//}
//extension NearbyPlaceViewController: UIScrollViewDelegate {
//    @objc
//    func clickedCloseButton(sender: UIButton) {
//        self.dismiss(animated: true, completion: nil)
//    }
//
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        let totalOffset = scrollView.contentOffset.y
//        if totalOffset < -.topSafeArea {
//            self.dismiss(animated: true, completion: nil)
//        }
//    }
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let totalOffset = scrollView.contentOffset.y
//        let detailOffset = nearbyPlaceView.detailScrollView.contentOffset.y
//
//        switch scrollView {
//        case nearbyPlaceView.scrollView:
//            if totalOffset > 0 {
//                if totalOffset > 315 {
//                    scrollView.setContentOffset(CGPoint(x: 0, y: 315), animated: false)
//                    // 전체 스크롤 뷰를 막고, 디테일 뷰의 스크롤 뷰를 활성화 시킴.
//                    nearbyPlaceView.scrollView.isScrollEnabled = false
//                    nearbyPlaceView.detailScrollView.isScrollEnabled = true
//                } else {
//                    if nearbyPlaceView.segmentedControl.selectedSegmentIndex == 0 {
//                        nearbyPlaceView.detailScrollView.isScrollEnabled = false
//                    }
//                    customNavigationBar.view.alpha = totalOffset / (.topSafeArea + 259)
//                    nearbyPlaceView.placeImageView.alpha = 1 - (totalOffset / (.topSafeArea + 259))
//                }
//            } else {
//                customNavigationBar.view.alpha = 0
//                nearbyPlaceView.placeImageView.alpha = 1
//            }
//        case nearbyPlaceView.detailScrollView:
//            if detailOffset <= 0 {
//                nearbyPlaceView.detailScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
//                if nearbyPlaceView.segmentedControl.selectedSegmentIndex == 0 {
//                    nearbyPlaceView.scrollView.isScrollEnabled = true
//                }
//            }
//        default:
//            break
//        }
//    }
//}
//
//// GalleryView(collectionView 델리게이트 익스텐션)
//extension NearbyPlaceViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return galleryViewModel.images.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let identifier = GalleryCollectionViewCell.identifier
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? GalleryCollectionViewCell
//        cell?.imageView.image = galleryViewModel.images[indexPath.row]
//        guard let cell = cell else { fatalError() }
//
//        return cell
//    }
//}
//
//extension NearbyPlaceViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
//        let image = galleryViewModel.images[indexPath.row]
//        let viewController = GalleryDetailViewController()
//        viewController.image = image
//        viewController.modalPresentationStyle = .overCurrentContext
//        viewController.transitioningDelegate = transitionManager
//        self.present(viewController, animated: true)
//
//        return true
//    }
//
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        if indexPath.row == galleryViewModel.images.count - 1, galleryViewModel.isCanLoaded {
//            Task { [weak self] in
//                await self?.galleryViewModel.fetchImages()
//                self?.nearbyPlaceView.galleryView.collectionView.reloadData()
//            }
//        }
//    }
//}
//
//extension NearbyPlaceViewController: TwoLineLayoutDelegate {
//    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
//        let image = galleryViewModel.images[indexPath.row]
//        let aspectR = image.size.width / image.size.height
//
//        return (collectionView.frame.width - columnSpacing * 3) / 2 * 1 / aspectR
//    }
//}

import SwiftUI

struct NearbyPlaceViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = NearbyPlaceViewController
    
    func makeUIViewController(context: Context) -> NearbyPlaceViewController {
        return NearbyPlaceViewController(office: Office(officeName: "제주 O-PEACE",
                                                        regionName: "제주도",
                                                        imageURL: "https://raw.githubusercontent.com/IIION/WorkadeData/main/Home/Image/Office/opiece.jpeg",
                                                        introduceURL: "https://raw.githubusercontent.com/IIION/WorkadeData/main/Office/opiece.json",
                                                        galleryURL: "https://raw.githubusercontent.com/IIION/WorkadeData/main/Office/opiecegallery.json",
                                                        latitude: 33.5328984,
                                                        longitude: 126.6311401,
                                                        spots: []))
    }
    
    func updateUIViewController(_ uiViewController: NearbyPlaceViewController, context: Context) {}
}

@available(iOS 13.0.0, *)
struct NearbyPlaceViewControllerPreview: PreviewProvider {
    static var previews: some View {
        NearbyPlaceViewControllerRepresentable()
    }
}
