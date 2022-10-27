//
//  NearbyPlaceView.swift
//  Workade
//
//  Created by ryu hyunsun on 2022/10/19.
//

import UIKit

class NearbyPlaceViewController: UIViewController {
    var office: Office
    
    private let nearbyPlaceView = NearbyPlaceView()
    
    init(office: Office) {
        self.office = office
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func loadView() {
        super.loadView()
        view = nearbyPlaceView
    }
}
