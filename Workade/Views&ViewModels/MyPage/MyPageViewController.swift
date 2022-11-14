//
//  MyPageViewController.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/10/26.
//

import UIKit

final class MyPageViewController: UIViewController {
    private let viewModel = MyPageViewModel()
    
    private let titleView = TitleView(title: "매거진")
    
    private let wishLabel: UILabel = {
        let label = UILabel()
        label.text = "내가 찜한 매거진"
        label.font = .customFont(for: .headline)
        label.textColor = .theme.primary
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var wishMagazineCollectionView: UICollectionView = {
        let width = (view.bounds.width - 60) / 2
        let collectionView = UICollectionView(
            itemSize: CGSize(width: width, height: width*1.3),
            inset: .init(top: 0, left: 20, bottom: 20, right: 20),
            direction: .vertical)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cell: MagazineCollectionViewCell.self)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .theme.background
        
        setupNavigationBar()
        setupLayout()
        setupGradientLayer()
        
        observingFetchComplete()
        observingChangedMagazineId()
    }
}

// MARK: Navigates
extension MyPageViewController {
    @objc
    func popToHomeVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    func pushToSettingVC() {
        let viewController = SettingViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: Binding
extension MyPageViewController {
    private func observingFetchComplete() {
        viewModel.isCompleteFetch.bindAndFire { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.wishMagazineCollectionView.reloadData()
            }
        }
    }
    
    // TODO: 다음 PR 수정사항
    // Detail Cell과 이어짐으로써 delete로직이 아닌 다른 로직으로 수정해야함.
    // 비동기로 지속적으로 움직이는 방식이 아닌 viewWillAppear핸들링으로 수정.
    // reload관련 이슈해결위해 diffableDataSource활용 예정.
    private func observingChangedMagazineId() {
        viewModel.clickedMagazineId.bind { [weak self] id in
            guard let self = self else { return }
            guard let index = self.viewModel.wishMagazines.firstIndex(where: { $0.title == id }) else { return }
            DispatchQueue.main.async {
                self.wishMagazineCollectionView.deleteItems(at: [.init(item: index, section: 0)])
            }
        }
    }
}

// MARK: DataSource
extension MyPageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.wishMagazines.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MagazineCollectionViewCell = collectionView.dequeue(for: indexPath)
        cell.delegate = self
        cell.configure(magazine: viewModel.wishMagazines[indexPath.row])
        return cell
    }
}

// MARK: Delegate
extension MyPageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let magazine = viewModel.wishMagazines[indexPath.row]
        let viewController = CellItemDetailViewController(magazine: magazine)
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }
}

extension MyPageViewController: CollectionViewCellDelegate {
    func didTapBookmarkButton(id: String) { // 북마크
        viewModel.notifyClickedMagazineId(title: id, key: Constants.Key.wishMagazine)
        viewModel.wishMagazines = viewModel.wishMagazines.filter { $0.title != id }
    }
}

// MARK: UI setup 관련 Methods
private extension MyPageViewController {
    func setupNavigationBar() {
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: SFSymbol.chevronLeft.image,
            style: .done,
            target: self,
            action: #selector(popToHomeVC)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: SFSymbol.gearshapeFill.image,
            style: .done,
            target: self,
            action: #selector(pushToSettingVC)
        )
    }
    
    func setupGradientLayer() {
        let layer = CAGradientLayer()
        layer.colors = [UIColor.white.withAlphaComponent(0).cgColor,
                        UIColor.white.withAlphaComponent(0.6).cgColor]
        layer.locations = [0, 1]
        layer.frame = CGRect(x: 0, y: view.bounds.height/7*6,
                             width: view.bounds.width, height: view.bounds.height/7)
        layer.startPoint = CGPoint(x: 0.0, y: 0.0)
        layer.endPoint = CGPoint(x: 0.0, y: 1.0)
        view.layer.addSublayer(layer)
    }
    
    func setupLayout() {
        view.addSubview(titleView)
        view.addSubview(wishLabel)
        view.addSubview(wishMagazineCollectionView)
        
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            wishLabel.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 30),
            wishLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            wishMagazineCollectionView.topAnchor.constraint(equalTo: wishLabel.bottomAnchor, constant: 16),
            wishMagazineCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            wishMagazineCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
