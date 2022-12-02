//
//  GuideHomeViewModel.swift
//  Workade
//
//  Created by Inho Choi on 2022/10/18.
//

import UIKit
import Combine

@MainActor
final class GuideHomeViewModel {
    typealias Size = NSCollectionLayoutSize
    private var bookmarkManager = BookmarkManager.shared
    private var networkMonitor = NetworkMonitor()
    private var anycancellables = Set<AnyCancellable>()
    
    private(set) var officeResource = OfficeResource()
    private(set) var magazineResource = MagazineResource()
    
    /// 모델 데이터 fetch가 완료되었을 때, GuideHomeViewController에 알려주는 역할을 할 Binder 타입의 변수
    private(set) var isCompleteFetch = Binder(false)
    
    init() {
        bindMonitor()
        requestHomeData()
        bindingBookmarkManager() // 북마크
    }
    
    private func bindMonitor() {
        networkMonitor.becomeSatisfied
            .sink { [weak self] _ in
                print("트리거왔다.")
                self?.isCompleteFetch.value = true
            }
            .store(in: &anycancellables)
    }
    
    private func requestHomeData() {
        Task {
            do {
                async let offices: OfficeResource = NetworkManager.shared.requestResourceData(from: Constants.Address.officeResource)
                async let magazines: MagazineResource = NetworkManager.shared.requestResourceData(from: Constants.Address.magazineResource)
                (officeResource, magazineResource) = try await (offices, magazines)
                isCompleteFetch.value = true
            } catch {
                let error = error as? NetworkError ?? .unknownError
                print(error.message)
            }
        }
    }
    
    // MARK: 북마크 Logic in ViewModel (init시에 bindingBookmarkManager()호출)
    
    /// 눌린 북마크의 id를 cell - viewController - viewModel - bookmarkManager 흐름으로 알립니다.
    private(set) var clickedMagazineId = Binder("")
    
    /// Manager -> ViewModel -> ViewController
    private func bindingBookmarkManager() {
        bookmarkManager.clickedMagazineId.bind(at: .home) { [weak self] id in
            guard let self = self else { return }
            self.clickedMagazineId.value = id
        }
    }
    
    /// ViewController -> ViewModel -> Manager
    func notifyClickedMagazineId(title id: String, key: String) {
        bookmarkManager.notifyClickedMagazineId(title: id, key: key)
    }
    
    deinit {
        BookmarkManager.shared.clickedMagazineId.remove(at: .home)
    }
}

// MARK: GuideHomeVC 레이아웃 관련
extension GuideHomeViewModel {
    func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { [weak self] (sectionIndex: Int, _: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            guard let sectionCase = GuideHomeSection(rawValue: sectionIndex) else { return nil }
            // 전달받은 섹션 index별 알맞는 섹션을 생성
            var section: NSCollectionLayoutSection!
            switch sectionCase {
            case .office:
                section = self.createOfficeSection()
            case .magazine:
                section = self.createMagazineSection()
            case .checkList:
                section = self.createCheckListSection()
            }
            return section
        }
        
        // 이하 전체 컬렉션뷰의 설정
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        config.scrollDirection = .vertical
        
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: config)
    }
    
    // office section layout
    private func createOfficeSection() -> NSCollectionLayoutSection {
        let itemSize = Size(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = Size(widthDimension: .estimated(280), heightDimension: .estimated(180))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.edgeSpacing = .init(leading: nil, top: .fixed(60), trailing: nil, bottom: nil)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
        section.interGroupSpacing = 10
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        
        let headerSize = Size(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            containerAnchor: .init(edges: .top, absoluteOffset: .init(x: 0, y: 10)))
        section.boundarySupplementaryItems = [header] // for header
        
        return section
    }
    
    // magazine section layout
    private func createMagazineSection() -> NSCollectionLayoutSection {
        let itemSize = Size(widthDimension: .fractionalWidth(1), heightDimension: .absolute(180))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = Size(widthDimension: .absolute(130), heightDimension: .absolute(190))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
        section.interGroupSpacing = 10
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        
        let headerSize = Size(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        section.boundarySupplementaryItems = [header] // for header
        
        return section
    }
    
    // checkList section layout
    private func createCheckListSection() -> NSCollectionLayoutSection {
        let itemSize = Size(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = Size(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.53))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
        group.edgeSpacing = .init(leading: nil, top: nil, trailing: nil, bottom: .fixed(30))
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
        
        return section
    }
}
