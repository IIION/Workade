//
//  CheckListDetailViewController.swift
//  Workade
//
//  Created by Wonhyuk Choi on 2022/10/21.
//

import UIKit

class CheckListDetailViewController: UIViewController {
    private var checkListDetailViewModel = CheckListDetailViewModel()
    
    var selectedCheckList: CheckList? {
        didSet {
            checkListDetailViewModel.selectedCheckList = selectedCheckList
            self.checklistTableView.reloadData()
        }
    }
    
    private lazy var deleteButton: UIBarButtonItem = {
        let button = UIButton(type: .custom)
        var config = UIButton.Configuration.plain()
        config.imagePadding = 4
        config.cornerStyle = .capsule
        config.contentInsets = NSDirectionalEdgeInsets.init(top: 10, leading: 14, bottom: 10, trailing: 14)
        
        var attributedText = AttributedString.init("삭제")
        attributedText.font = .customFont(for: .caption)
        config.attributedTitle = attributedText
        config.image = UIImage.fromSystemImage(name: "trash.fill", font: .systemFont(ofSize: 15, weight: .bold), color: .theme.workadeBlue)
        
        button.configuration = config
        button.tintColor = .theme.workadeBlue
        button.backgroundColor = .theme.workadeBackgroundBlue
        button.layer.cornerRadius = 20
        button.addAction(UIAction(handler: { [weak self] _ in
            if let self = self {
                let alert = UIAlertController(title: nil, message: "정말로 해당 체크리스트를 삭제하시겠어요?\n한 번 삭제하면 다시 복구할 수 없어요.", preferredStyle: .actionSheet)
                
                alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { _ in
                    self.checkListDetailViewModel.deleteCheckList()
                    self.navigationController?.popViewController(animated: true)
                }))
                
                alert.addAction(UIAlertAction(title: "취소", style: .cancel))
                
                self.present(alert, animated: true)
            }
        }), for: .touchUpInside)
        
        let barButtonItem = UIBarButtonItem(customView: button)
        
        return barButtonItem
    }()
    
    private lazy var titleLabel: UITextField = {
        let textField = UITextField()
        textField.text = selectedCheckList?.title ?? "제목없음"
        textField.font = .customFont(for: .title2)
        textField.tintColor = .theme.primary
        textField.addTarget(self, action: #selector(titleLabelDidChange(_:)), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "워케이션 날짜"
        label.font = .customFont(for: .footnote)
        label.tintColor = .theme.primary
        
        return label
    }()
    
    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.timeZone = .autoupdatingCurrent
        datePicker.tintColor = .theme.primary
        datePicker.date = selectedCheckList?.travelDate ?? Date()
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        
        return datePicker
    }()
    
    private lazy var dateStack: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [subtitleLabel, datePicker])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var checklistTableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.rowHeight = 52
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .theme.labelBackground
        tableView.registerCell(type: CheckListDetailCell.self, identifier: CheckListDetailCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(dateStack)
        scrollView.addSubview(checklistTableView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        return scrollView
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .custom)
        var config = UIButton.Configuration.plain()
        config.imagePadding = 9
        config.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        button.setTitle("탭해서 추가", for: .normal)
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.setTitleColor(.theme.workadeBlue, for: .normal)
        button.configuration = config
        button.tintColor = .theme.workadeBlue
    
        button.titleLabel?.font = .customFont(for: .subHeadline)
        
        button.addTarget(self, action: #selector(addButtonPressed(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var templateButton: UIButton = {
        let button = UIButton(type: .custom)
        var config = UIButton.Configuration.filled()
        config.contentInsets = NSDirectionalEdgeInsets.init(top: 14, leading: 20, bottom: 14, trailing: 20)
        config.cornerStyle = .capsule
        config.buttonSize = .large
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 10)
        
        button.setImage(UIImage(systemName: "list.bullet.clipboard.fill", withConfiguration: imageConfig), for: .normal)
        button.configuration = config
        button.tintColor = .theme.workadeBlue
        button.addTarget(self, action: #selector(templateButtonPressed(_:)), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [addButton, templateButton])
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    private var checkListTableViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .theme.background
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        self.titleLabel.delegate = self
        
        self.setupNavigationBar()
        self.setupLayout()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(addTodolistNotification(_:)),
            name: NSNotification.Name("addTodoList"),
            object: nil
        )
    }
}

// MARK: Objective-C Methods
extension CheckListDetailViewController {
    @objc private func popToCheckListViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func addButtonPressed(_ sender: UIButton) {
        guard let targetCheckList = selectedCheckList else { return }
        let todosCount = checkListDetailViewModel.todos.count
        
        checkListDetailViewModel.addTodo()
        updateCheckListTableViewConstant()
        self.checklistTableView.insertRows(at: [IndexPath(row: todosCount, section: 0)], with: .automatic)
        let indexPathArray = stride(from: 0, to: todosCount-1, by: 1).map { index in
            IndexPath(row: index, section: 0)
        }
        self.checklistTableView.reloadRows(at: indexPathArray, with: .automatic)
        checkListDetailViewModel.updateCheckList(checkList: targetCheckList)
    }
    
    @objc private func templateButtonPressed(_ sender: UIButton) {
        let bottomSheetViewController = CheckListBottomSheetViewController()
        
        bottomSheetViewController.modalPresentationStyle = .overFullScreen
        
        self.present(bottomSheetViewController, animated: false, completion: nil)
    }
    
    @objc private func checkButtonPressed(_ sender: UIButton) {
        guard let targetCheckList = selectedCheckList else { return }
        let todo = checkListDetailViewModel.todos[sender.tag]
        todo.done.toggle()
        checkListDetailViewModel.updateTodo(at: sender.tag, todo: todo)
        checkListDetailViewModel.updateCheckList(checkList: targetCheckList)
        checklistTableView.reloadData()
    }
    
    @objc private func dateChanged() {
        guard let targetCheckList = selectedCheckList else { return }
        targetCheckList.travelDate = datePicker.date
        checkListDetailViewModel.updateCheckList(checkList: targetCheckList)
    }
    
    @objc private func titleLabelDidChange(_ textField: UITextField) {
        if (textField.text?.count ?? 4) >= 12 {
            self.presentPopOver()
        }
    }
    
    @objc func addTodolistNotification(_ notification: Notification) {
        guard let todoList = notification.object as? [String] else { return }
        guard let targetCheckList = selectedCheckList else { return }
        let todosCount = checkListDetailViewModel.todos.count
        
        for todo in todoList {
            checkListDetailViewModel.addTodo(todo)
            updateCheckListTableViewConstant()
            self.checklistTableView.insertRows(at: [IndexPath(row: todosCount, section: 0)], with: .automatic)
            
        }
        let indexPathArray = stride(from: 0, to: todosCount-1, by: 1).map { index in
            IndexPath(row: index, section: 0)
        }
        self.checklistTableView.reloadRows(at: indexPathArray, with: .automatic)
        checkListDetailViewModel.updateCheckList(checkList: targetCheckList)
    }
}

extension CheckListDetailViewController {
    private func setupNavigationBar() {
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = deleteButton
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: SFSymbol.chevronLeft.image,
            style: .done,
            target: self,
            action: #selector(popToCheckListViewController)
        )
    }
    
    private func setupLayout() {
        view.addSubview(scrollView)
        view.addSubview(buttonStack)
        
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 20),
            scrollView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -20),
            scrollView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -70)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            dateStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            dateStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20)
        ])
        
        checkListTableViewHeightConstraint = checklistTableView
            .heightAnchor
            .constraint(equalToConstant: CGFloat(52 * (checkListDetailViewModel.todos.count + 1)))
        
        NSLayoutConstraint.activate([
            checklistTableView.topAnchor.constraint(equalTo: dateStack.bottomAnchor, constant: 20),
            checklistTableView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            checklistTableView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            checklistTableView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            checklistTableView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            checkListTableViewHeightConstraint
        ])
        
        NSLayoutConstraint.activate([
            buttonStack.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 20),
            buttonStack.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -20),
            buttonStack.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -26),
            buttonStack.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 10)
        ])
    }
    
    func updateCheckListTableViewConstant() {
        checkListTableViewHeightConstraint.constant = CGFloat(52 * (checkListDetailViewModel.todos.count + 1))
    }
}

extension CheckListDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        "삭제"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let targetCheckList = selectedCheckList else { return }
            self.checkListDetailViewModel.deleteTodo(at: indexPath.row)
            self.checklistTableView.deleteRows(at: [indexPath], with: .automatic)
            let indexPathArray = stride(from: indexPath.row, to: checkListDetailViewModel.todos.count-1, by: 1).map { index in
                IndexPath(row: index, section: 0)
            }
            self.checklistTableView.reloadRows(at: indexPathArray, with: .automatic)
            checkListDetailViewModel.updateCheckList(checkList: targetCheckList)
            updateCheckListTableViewConstant()
        }
    }
}

extension CheckListDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checkListDetailViewModel.todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueCell(withType: CheckListDetailCell.self, for: indexPath) as? CheckListDetailCell else {
            return UITableViewCell()
        }
        
        cell.checkButton.tag = indexPath.row
        cell.checkButton.addTarget(self, action: #selector(checkButtonPressed(_:)), for: .touchUpInside)
        cell.contentText.tag = indexPath.row
        cell.contentText.delegate = self
        
        let todo = checkListDetailViewModel.todos[indexPath.row]
        cell.setupCell(todo: todo)
        
        return cell
    }
}

extension CheckListDetailViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == titleLabel {
            guard let targetCheckList = selectedCheckList else { return }
            if textField.text == "" {
                textField.text = "제목없음"
            }
            targetCheckList.title = textField.text
            checkListDetailViewModel.updateCheckList(checkList: targetCheckList)
        } else {
            let todo = checkListDetailViewModel.todos[textField.tag]
            if textField.text == "" {
                textField.text = "내용없음"
            }
            todo.content = textField.text
            checkListDetailViewModel.updateTodo(at: textField.tag, todo: todo)
            checklistTableView.reloadData()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == titleLabel {
            let maxLength = 12
            let currentString = (textField.text ?? "제목없음") as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)
            
            return newString.count <= maxLength
        } else {
            return true
        }
    }
}

extension CheckListDetailViewController: UIPopoverPresentationControllerDelegate {
    private func presentPopOver() {
        let titlePopOverViewController = TitlePopOverViewController()
        titlePopOverViewController.modalPresentationStyle = .popover
        titlePopOverViewController.preferredContentSize = CGSize(width: 200, height: 45)
        
        let popover = titlePopOverViewController.popoverPresentationController
        popover?.delegate = self
        popover?.permittedArrowDirections = .down
        popover?.sourceView = self.titleLabel
        popover?.sourceRect = self.titleLabel.bounds
        self.present(titlePopOverViewController, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.dismiss(animated: true)
            }
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
