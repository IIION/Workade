//
//  MagazineViewController.swift
//  Workade
//
//  Created by Hong jeongmin on 2022/10/17.
//

import UIKit

class MagazineViewController: UIViewController {
    private let viewModel = MagazineViewModel()
    
    // MARK: UI 컴포넌트
    private let titleView = TitleLabel(title: "매거진")
    
    private lazy var ellipseSegment: UIView = {
        let segment = EllipseSegmentControl(items: ["전체", "팁", "칼럼", "후기", "찜한 리스트"])
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .theme.background
        
        setupNavigationBar()
        setupLayout()
    }
}

private extension MagazineViewController {
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
extension MagazineViewController: EllipseSegmentControlDelegate {
    func ellipseSegment(didSelectItemAt index: Int) {
        print(index)
    }
}

extension MagazineViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
