//
//  TestViewController.swift
//  Workade
//
//  Created by Hong jeongmin on 2022/11/22.
//

// TODO: 삭제될 뷰 컨트롤러
import UIKit

/*
 해당 뷰 컨트롤러는 LocationButton을 테스트 하기 위한 뷰 컨트롤러 입니다.
 
 테스트 용도로 사용되므로 merge되기 직전 혹은 merge된 이후 삭제될 뷰 컨트롤러 입니다.
 */

class TestViewController: UIViewController {
    // 테스트를 위해 현재 바인더 값은 Busan으로 설정합니다.
    var selectedRegion: Binder<TestRegion?> = Binder(TestRegion(rawValue: TestRegion.busan.rawValue))
    
    // 현재 선택된 버튼과 일치할 경우
    private lazy var selectButton: LocationButton = {
        let button = LocationButton(region: TestRegion.busan.rawValue, selectedRegion: selectedRegion, peopleCount: 23)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    // 현재 선택되지 않은 버튼일 경우
    private lazy var basicButton: LocationButton = {
        let button = LocationButton(region: TestRegion.seoul.rawValue, selectedRegion: selectedRegion, peopleCount: 23)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        
        view.addSubview(selectButton)
        NSLayoutConstraint.activate([
            selectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            selectButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        view.addSubview(basicButton)
        NSLayoutConstraint.activate([
            basicButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            basicButton.topAnchor.constraint(equalTo: selectButton.bottomAnchor, constant: 30)
        ])
    }

}
