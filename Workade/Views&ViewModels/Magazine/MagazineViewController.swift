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
    var totalMagazine: [Magazine] = []
    
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
    
    private let tapDetailViewContoller: TapDetailViewController = {
        let viewController = TapDetailViewController(magazineList: [])

        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        return viewController
    }()
    
    init(totalMagazine: [Magazine]) {
        super.init(nibName: nil, bundle: nil)
        
        self.totalMagazine = totalMagazine
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .theme.background
        
        setupSegmentedControl()
        setupLayout()
        setupLayoutDetailView()
        tapDetailViewContoller.magazineList = totalMagazine
    }
    
    // MARK: AutoLayout 설정
    private func setupLayout() {
        view.addSubview(viewTitle)
        NSLayoutConstraint.activate([
            viewTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
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
            totalDetailViewContoller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.addSubview(tipDetailViewContoller.view)
        NSLayoutConstraint.activate([
            tipDetailViewContoller.view.topAnchor.constraint(equalTo: line.bottomAnchor),
            tipDetailViewContoller.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tipDetailViewContoller.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tipDetailViewContoller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.addSubview(columnDetailViewContoller.view)
        NSLayoutConstraint.activate([
            columnDetailViewContoller.view.topAnchor.constraint(equalTo: line.bottomAnchor),
            columnDetailViewContoller.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            columnDetailViewContoller.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            columnDetailViewContoller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.addSubview(reviewDetailViewContoller.view)
        NSLayoutConstraint.activate([
            reviewDetailViewContoller.view.topAnchor.constraint(equalTo: line.bottomAnchor),
            reviewDetailViewContoller.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            reviewDetailViewContoller.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            reviewDetailViewContoller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
            columnDetailViewContoller.view.isHidden = true
            reviewDetailViewContoller.view.isHidden = true
        case 1:
            totalDetailViewContoller.view.isHidden = true
            tipDetailViewContoller.view.isHidden = false
            columnDetailViewContoller.view.isHidden = true
            reviewDetailViewContoller.view.isHidden = true
        case 2:
            totalDetailViewContoller.view.isHidden = true
            tipDetailViewContoller.view.isHidden = true
            columnDetailViewContoller.view.isHidden = false
            reviewDetailViewContoller.view.isHidden = true
        case 3:
            totalDetailViewContoller.view.isHidden = true
            tipDetailViewContoller.view.isHidden = true
            columnDetailViewContoller.view.isHidden = true
            reviewDetailViewContoller.view.isHidden = false
        default:
            return
        }
    }
}
