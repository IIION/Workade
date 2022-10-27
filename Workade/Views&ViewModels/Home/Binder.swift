//
//  SingleBinder.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/10/27.
//

import Foundation

/// **mvvm 비동기 흐름에 필요한 Binder 클래스**
///
/// 상세설명은 Binder클래스가 있는 소스파일의 하단 참고.
class Binder<T: Equatable> {
    typealias Block = (T) -> Void
    var block: Block?
    
    func bind(_ block: Block?) {
        self.block = block
    }
    
    func bindAndFire(_ block: Block?) {
        self.block = block
        block?(value)
    }
    
    var value: T {
        didSet {
            if oldValue != value {
                block?(value)
            }
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
}

/*
 MARK: Binder 클래스
 - mvvm 비동기 로직 구현에 필요한 객체입니다.
 
 사용방법
 - 관찰하고자하는 값을 Binder로 래핑합니다. ex) var isBookmark = Binder(Bool)
 - 해당 값의 변화를 관찰하고자하는 곳에서 binding을 걸어줍니다.
    - ex) HomeViewModel.shared.isBookmark.bind { [weak self] 전달값 in
              (실행문)
          }
 - 해당 바인딩 클로저가 있는 메서드를 적절한 시점에 호출시켜주면, 뷰-뷰모델 사이의 연결이 성립됩니다.
 - 추후 뷰모델의 Binder value의 값을 적절히 변화시켜주면, 연결되어있는 View의 binding된 클로저가 호출되며 실행됩니다.
 - 클로저 참조 타입이기 때문에 weak self를 걸어주어야 강한 순환 참조가 일어나지않고 정상적으로 deinit될 수 있습니다.
 */

// 참고링크
// https://gyuni-archive.tistory.com/13
// https://github.com/kudoleh/iOS-Clean-Architecture-MVVM/blob/master/ExampleMVVM/Presentation/Utils/Observable.swift
