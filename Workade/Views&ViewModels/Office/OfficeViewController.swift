//
//  OfficeViewController.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/11/19.
//

import UIKit

final class OfficeViewController: UIViewController {
    private let viewModel = OfficeViewModel()
    private let startRegion: String // 시작 화면 설정용
    
    enum Section { case office }
    private var dataSource: UICollectionViewDiffableDataSource<Section, OfficeModel>!
    private var snapshot = NSDiffableDataSourceSnapshot<Section, OfficeModel>() {
        didSet { // didset timing: 1) data fetch 완료 후, 2) segment 눌렸을 때.
            displayPrepareViewIfNeeded()
        }
    }
    
    // MARK: UI 컴포넌트
    private let titleView = TitleLabel(title: "오피스")
    
    private lazy var ellipseSegment: EllipseSegmentControl = {
        let segment = EllipseSegmentControl(items: viewModel.regions)
        segment.delegate = self
        // 아직 서버에는 '제주도' <- 이렇게 되있어서 우선 contains를 사용.
        segment.currentSegmentIndex = viewModel.regions.firstIndex(where: { startRegion.contains($0) }) ?? 0
        segment.translatesAutoresizingMaskIntoConstraints = false
        
        return segment
    }()
    
    private let divider = Divider()
    
    private lazy var officeCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewModel.createLayout())
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    private let prepareView: PrepareView = {
        let prepareView = PrepareView()
        prepareView.translatesAutoresizingMaskIntoConstraints = false
        
        return prepareView
    }()
    
    init(from region: String = "전체") { // 특정지역으로부터 올 때 -> OfficeViewController(from: "제주")
        self.startRegion = region
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .theme.background
        
        setupNavigationBar()
        setupLayout()
        configureDataSource()
        observeFetchCompletion()
    }
    
    private func observeFetchCompletion() {
        viewModel.requestOfficeData()
        let regionName = viewModel.regions[ellipseSegment.currentSegmentIndex]
        viewModel.isCompleteFetch.bind { [weak self] _ in
            self?.applySnapshot(region: regionName, animated: true)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: DiffableDataSource
extension OfficeViewController {
    func configureDataSource() {
        // cell을 구성하고, 등록지를 만듬
        let cellRegistration = UICollectionView.CellRegistration<OfficeCollectionViewCell, OfficeModel> { cell, _, itemIdentifier in
            cell.configure(office: itemIdentifier)
        }
        
        // collectionView와 dequeue cell을 제공하면서 dataSource 초기화
        dataSource = UICollectionViewDiffableDataSource(collectionView: officeCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        })
    }
    
    func applySnapshot(region: String, animated: Bool) {
        guard dataSource != nil else { return }
        var snapshot = snapshot
        snapshot.deleteAllItems()
        snapshot.appendSections([Section.office])
        snapshot.appendItems(viewModel.filteredOffice(region: region))
        self.dataSource.apply(snapshot, animatingDifferences: animated)
        self.snapshot = snapshot // 이 순간에만 snapShot didset 호출될 수 있게 변수로 구성하고 넘기는 형태 구현함.
    }
}

// MARK: UI Related Methods
private extension OfficeViewController {
    func displayPrepareViewIfNeeded() {
        let region = viewModel.regions[ellipseSegment.currentSegmentIndex]
        prepareView.category = .office(region)
        // diffable datasource animation을 저해하지않도록 display 애니메이션 설정.
        let wouldShow: Bool = (snapshot.numberOfItems == 0)
        UIView.animate(withDuration: (wouldShow ? 0.3 : 0), delay: (wouldShow ? 0.2 : 0)) { [weak self] in
            self?.prepareView.alpha = wouldShow ? 1 : 0
        }
    }
    
    func setupNavigationBar() {
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: SFSymbol.chevronLeft.image,
            primaryAction: UIAction(handler: { [weak self] _ in
                guard let self = self else { return }
                self.navigationController?.popViewController(animated: true)
            })
        )
    }
    
    func setupLayout() {
        [titleView, ellipseSegment, divider, officeCollectionView, prepareView].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            ellipseSegment.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 30),
            ellipseSegment.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            ellipseSegment.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ellipseSegment.heightAnchor.constraint(equalToConstant: 34)
        ])
        
        NSLayoutConstraint.activate([
            divider.topAnchor.constraint(equalTo: ellipseSegment.bottomAnchor, constant: 12),
            divider.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            officeCollectionView.topAnchor.constraint(equalTo: divider.bottomAnchor),
            officeCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            officeCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            officeCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            prepareView.topAnchor.constraint(equalTo: divider.bottomAnchor),
            prepareView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            prepareView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            prepareView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: Delegate
extension OfficeViewController: EllipseSegmentControlDelegate {
    func ellipseSegment(didSelectItemAt index: Int) {
        let region = viewModel.regions[index]
        applySnapshot(region: region, animated: true)
    }
}

extension OfficeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let officeModel = snapshot.itemIdentifiers[indexPath.row]
        let viewController = NearbyPlaceViewController(officeModel: officeModel)
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }
}
