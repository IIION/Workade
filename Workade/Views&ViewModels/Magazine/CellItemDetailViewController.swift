//
//  TipItemDetailViewController.swift
//  Workade
//
//  Created by Hong jeongmin on 2022/10/22.
//

import UIKit

class CellItemDetailViewController: UIViewController {
    var magazine: Magazine
    let detailViewModel = MagazineDetailViewModel()
    
    private var defaultScrollYOffset: CGFloat = 0
    let topSafeArea = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 44
    private var bottomConstraints: NSLayoutConstraint!
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private let contentsContainer: UIView = {
        let contentsContainer = UIView()
        contentsContainer.translatesAutoresizingMaskIntoConstraints = false
        
        return contentsContainer
    }()
    
    let titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let imageContainer: UIView = {
        let imageContainer = UIView()
        imageContainer.translatesAutoresizingMaskIntoConstraints = false
        
        return imageContainer
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton().closeButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(clickedCloseButton(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .theme.background
        label.font = .customFont(for: .title1)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var bookmarkButton: UIButton = {
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium, scale: .default)
        
        let button = UIButton()
        button.tintColor = .theme.background
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(clickedBookmarkButton(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var magazineDetailView: MagazineDetailView = {
        let view = MagazineDetailView(magazine: self.magazine)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private var customNavigationBar = CustomNavigationBar()
    
    init(magazine: Magazine) {
        self.magazine = magazine
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .theme.background
        titleLabel.text = magazine.title
        Task {
            await titleImageView.setImageURL(magazine.imageURL)
        }
        
        bottomConstraints = magazineDetailView.bottomAnchor.constraint(equalTo: contentsContainer.bottomAnchor)
        scrollView.delegate = self
        
        setupBookmarkImage()
        setupCustomNavigationBar()
        setupScrollViewLayout()
        setupLayout()
    }
    
    func setupLayout() {
        view.addSubview(customNavigationBar.view)
        
        contentsContainer.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: topSafeArea + 8),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.widthAnchor.constraint(equalToConstant: 44),
            closeButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        contentsContainer.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: titleImageView.leadingAnchor, constant: 20),
            titleLabel.bottomAnchor.constraint(equalTo: titleImageView.bottomAnchor, constant: -20)
        ])
        
        contentsContainer.addSubview(bookmarkButton)
        NSLayoutConstraint.activate([
            bookmarkButton.trailingAnchor.constraint(equalTo: titleImageView.trailingAnchor, constant: -20),
            bookmarkButton.bottomAnchor.constraint(equalTo: titleImageView.bottomAnchor, constant: -20),
            bookmarkButton.widthAnchor.constraint(equalToConstant: 48),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        contentsContainer.addSubview(magazineDetailView)
        NSLayoutConstraint.activate([
            magazineDetailView.topAnchor.constraint(equalTo: titleImageView.bottomAnchor, constant: 20),
            magazineDetailView.leadingAnchor.constraint(equalTo: contentsContainer.leadingAnchor, constant: 20),
            magazineDetailView.trailingAnchor.constraint(equalTo: contentsContainer.trailingAnchor, constant: -20),
            bottomConstraints
        ])
    }
    
    func setupScrollViewLayout() {
        let scrollViewGuide = scrollView.contentLayoutGuide
        
        let imageViewTopConstraint = titleImageView.topAnchor.constraint(equalTo: view.topAnchor)
        imageViewTopConstraint.priority = .defaultHigh
        
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        scrollView.addSubview(contentsContainer)
        NSLayoutConstraint.activate([
            contentsContainer.topAnchor.constraint(equalTo: scrollViewGuide.topAnchor),
            contentsContainer.bottomAnchor.constraint(equalTo: scrollViewGuide.bottomAnchor),
            contentsContainer.leadingAnchor.constraint(equalTo: scrollViewGuide.leadingAnchor),
            contentsContainer.trailingAnchor.constraint(equalTo: scrollViewGuide.trailingAnchor),
            contentsContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        contentsContainer.addSubview(imageContainer)
        NSLayoutConstraint.activate([
            imageContainer.topAnchor.constraint(equalTo: contentsContainer.topAnchor),
            imageContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageContainer.heightAnchor.constraint(equalToConstant: topSafeArea + 375),
            imageContainer.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
        ])
        
        contentsContainer.addSubview(titleImageView)
        NSLayoutConstraint.activate([
            imageViewTopConstraint,
            titleImageView.heightAnchor.constraint(greaterThanOrEqualTo: imageContainer.heightAnchor),
            titleImageView.leadingAnchor.constraint(equalTo: imageContainer.leadingAnchor),
            titleImageView.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor),
            titleImageView.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor)
        ])
    }
    
    func setupCustomNavigationBar() {
        customNavigationBar = CustomNavigationBar(titleText: titleLabel.text, rightButtonImage: UIImage())
        customNavigationBar.magazine = magazine
        setupCustomNavigationRightItem()
        customNavigationBar.view.alpha = 0
        customNavigationBar.dismissAction = { [weak self] in
            self?.presentingViewController?.dismiss(animated: true)
        }
    }
    
    private func setupCustomNavigationRightItem() {
        let rightImage = userDefaultsCheck() ? SFSymbol.bookmarkFillInNavigation.image : SFSymbol.bookmarkInNavigation.image
        
        customNavigationBar.rightButton.setImage(rightImage, for: .normal)
    }
    
    private func setupBookmarkImage() {
        bookmarkButton.setImage(userDefaultsCheck() ? SFSymbol.bookmarkFillInDetail.image : SFSymbol.bookmarkInDetail.image, for: .normal)
    }
    
    private func userDefaultsCheck() -> Bool {
        return UserDefaultsManager.shared.loadUserDefaults(key: Constants.wishMagazine).contains(magazine.title)
        
    }
    
    @objc
    func clickedCloseButton(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    func clickedBookmarkButton(sender: UIButton) {
        detailViewModel.notifyClickedMagazineId(title: magazine.title, key: Constants.wishMagazine)
        setupBookmarkImage()
    }
}

extension CellItemDetailViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let totalOffset = scrollView.contentOffset.y
        if totalOffset < -topSafeArea {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentScrollYOffset = scrollView.contentOffset.y
        
        if currentScrollYOffset > defaultScrollYOffset {
            setupCustomNavigationRightItem()
            setupBookmarkImage()
            customNavigationBar.view.alpha = currentScrollYOffset / (topSafeArea + 259)
            titleImageView.alpha = 1 - (currentScrollYOffset / (topSafeArea + 259))
            closeButton.alpha = 1 - (currentScrollYOffset / (topSafeArea + 259))
        } else {
            customNavigationBar.view.alpha = 0
            titleImageView.alpha = 1
            closeButton.alpha = 1
        }
    }
}
