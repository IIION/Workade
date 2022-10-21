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
        collectionView.register(cell: OfficeCollectionViewCell.self)
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    private let divider = {
        let view = UIView()
        view.backgroundColor = .theme.labelBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let megazineHeaderView: HeaderView = {
        let stackView = HeaderView(title: "매거진")
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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
        view.addSubview(megazineHeaderView)
        
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
            
            megazineHeaderView.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 4),
            megazineHeaderView.widthAnchor.constraint(equalTo: view.widthAnchor),
            megazineHeaderView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}

// MARK: DataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5 // temp
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: OfficeCollectionViewCell = collectionView.dequeue(for: indexPath)
        // UI layout확인용 temp data입니다. 데이터 로직은 좀더 정리하고 반영하겠습니다.
        cell.configure(office: Office(officeName: "O-PIECE",
                                      regionName: "제주도",
                                      profileImage: UIImage(named: "OpieceTamna") ?? UIImage(),
                                      latitude: 30,
                                      longitude: 30))
        return cell
    }
}
