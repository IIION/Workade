//
//  HomeView.swift
//  Workade
//
//  Created by Inho Choi on 2022/10/18.
//

import UIKit

class HomeViewController: UIViewController {
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
    }
}

// MARK: UI setup 관련 Methods
extension HomeViewController {
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "WorkadeLogoTamna")?.setOriginal(),
            style: .done,
            target: nil,
            action: nil
        )
        navigationItem.leftBarButtonItem?.isEnabled = false // no touch event
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "ProfileTamna")?.setOriginal(),
            style: .done,
            target: self,
            action: nil // will connect to MyPageView
        )
    }
    
    private func setupLayout() {
        view.addSubview(welcomeLabel)
        view.addSubview(officeCollectionView)
        view.addSubview(divider)
        view.addSubview(magazineHeaderView)
        view.addSubview(magazineCollectionView)
        view.addSubview(checkListButton)
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 23),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        
            officeCollectionView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 22),
            officeCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            officeCollectionView.heightAnchor.constraint(equalToConstant: 200),
            
            divider.topAnchor.constraint(equalTo: officeCollectionView.bottomAnchor, constant: 30),
            divider.leadingAnchor.constraint(equalTo: officeCollectionView.leadingAnchor, constant: 20),
            divider.trailingAnchor.constraint(equalTo: officeCollectionView.trailingAnchor, constant: -20),
            divider.heightAnchor.constraint(equalToConstant: 1),
            
            magazineHeaderView.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 4),
            magazineHeaderView.widthAnchor.constraint(equalTo: view.widthAnchor),
            magazineHeaderView.heightAnchor.constraint(equalToConstant: 60),
            
            magazineCollectionView.topAnchor.constraint(equalTo: magazineHeaderView.bottomAnchor),
            magazineCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            magazineCollectionView.heightAnchor.constraint(equalToConstant: 200),
            
            checkListButton.topAnchor.constraint(equalTo: magazineCollectionView.bottomAnchor, constant: 30),
            checkListButton.heightAnchor.constraint(equalToConstant: 57),
            checkListButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            checkListButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
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
                                          profileImage: UIImage(named: "OpieceTamna") ?? UIImage(),
                                          latitude: 30,
                                          longitude: 30))
            return cell
        case magazineCollectionView:
            let cell: MagazineCollectionViewCell = collectionView.dequeue(for: indexPath)
            cell.configure(magazine: Magazine(id: 1, // temp
                                              title: "내 성격에 맞는\n장소 찾는 법",
                                              profileImage: UIImage(named: "OpieceTamna") ?? UIImage()))
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}
