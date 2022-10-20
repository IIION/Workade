//
//  MagazineViewController.swift
//  Workade
//
//  Created by Hong jeongmin on 2022/10/17.
//

import UIKit

class MagazineViewController: UIViewController {
    // MARK: 컴포넌트 설정
    private let viewTitle: UILabel = {
        let label = UILabel()
        label.text = "매거진"
        label.font = .customFont(for: .title2)
        label.textColor = .theme.primary
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var customTab: UISegmentedControl = {
        let segmentedControl = CustopSegmentController(items: ["전체", "팁", "칼럼", "후기"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        return segmentedControl
    }()
    
    private let line: UIView = {
        let line = UIView()
        line.backgroundColor = .theme.quaternary
        line.translatesAutoresizingMaskIntoConstraints = false
        
        return line
    }()
    
    private let totalDetailVC = TotalDetailViewController()
    private let tipDetailVC = TipDetailViewController()
    private let columnnDetailVC = ColumnDetailViewController()
    private let reviewDetailVC = ReviewDetailViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .theme.background
        
        setupSegmentControl()
        setupLayout()
    }
    
    // MARK: AutoLayout 설정
    private func setupLayout() {
        view.addSubview(viewTitle)
        let viewTitleLayout = [
            viewTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            viewTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ]
        
        view.addSubview(customTab)
        let customTabLayout = [
            customTab.topAnchor.constraint(equalTo: viewTitle.bottomAnchor, constant: 14),
            customTab.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            customTab.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            customTab.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        view.addSubview(line)
        let lineLayout = [
            line.topAnchor.constraint(equalTo: customTab.bottomAnchor, constant: 10),
            line.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            line.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            line.heightAnchor.constraint(equalToConstant: 2)
        ]
        
        NSLayoutConstraint.activate(viewTitleLayout)
        NSLayoutConstraint.activate(customTabLayout)
        NSLayoutConstraint.activate(lineLayout)
    }
    
    func setupSegmentControl() {
        self.customTab.setTitleTextAttributes(
            [
                NSAttributedString.Key.foregroundColor: UIColor.theme.quaternary,
                .font: UIFont.customFont(for: .headline)
            ], for: .normal)
        self.customTab.setTitleTextAttributes(
            [
                NSAttributedString.Key.foregroundColor: UIColor.theme.primary,
                .font: UIFont.customFont(for: .headline)
            ],
            for: .selected
        )
        self.customTab.selectedSegmentIndex = 0
    }
}

import SwiftUI

struct MagazineViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = MagazineViewController
    
    func makeUIViewController(context: Context) -> MagazineViewController {
        return MagazineViewController()
    }
    
    func updateUIViewController(_ uiViewController: MagazineViewController, context: Context) {}
}

@available(iOS 13.0.0, *)
struct MagazineViewControllerPreview: PreviewProvider {
    static var previews: some View {
        MagazineViewControllerRepresentable()
    }
}
