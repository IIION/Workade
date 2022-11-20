//
//  OfficeViewController.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/11/19.
//

import UIKit

final class OfficeViewController: UIViewController {
    private let viewModel = OfficeViewModel()
    
    enum Section { case office }
    private var dataSource: UICollectionViewDiffableDataSource<Section, OfficeModel>!
    private var snapshot = NSDiffableDataSourceSnapshot<Section, OfficeModel>() // 여기
    
    // MARK: UI 컴포넌트
    private let titleView = TitleLabel(title: "오피스")
    
    private lazy var ellipseSegment: EllipseSegmentControl = {
        let segment = EllipseSegmentControl(items: viewModel.regions)
        segment.delegate = self
        segment.currentSegmentIndex = 2
        segment.translatesAutoresizingMaskIntoConstraints = false
        
        return segment
    }()
    
    private let divider = Divider()
    
    private lazy var officeCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewModel.createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
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
        [titleView, ellipseSegment, divider, officeCollectionView].forEach {
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
    }
}

// MARK: Delegate
extension OfficeViewController: EllipseSegmentControlDelegate {
    func ellipseSegment(didSelectItemAt index: Int) {
        let region = viewModel.regions[index]
        applySnapshot(region: region, animated: true)
    }
}
