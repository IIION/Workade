//
//  MagazineViewController.swift
//  Workade
//
//  Created by Hong jeongmin on 2022/10/17.
//

import UIKit

final class MagazineViewController: UIViewController {
    private let viewModel = MagazineViewModel()
    
    enum Section { case magazine }
    private var dataSource: UICollectionViewDiffableDataSource<Section, MagazineModel>!
    private var snapshot = NSDiffableDataSourceSnapshot<Section, MagazineModel>() {
        didSet {
            displayPrepareViewIfNeeded()
        }
    }
    
    // MARK: UI 컴포넌트
    private let titleView = TitleLabel(title: "매거진")
    
    private lazy var ellipseSegment: EllipseSegmentControl = {
        let segment = EllipseSegmentControl(items: MagazineCategory.allCases.map { $0.rawValue })
        segment.delegate = self
        segment.currentSegmentIndex = 0
        segment.translatesAutoresizingMaskIntoConstraints = false
        
        return segment
    }()
    
    private let divider = Divider()
    
    private lazy var magazineCollectionView: UICollectionView = {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .theme.background
        
        setupNavigationBar()
        setupLayout()
        configureDataSource()
        observeFetchCompletion()
    }
    
    private func observeFetchCompletion() {
        let category = MagazineCategory.allCases[ellipseSegment.currentSegmentIndex]
        viewModel.isCompleteFetch.bindAndFire { [weak self] _ in
            self?.applySnapshot(category: category, animated: true)
        }
    }
}

// MARK: DiffableDataSource
private extension MagazineViewController {
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<MagazineCollectionViewCell, MagazineModel> { cell, _, itemIdentifier in
            cell.configure(magazine: itemIdentifier)
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: magazineCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        })
    }
    
    func applySnapshot(category: MagazineCategory, animated: Bool) {
        guard dataSource != nil else { return }
        var snapshot = snapshot
        snapshot.deleteAllItems()
        snapshot.appendSections([Section.magazine])
        snapshot.appendItems(viewModel.filteredMagazine(category: category))
        self.dataSource.apply(snapshot, animatingDifferences: animated)
        self.snapshot = snapshot
    }
}

// MARK: UI Related Methods
private extension MagazineViewController {
    func displayPrepareViewIfNeeded() {
        let category = MagazineCategory.allCases[ellipseSegment.currentSegmentIndex]
        prepareView.category = .magazine(category)
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
        [titleView, ellipseSegment, divider, magazineCollectionView, prepareView].forEach {
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
            magazineCollectionView.topAnchor.constraint(equalTo: divider.bottomAnchor),
            magazineCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            magazineCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            magazineCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
extension MagazineViewController: EllipseSegmentControlDelegate {
    func ellipseSegment(didSelectItemAt index: Int) {
        let category = MagazineCategory.allCases[index]
        applySnapshot(category: category, animated: true)
    }
}

extension MagazineViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let magazineModel = snapshot.itemIdentifiers[indexPath.row]
        let viewController = CellItemDetailViewController(magazine: magazineModel)
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }
}
