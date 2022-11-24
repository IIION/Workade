//
//  GuideHomeViewController.swift
//  Workade
//
//  Created by Inho Choi on 2022/10/18.
//

import UIKit

enum GuideHomeSection: Int, CaseIterable {
    case office, magazine, checkList
}

final class GuideHomeViewController: UIViewController {
    private let officeTransitionManager = OfficeTransitionManager()
    private let magazineTransitionManager = MagazineTransitionManager()
    private let viewModel = GuideHomeViewModel()
    
    private let divider = Divider()
    
    private lazy var guideCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewModel.createLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cell: OfficeCollectionViewCell.self)
        collectionView.register(cell: MagazineCollectionViewCell.self)
        collectionView.register(cell: CheckListNavigationCell.self)
        collectionView.registerSupplementary(view: HeaderView.self, kind: UICollectionView.elementKindSectionHeader) // for header
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .theme.background
        
        setupNavigationBar()
        setupLayout()
        observingFetchComplete()
        observingChangedMagazineId()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.guideCollectionView.reloadData() // snapshot 체제로 변경 전까지 임시.
    }
    
    private func setupNavigationBar() {
        title = "가이드"
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.customFont(for: .subHeadline)]
        navigationController?.navigationBar.shadowImage = UIImage() // remove default underline
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: SFSymbol.chevronLeft.image,
            primaryAction: UIAction(handler: { [weak self] _ in
                guard let self = self else { return }
                self.navigationController?.popViewController(animated: true)
            })
        )
    }
    
    private func setupLayout() {
        view.addSubview(guideCollectionView)
        view.addSubview(divider)
        NSLayoutConstraint.activate([
            guideCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            guideCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor),
            guideCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            guideCollectionView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            divider.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            divider.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

// MARK: Navigates
private extension GuideHomeViewController {
    @objc func pushToOfficeVC() {
        let viewController = OfficeViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func pushToMagazineVC() {
        let viewController = MagazineViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pushToCheckListVC() {
        let viewController = CheckListViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: Binding with ViewModel
extension GuideHomeViewController {
    /**
     OfficeResource, MagazineResource 데이터 불러오는 과정이 완료가 되면 소식을 받을 수 있도록 binding
     
     현재 GuideHomeViewController가 로드될 때, 데이터를 불러오기 때문에 처음 컬렉션뷰가 그려질 때는 아직 데이터의 count가 0입니다.
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
            let sectionIndex = GuideHomeSection.allCases.firstIndex(of: .magazine)!
            DispatchQueue.main.async {
                self.guideCollectionView.reloadItems(at: [.init(item: index, section: sectionIndex)])
            }
        }
    }
}

// MARK: DataSource
extension GuideHomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return GuideHomeSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sectionCase = GuideHomeSection(rawValue: section) else { return 0 }
        switch sectionCase { // 추후 컨텐츠 데이터 받아와서 할 예정. 일단 UI.
        case .office:
            return viewModel.officeResource.content.count
        case .magazine:
            return viewModel.magazineResource.content.count
        case .checkList:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sectionCase = GuideHomeSection(rawValue: indexPath.section) else { return UICollectionViewCell() }
        switch sectionCase {
        case .office:
            let cell: OfficeCollectionViewCell = collectionView.dequeue(for: indexPath)
            cell.configure(office: viewModel.officeResource.content[indexPath.row])
            return cell
        case .magazine:
            let cell: MagazineCollectionViewCell = collectionView.dequeue(for: indexPath)
            cell.delegate = self // 북마크
            cell.configure(magazine: viewModel.magazineResource.content[indexPath.row])
            return cell
        case .checkList:
            let cell: CheckListNavigationCell = collectionView.dequeue(for: indexPath)
            return cell
        }
    }
    
    // for header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let sectionCase = GuideHomeSection(rawValue: indexPath.section) else { return UICollectionReusableView() }
        let reusableView: HeaderView = collectionView.dequeueSupplementary(kind: kind, for: indexPath)
        switch sectionCase {
        case .office:
            reusableView.configure(title: "office")
            reusableView.pushToNext = { [weak self] in
                self?.pushToOfficeVC()
            }
            return reusableView
        case .magazine:
            reusableView.configure(title: "magazine")
            reusableView.pushToNext = { [weak self] in
                self?.pushToMagazineVC()
            }
            return reusableView
        default: // office, magazine외에 CompositionalLayout 상에서 header등록을 안했다면, default로 들어올 일이 없다.
            return UICollectionReusableView()
        }
    }
}

// MARK: Delegate
extension GuideHomeViewController: UICollectionViewDelegate {
    // 반드시 office 혹은 magazine이 있어야하는 요소는 init으로 넘깁니다.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let sectionCase = GuideHomeSection(rawValue: indexPath.section) else { return }
        switch sectionCase {
        case .office:
            let officeModel = viewModel.officeResource.content[indexPath.row]
            let viewController = NearbyPlaceViewController(officeModel: officeModel)
            
            // Transition Manager가 사용할 수 있는 정보를 Cell에서 제공.
            guard let cell = collectionView.cellForItem(at: indexPath) as? OfficeCollectionViewCell else { return }
            let absoluteFrame = cell.backgroundImageView.convert(cell.backgroundImageView.frame, to: nil)
            officeTransitionManager.absoluteCellFrame = absoluteFrame
            officeTransitionManager.cellHidden = { isHidden in cell.backgroundImageView.isHidden = isHidden }
            viewController.transitioningDelegate = officeTransitionManager
            viewController.modalPresentationStyle = .custom
            present(viewController, animated: true)
        case .magazine:
            let magazine = viewModel.magazineResource.content[indexPath.row]
            let viewController = CellItemDetailViewController(magazine: magazine)
            
            guard let cell = collectionView.cellForItem(at: indexPath) as? MagazineCollectionViewCell else { return }
            let absoluteFrame = cell.backgroundImageView.convert(cell.backgroundImageView.frame, to: nil)
            magazineTransitionManager.absoluteCellFrame = absoluteFrame
            magazineTransitionManager.cellHidden = { isHidden in cell.backgroundImageView.isHidden = isHidden }
            viewController.transitioningDelegate = magazineTransitionManager
            viewController.modalPresentationStyle = .custom
            present(viewController, animated: true)
        case .checkList:
            pushToCheckListVC()
        }
    }
}

// MARK: Custom Delegate
extension GuideHomeViewController: CollectionViewCellDelegate {
    func didTapBookmarkButton(id: String) { // 북마크
        viewModel.notifyClickedMagazineId(title: id, key: Constants.Key.wishMagazine)
    }
}
