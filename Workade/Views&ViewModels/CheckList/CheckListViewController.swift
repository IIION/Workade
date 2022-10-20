//
//  CheckListViewController.swift
//  Workade
//
//  Created by Wonhyuk Choi on 2022/10/19.
//

import UIKit
import SwiftUI

class CheckListViewController: UIViewController {
    let editButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(
            title: "편집",
            style: .plain,
            target: nil,
            action: nil
        )
        barButtonItem.tintColor = .black
        return barButtonItem
    }()
    
    let checkListLabel: UILabel = {
        let label = UILabel()
        label.text = "Checklist"
        label.font = UIFont.customFont(for: .title2)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let checklistCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        view.backgroundColor = .systemBackground
        
        self.setupNavigationBar()
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CheckListViewController {
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = editButton
    }
    
    private func setupLayout() {
        view.addSubview(checkListLabel)
        view.addSubview(checklistCollectionView)
        
        let guide = view.safeAreaLayoutGuide
        let checkListLabelConstraints = [
            checkListLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 20),
            checkListLabel.topAnchor.constraint(equalTo: guide.topAnchor, constant: 20),
            checkListLabel.heightAnchor.constraint(equalToConstant: 22)
        ]
        
        let checklistCollectionViewConstraints = [
            checklistCollectionView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 25),
            checklistCollectionView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: 25),
            checklistCollectionView.topAnchor.constraint(equalTo: checkListLabel.bottomAnchor, constant: 20),
            checklistCollectionView.bottomAnchor.constraint(equalTo: guide.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(checkListLabelConstraints)
        NSLayoutConstraint.activate(checklistCollectionViewConstraints)
    }
}

struct CheckListViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = CheckListViewController

    func makeUIViewController(context: Context) -> CheckListViewController {
        return CheckListViewController()
    }

    func updateUIViewController(_ uiViewController: CheckListViewController, context: Context) {}
}

@available(iOS 13.0.0, *)
struct CheckListViewControllerPreview: PreviewProvider {
    static var previews: some View {
        CheckListViewControllerRepresentable()
            .ignoresSafeArea()
    }
}
