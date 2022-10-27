//
//  MagazineViewController.swift
//  Workade
//
//  Created by Hong jeongmin on 2022/10/17.
//

import UIKit

class MagazineViewController: UIViewController {
    // total로 명시한 이유 -> 추후에는 여기서 Magazine의 category에 맞게 분류하는 작업이 이뤄져야할 것입니다.
    // 지금은 넘기는 형태이지만, 추후에는 매거진뷰컨의 뷰모델이 바로 이미지를 불러도됩니다. 그럼 적절히 캐시에 있는 매거진은 빠르게, 그렇지않으면 조금의 로딩 후에 들어올 것입니다.
    var totalMagazine: [Magazine]?
    
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
        let segmentedControl = CustomSegmentedControl(items: ["전체", "팁", "칼럼", "후기"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.addTarget(self, action: #selector(tabClicked(tab:)), for: UIControl.Event.valueChanged)
        
        return segmentedControl
    }()
    
    private let line: UIView = {
        let line = UIView()
        line.backgroundColor = .theme.quaternary
        line.translatesAutoresizingMaskIntoConstraints = false
        
        return line
    }()
    
    private let totalDetailViewContoller: UIViewController = {
        let viewController = TotalDetailViewController()
        viewController.view.isHidden = false
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        return viewController
    }()
    
    private let tipDetailViewContoller: UIViewController = {
        let viewController = TipDetailViewController()
        viewController.view.isHidden = true
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        return viewController
    }()
    
    private let columnDetailViewController: UIViewController = {
        let viewController = ColumnDetailViewController()
        viewController.view.isHidden = true
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        return viewController
    }()
    
    private let reviewDetailViewController: UIViewController = {
        let viewController = ReviewDetailViewController()
        viewController.view.isHidden = true
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        return viewController
    }()
    
    // TODO: 추후 내비게이션 연동시 삭제할 프로퍼티
    private let tempView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let tempBackButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = .theme.primary
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .theme.background
        
        setupSegmentedControl()
        setupLayout()
        setupLayoutDetailView()
    }
    
    // MARK: AutoLayout 설정
    private func setupLayout() {
        // TODO: 추후 네비게이션 연결 시 삭제될 레이아웃
        view.addSubview(tempView)
        NSLayoutConstraint.activate([
            tempView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tempView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            tempView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            tempView.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        // TODO: 추후 네비게이션 연결 시 삭제될 레이아웃
        tempView.addSubview(tempBackButton)
        NSLayoutConstraint.activate([
            tempBackButton.leadingAnchor.constraint(equalTo: tempView.leadingAnchor)
        ])
        
        view.addSubview(viewTitle)
        NSLayoutConstraint.activate([
            //            viewTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            
            // TODO: 추후 네비게이션 연결시 바로위 주석코드가 작성됩니다.
            viewTitle.topAnchor.constraint(equalTo: tempView.bottomAnchor, constant: 20),
            viewTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        view.addSubview(customTab)
        NSLayoutConstraint.activate([
            customTab.topAnchor.constraint(equalTo: viewTitle.bottomAnchor, constant: 14),
            customTab.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            customTab.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            customTab.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        view.addSubview(line)
        NSLayoutConstraint.activate([
            line.topAnchor.constraint(equalTo: customTab.bottomAnchor, constant: 10),
            line.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            line.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            line.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
    
    private func setupLayoutDetailView() {
        view.addSubview(totalDetailViewContoller.view)
        NSLayoutConstraint.activate([
            totalDetailViewContoller.view.topAnchor.constraint(equalTo: line.bottomAnchor),
            totalDetailViewContoller.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            totalDetailViewContoller.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            totalDetailViewContoller.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        view.addSubview(tipDetailViewContoller.view)
        NSLayoutConstraint.activate([
            tipDetailViewContoller.view.topAnchor.constraint(equalTo: line.bottomAnchor),
            tipDetailViewContoller.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tipDetailViewContoller.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tipDetailViewContoller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.addSubview(columnDetailViewController.view)
        NSLayoutConstraint.activate([
            columnDetailViewController.view.topAnchor.constraint(equalTo: line.bottomAnchor),
            columnDetailViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            columnDetailViewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            columnDetailViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        view.addSubview(reviewDetailViewController.view)
        NSLayoutConstraint.activate([
            reviewDetailViewController.view.topAnchor.constraint(equalTo: line.bottomAnchor),
            reviewDetailViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            reviewDetailViewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            reviewDetailViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setupSegmentedControl() {
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
    
    @objc
    func tabClicked(tab: UISegmentedControl) {
        switch tab.selectedSegmentIndex {
        case 0:
            totalDetailViewContoller.view.isHidden = false
            tipDetailViewContoller.view.isHidden = true
            columnDetailViewController.view.isHidden = true
            reviewDetailViewController.view.isHidden = true
            
        case 1:
            totalDetailViewContoller.view.isHidden = true
            tipDetailViewContoller.view.isHidden = false
            columnDetailViewController.view.isHidden = true
            reviewDetailViewController.view.isHidden = true
            
        case 2:
            totalDetailViewContoller.view.isHidden = true
            tipDetailViewContoller.view.isHidden = true
            columnDetailViewController.view.isHidden = false
            reviewDetailViewController.view.isHidden = true
            
        case 3:
            totalDetailViewContoller.view.isHidden = true
            tipDetailViewContoller.view.isHidden = true
            columnDetailViewController.view.isHidden = true
            reviewDetailViewController.view.isHidden = false
            
        default:
            return
        }
    }
}
