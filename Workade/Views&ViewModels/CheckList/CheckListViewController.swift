//
//  CheckListViewController.swift
//  Workade
//
//  Created by Wonhyuk Choi on 2022/10/19.
//

import UIKit
import SwiftUI

class CheckListViewController: UIViewController {
    private var checkListViewModel = CheckListViewModel()
    private var editState = EditState.none
    
    private lazy var editButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(
            title: "편집",
            style: .plain,
            target: self,
            action: #selector(editButtonPressed(_:))
        )
        barButtonItem.tintColor = .black
        
        return barButtonItem
    }()
    
    private let checkListLabel: UILabel = {
        let label = UILabel()
        label.text = "Checklist"
        label.font = UIFont.customFont(for: .title2)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var checklistCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(CheckListCell.self, forCellWithReuseIdentifier: CheckListCell.identifier)
        collectionView.register(CheckListAddButtonCell.self, forCellWithReuseIdentifier: CheckListAddButtonCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        self.setupNavigationBar()
        self.setupLayout()
        self.checkListViewModel.loadCheckList()
        self.checklistCollectionView.reloadData()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(deleteCheckListNotification(_:)),
            name: NSNotification.Name("deleteCheckList"),
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(editCheckListNotification(_:)),
            name: NSNotification.Name("editCheckList"),
            object: nil
        )
    }
    
    @objc private func editButtonPressed(_ sender: UIBarButtonItem) {
        if editState == .edit {
            editState = .none
            editButton.title = "편집"
            checklistCollectionView.reloadData()
        } else {
            editState = .edit
            editButton.title = "완료"
            checklistCollectionView.reloadData()
        }
    }
    
    @objc private func deleteButtonPressed(_ sender: UIButton) {
        guard let cid = self.checkListViewModel.checkList[sender.tag].cid else { return }
        NotificationCenter.default.post(
            name: NSNotification.Name("deleteCheckList"),
            object: cid,
            userInfo: nil
        )
    }
    
    @objc func deleteCheckListNotification(_ notification: Notification) {
        guard let cid = notification.object as? String else { return }
        guard let index = self.checkListViewModel.checkList.firstIndex(where: { $0.cid == cid }) else { return }
        self.checkListViewModel.deleteCheckList(at: index)
        self.checklistCollectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
        self.checklistCollectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
    }
    
    @objc func editCheckListNotification(_ notification: Notification) {
        guard let checkList = notification.object as? CheckList else { return }
        guard let index = self.checkListViewModel.checkList.firstIndex(where: { $0.cid == checkList.cid }) else { return }
        checkListViewModel.updateCheckList(at: index, checkList: checkList)
        self.checklistCollectionView.reloadData()
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
            checklistCollectionView.topAnchor.constraint(equalTo: checkListLabel.bottomAnchor, constant: 20),
            checklistCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            checklistCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            checklistCollectionView.bottomAnchor.constraint(equalTo: guide.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(checkListLabelConstraints)
        NSLayoutConstraint.activate(checklistCollectionViewConstraints)
    }
}

extension CheckListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: (UIScreen.main.bounds.width / 2) - 30, height: 165)
        }
}

extension CheckListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == checkListViewModel.checkList.count {
            checkListViewModel.addCheckList()
            self.checklistCollectionView.insertItems(at: [indexPath])
            self.checklistCollectionView.reloadItems(at: [indexPath])
        }
        let detailViewController = CheckListDetailViewController()
        
        detailViewController.selectedCheckListIndex = indexPath.row
        detailViewController.selectedCheckList = checkListViewModel.checkList[indexPath.row]
        
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension CheckListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if editState == .edit {
            return checkListViewModel.checkList.count
        } else {
            return checkListViewModel.checkList.count + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == checkListViewModel.checkList.count {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CheckListAddButtonCell.identifier, for: indexPath)
                    as? CheckListAddButtonCell else {
                return UICollectionViewCell()
            }
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CheckListCell.identifier, for: indexPath)
                    as? CheckListCell else {
                return UICollectionViewCell()
            }
            
            cell.deleteButton.tag = indexPath.row
            cell.deleteButton.addTarget(self, action: #selector(deleteButtonPressed(_:)), for: .touchUpInside)
            
            let checkList = checkListViewModel.checkList[indexPath.row]
            cell.setup(checkList: checkList)
            
            if editState == .edit {
                cell.isDeleteMode = true
            } else {
                cell.isDeleteMode = false
            }
            
            return cell
        }
    }
}

enum EditState {
    case edit, none
}

struct CheckListViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = CheckListViewController

    func makeUIViewController(context: Context) -> CheckListViewController {
        return CheckListViewController()
    }

    func updateUIViewController(_ uiViewController: CheckListViewController, context: Context) {}
}

struct CheckListViewControllerPreview: PreviewProvider {
    static var previews: some View {
        CheckListViewControllerRepresentable()
            .ignoresSafeArea()
    }
}
