//
//  OfficeViewController.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/11/19.
//

import UIKit

final class OfficeViewController: UIViewController {
    private let titleView = TitleLabel(title: "오피스")
    
    enum Section { case office }
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, OfficeModel>!
    private var snapshot = NSDiffableDataSourceSnapshot<Section, OfficeModel>()
    
    private lazy var ellipseSegment: UIView = {
        let segment = EllipseSegmentControl(items: ["전체", "제주", "양양", "고성", "경주", "포항"])
        segment.delegate = self
        segment.currentSegmentIndex = 0
        segment.translatesAutoresizingMaskIntoConstraints = false
        
        return segment
    }()
    
    private let divider = Divider()
    
    private lazy var officeCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .theme.background
        
        setupNavigationBar()
        setupLayout()
        configureDataSource()
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
        view.addSubview(titleView)
        view.addSubview(ellipseSegment)
        view.addSubview(divider)
        
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
    }
}

// MARK: Delegate
extension OfficeViewController: EllipseSegmentControlDelegate {
    func ellipseSegment(didSelectItemAt index: Int) {
        print(index)
    }
}
