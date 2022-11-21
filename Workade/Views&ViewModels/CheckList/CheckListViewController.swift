//
//  CheckListViewController.swift
//  Workade
//
//  Created by Wonhyuk Choi on 2022/10/19.
//

import UIKit

enum EditState {
    case edit, none
}

class CheckListViewController: UIViewController {
    private var checkListViewModel = CheckListViewModel()
    private var editState = EditState.none
    
    private lazy var editButton: UIBarButtonItem = {
        let button = UIButton(type: .custom)
        var config = UIButton.Configuration.plain()
        config.imagePadding = 4
        config.cornerStyle = .capsule
        config.contentInsets = NSDirectionalEdgeInsets.init(top: 10, leading: 14, bottom: 10, trailing: 14)
        
        var attributedEditText = AttributedString.init("편집")
        attributedEditText.font = .customFont(for: .caption)
        var attributedCompleteText = AttributedString.init("완료")
        attributedCompleteText.font = .customFont(for: .caption)
        config.attributedTitle = attributedEditText
        config.image = UIImage.fromSystemImage(name: "pencil", font: .systemFont(ofSize: 15, weight: .bold), color: .theme.workadeBlue)
        
        button.configuration = config
        button.tintColor = .theme.workadeBlue
        button.backgroundColor = .theme.workadeBackgroundBlue
        button.layer.cornerRadius = 20
        button.addAction(UIAction(handler: { [weak self] _ in
            if let self = self {
                if self.editState == .edit {
                    self.editState = .none
                    config.image = UIImage.fromSystemImage(name: "pencil", font: .systemFont(ofSize: 15, weight: .bold), color: .theme.workadeBlue)
                    config.attributedTitle = attributedEditText
                    button.configuration = config
                    self.checklistCollectionView.reloadData()
                } else {
                    self.editState = .edit
                    config.image = nil
                    config.attributedTitle = attributedCompleteText
                    button.configuration = config
                    self.checklistCollectionView.reloadData()
                }
            }
        }), for: .touchUpInside)
        
        let barButtonItem = UIBarButtonItem(customView: button)
        
        return barButtonItem
    }()
    
    private let checkListLabel: UILabel = {
        let label = UILabel()
        label.text = "체크리스트"
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
        view.backgroundColor = .theme.background
        
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
    
    @objc private func popToGuideHomeViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func deleteButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: "정말로 해당 체크리스트를 삭제하시겠어요?\n한 번 삭제하면 다시 복구할 수 없어요.", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { _ in
            guard let cid = self.checkListViewModel.checkList[sender.tag].cid else { return }
            NotificationCenter.default.post(
                name: NSNotification.Name("deleteCheckList"),
                object: cid,
                userInfo: nil
            )
        }))
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        self.present(alert, animated: true)
    }
    
    @objc func deleteCheckListNotification(_ notification: Notification) {
        guard let cid = notification.object as? String else { return }
        guard let index = self.checkListViewModel.checkList.firstIndex(where: { $0.cid == cid }) else { return }
        self.checkListViewModel.deleteCheckList(at: index)
        self.checklistCollectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
        for trailingIndex in stride(from: index, through: checkListViewModel.checkList.count-1, by: 1) {
            self.checklistCollectionView.reloadItems(at: [IndexPath(row: trailingIndex, section: 0)])
        }
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
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = editButton
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: SFSymbol.chevronLeft.image,
            style: .done,
            target: self,
            action: #selector(popToGuideHomeViewController)
        )
        navigationController?.navigationBar.tintColor = .theme.primary
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
        if editState == .none {
            if indexPath.row == checkListViewModel.checkList.count {
                checkListViewModel.addCheckList()
                self.checklistCollectionView.insertItems(at: [indexPath])
                let indexPathArray = stride(from: 0, to: checkListViewModel.checkList.count-1, by: 1).map { index in
                    IndexPath(row: index, section: 0)
                }
                self.checklistCollectionView.reloadItems(at: indexPathArray)
            }
            let detailViewController = CheckListDetailViewController()
            
            detailViewController.selectedCheckList = checkListViewModel.checkList[indexPath.row]
            
            self.navigationController?.pushViewController(detailViewController, animated: true)
        }
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
            cell.setupCell(checkList: checkList)
            
            if editState == .edit {
                cell.isDeleteMode = true
            } else {
                cell.isDeleteMode = false
            }
            
            return cell
        }
    }
}
