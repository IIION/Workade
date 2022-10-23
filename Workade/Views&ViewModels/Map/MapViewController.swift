//
//  MapViewController.swift
//  Workade
//
//  Created by Inho Choi on 2022/10/23.
//

import NMapsMap
import UIKit

class MapViewController: UIViewController {
    lazy var map = NMFMapView()
    private var topInfoStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.backgroundColor = .clear
        stackView.axis = .horizontal
        stackView.alignment = .trailing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    private var officeNameLabel: BasePaddingLabel = {
        var label = BasePaddingLabel(padding: UIEdgeInsets(top: 12, left: 40, bottom: 12, right: 40))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "제주 O-PEACE"
        label.textAlignment = .center
        label.backgroundColor = .theme.background
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 20
        label.font = UIFont.customFont(for: .subHeadline)
        
        return label
    }()
    private lazy var backButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.setTitle("X", for: .normal)
        button.titleLabel?.font = UIFont(name: "SF Pro Rounded", size: 17)
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.cornerRadius = 22
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(backButtonDown), for: .touchDown)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNMap()
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(map)
        
        view.addSubview(topInfoStackView)
        NSLayoutConstraint.activate([
            topInfoStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topInfoStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topInfoStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topInfoStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44)
        ])
        
        setupTopInfoViewLayout()
    }
    
    private func setupNMap() {
        map.frame = view.frame
    }
    
    private func setupTopInfoViewLayout() {
        topInfoStackView.addSubview(officeNameLabel)
        NSLayoutConstraint.activate([
            officeNameLabel.centerXAnchor.constraint(equalTo: topInfoStackView.centerXAnchor),
            officeNameLabel.centerYAnchor.constraint(equalTo: topInfoStackView.centerYAnchor)
        ])
        
        topInfoStackView.addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: topInfoStackView.topAnchor),
            backButton.bottomAnchor.constraint(equalTo: topInfoStackView.bottomAnchor),
            backButton.trailingAnchor.constraint(equalTo: topInfoStackView.trailingAnchor, constant: -20),
            backButton.leadingAnchor.constraint(equalTo: topInfoStackView.leadingAnchor, constant: UIScreen.main.bounds.width - 64)
        ])
    }
    
    @objc private func backButtonDown() {
        print("Back Button Pushed")
    }
}
