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
    
    private lazy var totalTabButton: UIButton = {
        var button = UIButton()
        button.setTitle("전체", for: .normal)
        button.setTitleColor(.theme.primary, for: .normal)
        button.titleLabel?.font = .customFont(for: .headline)
        button.tag = 0
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var tipTabButton: UIButton = {
        var button = UIButton()
        button.setTitle("팁", for: .normal)
        button.setTitleColor(.theme.quaternary, for: .normal)
        button.titleLabel?.font = .customFont(for: .headline)
        button.tag = 1
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var columnTabButton: UIButton = {
        var button = UIButton()
        button.setTitle("칼럼", for: .normal)
        button.setTitleColor(.theme.quaternary, for: .normal)
        button.titleLabel?.font = .customFont(for: .headline)
        button.tag = 2
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var reviewTabButton: UIButton = {
        var button = UIButton()
        button.setTitle("후기", for: .normal)
        button.setTitleColor(.theme.quaternary, for: .normal)
        button.titleLabel?.font = .customFont(for: .headline)
        button.tag = 3
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        return button
    }()
    
    private let line: UIView = {
        let line = UIView()
        line.backgroundColor = .theme.quaternary
        line.translatesAutoresizingMaskIntoConstraints = false
        
        return line
    }()
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .clear
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    var detailView = UIViewController()
    
    private var selectedTab = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .white
        detailView = TotalDetailViewController()
        
        setupStackView()
        setupLayout()
        setupDetailView()
    }
    
    // MARK: AutoLayout 설정
    private func setupLayout() {
        view.addSubview(viewTitle)
        let viewTitleLayout = [
            viewTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            viewTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ]
        
        view.addSubview(stackView)
        let stackViewLayout = [
            stackView.topAnchor.constraint(equalTo: viewTitle.bottomAnchor, constant: 14),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            ]
        
        view.addSubview(line)
        let lineLayout = [
            line.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10),
            line.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            line.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            line.heightAnchor.constraint(equalToConstant: 2)
        ]
        
        NSLayoutConstraint.activate(viewTitleLayout)
        NSLayoutConstraint.activate(stackViewLayout)
        NSLayoutConstraint.activate(lineLayout)
    }
    
    func setupDetailView() {
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        
        setupLayout()
        
        self.addChild(detailView)
        self.view.addSubview(detailView.view)
        detailView.didMove(toParent: self)
        
        detailView.view.translatesAutoresizingMaskIntoConstraints = false
        let detailViewLayout = [
            detailView.view.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 10),
            detailView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        NSLayoutConstraint.activate(detailViewLayout)
    }
    
    func setupStackView() {
        stackView.addArrangedSubview(totalTabButton)
        stackView.addArrangedSubview(tipTabButton)
        stackView.addArrangedSubview(columnTabButton)
        stackView.addArrangedSubview(reviewTabButton)
    }
    
    @objc
    func buttonTapped(_ sender: UIButton) {
        if selectedTab != sender.tag {
            switch sender.tag {
            case 0:
                totalTabButton.setTitleColor(.theme.primary, for: .normal)
                tipTabButton.setTitleColor(.theme.quaternary, for: .normal)
                columnTabButton.setTitleColor(.theme.quaternary, for: .normal)
                reviewTabButton.setTitleColor(.theme.quaternary, for: .normal)
                selectedTab = sender.tag
                detailView = TotalDetailViewController()
                setupDetailView()
                
            case 1:
                tipTabButton.setTitleColor(.theme.primary, for: .normal)
                totalTabButton.setTitleColor(.theme.quaternary, for: .normal)
                columnTabButton.setTitleColor(.theme.quaternary, for: .normal)
                reviewTabButton.setTitleColor(.theme.quaternary, for: .normal)
                selectedTab = sender.tag
                detailView = TipDetailViewController()
                setupDetailView()
                
            case 2:
                columnTabButton.setTitleColor(.theme.primary, for: .normal)
                totalTabButton.setTitleColor(.theme.quaternary, for: .normal)
                tipTabButton.setTitleColor(.theme.quaternary, for: .normal)
                reviewTabButton.setTitleColor(.theme.quaternary, for: .normal)
                selectedTab = sender.tag
                detailView = ColumnDetailViewController()
                setupDetailView()
                
            case 3:
                reviewTabButton.setTitleColor(.theme.primary, for: .normal)
                totalTabButton.setTitleColor(.theme.quaternary, for: .normal)
                tipTabButton.setTitleColor(.theme.quaternary, for: .normal)
                columnTabButton.setTitleColor(.theme.quaternary, for: .normal)
                selectedTab = sender.tag
                detailView = ReviewDetailViewController()
                setupDetailView()
                
            default:
                return
            }
        }
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
