//
//  HomeView.swift
//  Workade
//
//  Created by Inho Choi on 2022/10/18.
//

import UIKit

class HomeViewController: UIViewController {
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    /// *scrollView*의 실제 컨텐트 영역입니다.
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    /// navigation인 척!하는 *UIStackView*
    private lazy var navigationView: UIStackView = {
        let logoImageView = UIImageView(image: UIImage(named: "WorkadeLogoTamna")?.setOriginal())
        logoImageView.contentMode = .left
        let profileButton = UIButton()
        profileButton.setImage(UIImage(named: "ProfileTamna")?.setOriginal(), for: .normal)
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.addArrangedSubview(logoImageView)
        stackView.addArrangedSubview(profileButton)
        stackView.layoutMargins = .init(top: 0, left: 20, bottom: 0, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2 // default value = 1
        label.text = "반가워요!\n같이 워케이션을 꿈꿔볼까요?"
        label.font = .customFont(for: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var officeCollectionView: HorizontalCollectionView = {
        let collectionView = HorizontalCollectionView(itemSize: CGSize(width: 280, height: 200))
        collectionView.dataSource = self
        collectionView.register(cell: OfficeCollectionViewCell.self)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    private let divider = {
        let view = UIView()
        view.backgroundColor = .theme.labelBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let magazineHeaderView: HeaderView = {
        let stackView = HeaderView(title: "매거진")
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var magazineCollectionView: HorizontalCollectionView = {
        let collectionView = HorizontalCollectionView(itemSize: CGSize(width: 150, height: 200))
        collectionView.dataSource = self
        collectionView.register(cell: MagazineCollectionViewCell.self)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    private lazy var checkListButton: CheckListButton = {
        let button = CheckListButton()
        button.layer.borderColor = UIColor.theme.groupedBackground.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupNavigationBar()
        setupLayout()
        setupStatusBar()
    }
}

// MARK: UI setup 관련 Methods
extension HomeViewController {
    private func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupStatusBar() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let bounds = windowScene?.statusBarManager?.statusBarFrame
        let blurredStatusBar = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blurredStatusBar.frame = bounds ?? CGRect(x: 0, y: 0, width: view.bounds.width, height: 47)
        view.addSubview(blurredStatusBar)
    }
    
    private func setupScrollViewLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        let guide = scrollView.contentLayoutGuide
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: guide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupLayout() {
        [navigationView, welcomeLabel, officeCollectionView, divider,
         magazineHeaderView, magazineCollectionView, checkListButton].forEach {
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            navigationView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            navigationView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            navigationView.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: navigationView.bottomAnchor, constant: 20),
            welcomeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            welcomeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            officeCollectionView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 22),
            officeCollectionView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            officeCollectionView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        NSLayoutConstraint.activate([
            divider.topAnchor.constraint(equalTo: officeCollectionView.bottomAnchor, constant: 30),
            divider.leadingAnchor.constraint(equalTo: officeCollectionView.leadingAnchor, constant: 20),
            divider.trailingAnchor.constraint(equalTo: officeCollectionView.trailingAnchor, constant: -20),
            divider.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        NSLayoutConstraint.activate([
            magazineHeaderView.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 4),
            magazineHeaderView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            magazineHeaderView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        NSLayoutConstraint.activate([
            magazineCollectionView.topAnchor.constraint(equalTo: magazineHeaderView.bottomAnchor),
            magazineCollectionView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            magazineCollectionView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        NSLayoutConstraint.activate([
            checkListButton.topAnchor.constraint(equalTo: magazineCollectionView.bottomAnchor, constant: 30),
            checkListButton.heightAnchor.constraint(equalToConstant: 62),
            checkListButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            checkListButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            checkListButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
}

// MARK: DataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView { // 추후 컨텐츠 데이터 받아와서 할 예정. 일단 UI.
        case officeCollectionView:
            return 5
        case magazineCollectionView:
            return 20
        default:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case officeCollectionView:
            let cell: OfficeCollectionViewCell = collectionView.dequeue(for: indexPath)
            cell.configure(office: Office(officeName: "O-PIECE",
                                          regionName: "제주도",
                                          profileImage: UIImage(named: "WorkationTamna") ?? UIImage(),
                                          latitude: 30,
                                          longitude: 30))
            return cell
        case magazineCollectionView:
            let cell: MagazineCollectionViewCell = collectionView.dequeue(for: indexPath)
            cell.configure(magazine: Magazine(id: 1, // temp
                                              title: "내 성격에 맞는\n장소 찾는 법",
                                              profileImage: UIImage(named: "WorkationTamna") ?? UIImage()))
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}
