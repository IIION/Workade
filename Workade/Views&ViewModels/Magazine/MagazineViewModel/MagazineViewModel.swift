//
//  MagazineListViewModel.swift
//  Workade
//
//  Created by Hong jeongmin on 2022/10/27.
//

import UIKit

@MainActor
final class MagazineViewModel {
    private var magazines = [MagazineModel]()
    
    var isCompleteFetch = Binder(false)
    
    init() {
        requestMagazineData()
    }
    
    func requestMagazineData() {
        Task {
            do {
                let resource: MagazineResource = try await NetworkManager.shared.requestResourceData(from: Constants.Address.magazineResource)
                magazines = resource.content
                self.setupMagazineModelsBookmark()
                self.isCompleteFetch.value = true
            } catch {
                let error = error as? NetworkError ?? .unknownError
                print(error.message)
            }
        }
    }
}

extension MagazineViewModel {
    /// filter and return data for diffableDataSource's snapshot
    func filteredMagazine(category: MagazineCategory) -> [MagazineModel] {
        switch category {
        case .total:
            return magazines
        case .wishList:
            return magazines.filter { $0.isBookmark }
        default:
            return magazines.filter { $0.category == category }
        }
    }
    
    typealias Size = NSCollectionLayoutSize
    /// create MagazineCollectionView's Compositional Layout
    func createLayout() -> UICollectionViewLayout {
        let itemSize = Size(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = Size(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1.33))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(20)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 20, leading: 20, bottom: 30, trailing: 20)
        section.interGroupSpacing = 20
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

extension MagazineViewModel {
    /// 북마크값 세팅. 추후 서버관리로직으로 변경될 부분.
    func setupMagazineModelsBookmark() {
        let wishList = UserDefaultsManager.shared.loadUserDefaults(key: Constants.Key.wishMagazine)
        magazines.enumerated().forEach({ index, magazine in
            if wishList.contains(magazine.title) {
                magazines[index].isBookmark = true
            } else {
                magazines[index].isBookmark = false
            }
        })
    }
}

/*
 기존 북마크 로직 -> 다른 곳에서의 변화를 binding을 통해서 받아서 비동기적으로 변화하는 로직.
 
 변경될 로직 -> 각자 자신의 북마크 상태는 자신이 관리한다.
 -> 처음 데이터를 fetch할 때, 해당 모델들의 imageURL등을 통해 UserDefaults를 확인해서, isBookmark값을 설정해준다. (아주 추후엔 서버에 저장될 것이라 괜춘.)
 -> 설정 완료된 모델들을 관리하는 배열에 넣는다.
 -> 그 안에서 filter 및 수정하고, snapshot을 비교하여 적절히 리로드한다.
 -> 이제 셀은 스스로 UserDefaults를 확인해서 모습을 변화시키는 것이 아닌, 새로 넘겨받은 isBookmark값을 통해서 자신의 모습을 변화시킨다.
 -> viewDidLoad가 아닌, viewWillAppear때 UserDefaults를 확인한다.
 -> 확인해서 기존에 저장되어있던 itemIdentifier들의 isBookmark값을 적절히 조절하고, snapshot을 reload하면 된다. -> 가이드홈뷰모델의 매거진배열과 매거진뷰모델의 매거진배열은 이름이 같을지라도 서로 uuid가 다른 놈이다. 그렇기에 UserDefaults 확인하는 로직을 시간복잡도를 최대한 고려해서 짜야할것같다.
 -> 그럼 기존에 singleTon으로 관리되던 binding로직이 이제는 사라져도된다. 메모리를 일일이 조절안해도되고, singleTon의 testable하지않은 고질적인 문제가 해결된다.
 -> DetailView를 띄우는 것 정도는 값을 전달해서 띄우고, 그 값의 bookmark가 변경될 때 delegate패턴으로 알리고, 받는 쪽에서 snapshot을 update하면 될 것 같다. -> 라고 생각했지만, 그냥 UserDefaults로 통일하는 것이 나을 것 같다고 다시 생각한 이유는 detailView를 홈에서 띄울 때랑 magazine에서 띄울때랑 다르다는 것이라고 생각했지만, -> 그냥 GuideHome에서는 delegate를 채택하지않으면 된다.
 -> 메서드 1 -> UserDefaults에서 wish애들 로드한 채로, magazineResource를 순회하면서 contain하고 있는지 체크하고, 이에 따라 모델의 isBookmark를 설정하는 메서드.
 -> 메서드 2. -> 그 후에, snapshot을 찍는 메서드. apply. viewWillAppear타이밍 때 이 둘을 순차적으로 실행시키면 될 듯하다.
 -> request의 경우, init때 한번 호출되는데, 이 때도 UserDefaults확인이 필요하다.
 */
