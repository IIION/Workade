//
//  UICollectionView+.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/10/20.
//

import UIKit

// MARK: Cell 등록을 간편하게 하기위한 확장
extension UICollectionView {
    
    /**
     컬렉션 뷰 셀 등록 과정을 간편하게 할 수 있게 하는 확장 인스턴스 메서드
     - **before**: *register(SomeCollectionViewCell.self, forCellWithReuseIdentifier: SomeCollectionViewCell.identifier)*
     - **after**: *register(cell: SomeCollectionViewCell.self)*
     */
    func register<T: UICollectionViewCell>(cell: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.identifier)
    }
    
    /**
     컬렉션 뷰의 재사용 셀 등록 과정을 관편하게 할 수 있게 하는 확장 인스턴스 메서드
     - **before**: *let cell = collectionView.dequeueReusableCell(withReuseIdentifier:SomeCollectionViewCell.identifier, for: indexPath) as! SomeCollectionViewCell*
     - **after**: *let cell = SomeCollectionViewCell = collectionView.dequeue(for: indexPath)*
     */
    func dequeue<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(
            withReuseIdentifier: T.identifier,
            for: indexPath) as? T else { return T() }
        
        return cell
    }
    
    /**
     기존 HorizontalCollectionView를 convenience init 정의 형태로 쓸 수 있도록 추가
     - itemSize: 셀 사이즈
     - spacing: 줄 간격
     - inset: 컨텐츠 영역 inset
     - direction: 스크롤 방향
    
     collectionView를 만들고 layout을 정의할 때, 넣는 요소들을 한 번에 넣으면서 초기화를 할 수 있습니다.
     세로, 가로 방향 선택해서 모두 지원가능합니다. 기존 HorizontalCollectionView를 이걸로 대체하면 됩니다.
     아직 HorizontalCollectionView를 사용하는 곳이 있는 것으로 알고 있어서 남겨놓겠습니다.
     다른 프로퍼티를 가지는 것도 아니고 초기화 구문에서 모두 처리할 수 있는 것이기에 커스텀 클래스로 빼기보단 편의이니셜라이저 방향이 더 적절해 보였습니다.
     */
    convenience init(itemSize: CGSize, spacing: CGFloat = 20,
                     inset: UIEdgeInsets = .init(top: 0, left: 20, bottom: 0, right: 20), direction: UICollectionView.ScrollDirection) {
        self.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = itemSize
        layout.minimumLineSpacing = spacing
        layout.scrollDirection = direction
        layout.sectionInset = inset
        self.backgroundColor = .clear
        self.collectionViewLayout = layout
        self.showsHorizontalScrollIndicator = false
    }
}

// ref. https://nemecek.be/blog/82/useful-extensions-for-collectionview-and-compositional-layout
