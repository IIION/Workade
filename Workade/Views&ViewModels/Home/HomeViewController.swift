//
//  HomeView.swift
//  Workade
//
//  Created by Inho Choi on 2022/10/18.
//

import UIKit

final class HomeViewController: UIViewController {
    enum Section: Int, CaseIterable {
        case office, magazine
    }
    
    private let viewModel = HomeViewModel()
    
    private lazy var guideCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewModel.createLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cell: OfficeCollectionViewCell.self)
        collectionView.register(cell: MagazineCollectionViewCell.self)
        collectionView.registerSupplementary(view: HeaderView.self, kind: UICollectionView.elementKindSectionHeader) // for header
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    private lazy var checkListButton: NavigateButton = {
        let button = NavigateButton(image: nil, text: "체크리스트")
        button.layer.borderColor = UIColor.theme.groupedBackground.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(pushToCheckListVC), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupNavigationBar()
        setupLayout()
        
        observingFetchComplete()
        observingChangedMagazineId()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // HomeVC에서는 네비게이션 영역 쓰지않음
        // viewDidAppear로 하면, 홈화면 돌아올 때 backButton의 잔상이 순간 보이게 되버림
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // viewDidDisappear로 하면, 다음 화면에서 backButton이 다소 늦게 나타나버림
        navigationController?.navigationBar.isHidden = false
    }
    
    private func setupNavigationBar() {
        // hide 안걸어주면 push할 때 backButton 잔상 남아버림
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.tintColor = .theme.primary
    }
    
    private func setupLayout() {
        view.addSubview(guideCollectionView)
        NSLayoutConstraint.activate([
            guideCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            guideCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
    }
}

// MARK: Navigates
private extension HomeViewController {
    @objc
    func pushToMyPageVC() {
        let viewController = MyPageViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc
    func pushToMagazineVC() { // 요기
        let viewController = MagazineViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc
    func pushToCheckListVC() {
        let viewController = CheckListViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: Binding with ViewModel
extension HomeViewController {
    /**
     OfficeResource, MagazineResource 데이터 불러오는 과정이 완료가 되면 소식을 받을 수 있도록 binding
     
     현재 HomeViewController가 로드될 때, 데이터를 불러오기 때문에 처음 컬렉션뷰가 그려질 때는 아직 데이터의 count가 0입니다.
     따라서, 모든 데이터를 불러온 직후 최초 1회 binding한 이 클로저를 호출시켜주면서 컬렉션뷰들을 정상적으로 reload합니다.
     */
    private func observingFetchComplete() {
        viewModel.isCompleteFetch.bindAndFire { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.guideCollectionView.reloadData()
            }
        }
    }
    
    // 북마크
    private func observingChangedMagazineId() {
        viewModel.clickedMagazineId.bind { [weak self] id in
            guard let self = self else { return }
            guard let index = self.viewModel.magazineResource.content.firstIndex(where: { $0.title == id }) else { return }
            DispatchQueue.main.async {
                self.guideCollectionView.reloadItems(at: [.init(item: index, section: 1)])
            }
        }
    }
}

// MARK: DataSource
extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section { // 추후 컨텐츠 데이터 받아와서 할 예정. 일단 UI.
        case 0:
            return viewModel.officeResource.content.count
        case 1:
            return viewModel.magazineResource.content.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell: OfficeCollectionViewCell = collectionView.dequeue(for: indexPath)
            cell.delegate = self
            cell.configure(office: viewModel.officeResource.content[indexPath.row])
            return cell
        case 1:
            let cell: MagazineCollectionViewCell = collectionView.dequeue(for: indexPath)
            cell.delegate = self // 북마크
            cell.configure(magazine: viewModel.magazineResource.content[indexPath.row])
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    // for header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let reusableView: HeaderView = collectionView.dequeueSupplementary(kind: kind, for: indexPath)
        switch indexPath.section {
        case 0:
            reusableView.configure(title: "office")
            reusableView.pushToNext = { [weak self] in
                self?.pushToMyPageVC()
            }
            return reusableView
        case 1:
            reusableView.configure(title: "magazine")
            reusableView.pushToNext = { [weak self] in
                self?.pushToMagazineVC()
            }
            return reusableView
        default:
            return UICollectionReusableView()
        }
    }
}

// MARK: Delegate
extension HomeViewController: UICollectionViewDelegate {
    // 반드시 office 혹은 magazine이 있어야하는 요소는 init으로 넘깁니다.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let officeModel = viewModel.officeResource.content[indexPath.row]
            let viewController = NearbyPlaceViewController(officeModel: officeModel)
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: true)
        case 1:
            let magazine = viewModel.magazineResource.content[indexPath.row]
            let viewController = CellItemDetailViewController(magazine: magazine)
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: true)
        default:
            break
        }
    }
}

extension HomeViewController: CollectionViewCellDelegate {
    func didTapMapButton(office: OfficeModel) {
        let viewController = MapViewController(office: office)
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }
    
    func didTapBookmarkButton(id: String) { // 북마크
        viewModel.notifyClickedMagazineId(title: id, key: Constants.Key.wishMagazine)
    }
}
