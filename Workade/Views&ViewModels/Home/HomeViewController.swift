//
//  HomeView.swift
//  Workade
//
//  Created by Inho Choi on 2022/10/18.
//

import UIKit

@MainActor
final class HomeViewController: UIViewController {
    private let viewModel = HomeViewModel()
    
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
    
    private lazy var officeCollectionView: UICollectionView = {
        let collectionView = UICollectionView(itemSize: CGSize(width: 280, height: 200), direction: .horizontal)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cell: OfficeCollectionViewCell.self)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    private lazy var magazineHeaderView: HeaderView = {
        let stackView = HeaderView(title: "매거진")
        stackView.pushButton.addTarget(self, action: #selector(pushToMagazineVC), for: .touchUpInside)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var magazineCollectionView: UICollectionView = {
        let collectionView = UICollectionView(itemSize: CGSize(width: 150, height: 200), direction: .horizontal)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cell: MagazineCollectionViewCell.self)
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
        
        setupScrollViewLayout()
        setupNavigationBar()
        setupLayout()
        observingFetchComplete()
        observingChangedMagazineId()
    }
}

extension HomeViewController {
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
                self.officeCollectionView.reloadData()
                self.magazineCollectionView.reloadData()
            }
        }
    }
    
    // 북마크
    private func observingChangedMagazineId() {
        viewModel.clickedMagazineId.bind { [weak self] id in
            guard let self = self else { return }
            guard let index = self.viewModel.magazineResource.content.firstIndex(where: { $0.title == id }) else { return }
            DispatchQueue.main.async {
                self.magazineCollectionView.reloadItems(at: [.init(item: index, section: 0)])
            }
        }
    }
}

// MARK: DataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView { // 추후 컨텐츠 데이터 받아와서 할 예정. 일단 UI.
        case officeCollectionView:
            return viewModel.officeResource.content.count
        case magazineCollectionView:
            return viewModel.magazineResource.content.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case officeCollectionView:
            let cell: OfficeCollectionViewCell = collectionView.dequeue(for: indexPath)
            cell.delegate = self
            cell.configure(office: viewModel.officeResource.content[indexPath.row])
            return cell
        case magazineCollectionView:
            let cell: MagazineCollectionViewCell = collectionView.dequeue(for: indexPath)
            cell.delegate = self // 북마크
            cell.configure(magazine: viewModel.magazineResource.content[indexPath.row])
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

// MARK: Delegate
extension HomeViewController: UICollectionViewDelegate {
    // 반드시 office 혹은 magazine이 있어야하는 요소는 init으로 넘깁니다.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case officeCollectionView:
            let officeModel = viewModel.officeResource.content[indexPath.row]
            let viewController = NearbyPlaceViewController(officeModel: officeModel)
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: true)
        case magazineCollectionView:
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

// MARK: UI setup 관련 Methods
private extension HomeViewController {
    func setupNavigationBar() {
        // hide 안걸어주면 push할 때 backButton 잔상 남아버림
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.tintColor = .theme.primary
    }
    
    func setupScrollViewLayout() {
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
    
    func setupLayout() {
        [officeCollectionView, magazineHeaderView, magazineCollectionView, checkListButton].forEach {
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            officeCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 22),
            officeCollectionView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            officeCollectionView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        NSLayoutConstraint.activate([
            magazineHeaderView.topAnchor.constraint(equalTo: officeCollectionView.bottomAnchor, constant: 4),
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
