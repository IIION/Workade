//
//  NearbyPlaceView.swift
//  Workade
//
//  Created by ryu hyunsun on 2022/10/19.
//

import Foundation
import UIKit

class NearbyPlaceViewController: UIViewController {
    private lazy var introduceButton: UIButton = {
        var button = UIButton()
        button.setTitle("소개", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .heavy)
        button.tag = 0
//        button.addTarget(self, action: #selector, for: .touchUpInside)
        
        return button
    }()
    
    private lazy var gallaryButton: UIButton = {
        var button = UIButton()
        button.setTitle("갤러리", for: .normal)
        button.setTitleColor(UIColor.gray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .heavy)
        button.tag = 1
//        button.addTarget(self, action: #selector, for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: 여기는 나중에 최상단 뷰에서 white로 지정해주면 없애기.
        view.backgroundColor = .white
    }
}
