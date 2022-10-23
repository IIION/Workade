//
//  CheckListDetailViewController.swift
//  Workade
//
//  Created by Wonhyuk Choi on 2022/10/21.
//

import UIKit
import SwiftUI

class CheckListDetailViewController: UIViewController {
    private var checkListDetailViewModel = CheckListDetailViewModel()
    
    var selectedCheckListIndex: Int? {
        didSet {
            checkListDetailViewModel.selectedCheckListIndex = selectedCheckListIndex
        }
    }
    
    var selectedCheckList: CheckList? {
        didSet {
            checkListDetailViewModel.selectedCheckList = selectedCheckList
            datePicker.date = selectedCheckList?.travelDate ?? Date()
        }
    }
    
    private lazy var deleteButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "trash.fill"),
            style: .plain,
            target: self,
            action: #selector(deleteButtonPressed(_:))
        )
        barButtonItem.tintColor = .theme.primary
        
        return barButtonItem
    }()
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.text = selectedCheckList?.emoji ?? "⚽️"
        label.font = .systemFont(ofSize: 34)
        label.tintColor = .theme.primary
        
        return label
    }()
    
    private lazy var titleLabel: UITextField = {
        let textField = UITextField()
        textField.text = selectedCheckList?.title ?? "제목없음"
        textField.font = .customFont(for: .title2)
        textField.tintColor = .theme.primary
        
        return textField
    }()
    
    private lazy var titleStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emojiLabel, titleLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "워케이션 날짜"
        label.font = .customFont(for: .footnote)
        label.tintColor = .theme.primary
        
        return label
    }()
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.timeZone = .autoupdatingCurrent
        datePicker.tintColor = .theme.primary
        
        return datePicker
    }()
    
    private lazy var dateStack: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [dateLabel, datePicker])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let dashedLine: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 1))
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.theme.secondary.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [2, 8]
        
        let path = CGMutablePath()
        let start = CGPoint(x: view.bounds.minX, y: view.bounds.minY)
        let end = CGPoint(x: view.bounds.maxX, y: view.bounds.minY)
        path.addLines(between: [start, end])
        shapeLayer.path = path
        view.layer.addSublayer(shapeLayer)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
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
        scrollView.addSubview(titleStack)
        scrollView.addSubview(dateStack)
        scrollView.addSubview(dashedLine)
        scrollView.addSubview(checklistTableView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        return scrollView
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        
        let image = UIImage(systemName: "plus.circle.fill")
        let imageView = UIImageView(image: image)
        imageView.tintColor = .theme.primary
        imageView.frame = CGRect(x: 0, y: 0, width: 25, height: 26)
        
        let label = UILabel()
        label.text = "탭해서 추가"
        label.font = .customFont(for: .subHeadline)
        label.tintColor = .theme.primary
        
        let stack = UIStackView(arrangedSubviews: [imageView, label])
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 9
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(addButtonPressed(_:)), for: .touchUpInside)
        button.addSubview(stack)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let templateButton: UIButton = {
        let button = UIButton(type: .custom)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 17, weight: .bold)
        let image = UIImage(systemName: "list.bullet.clipboard.fill", withConfiguration: imageConfig)
        
        button.setImage(image, for: .normal)
        button.contentMode = .scaleAspectFit
        button.tintColor = .white
        button.backgroundColor = .theme.primary
        button.clipsToBounds = true
        button.layer.cornerRadius = 22
        button.layer.masksToBounds = true
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [addButton, templateButton])
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .theme.background
        
        self.setupNavigationBar()
        self.setupLayout()
    }
    
    @objc private func deleteButtonPressed(_ sender: UIBarButtonItem) {
        checkListDetailViewModel.deleteCheckList()
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func addButtonPressed(_ sender: UIButton) {
        
    }
}

extension CheckListDetailViewController {
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = deleteButton
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
            titleStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            titleStack.topAnchor.constraint(equalTo: scrollView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            dateStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            dateStack.topAnchor.constraint(equalTo: titleStack.bottomAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            dashedLine.topAnchor.constraint(equalTo: dateStack.bottomAnchor, constant: 20),
            dashedLine.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            dashedLine.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            checklistTableView.topAnchor.constraint(equalTo: dashedLine.bottomAnchor, constant: 20),
            checklistTableView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            checklistTableView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            checklistTableView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            checklistTableView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            checklistTableView.heightAnchor.constraint(equalToConstant: CGFloat(52 * checkListDetailViewModel.todos.count))
        ])
        
        NSLayoutConstraint.activate([
            buttonStack.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 20),
            buttonStack.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -20),
            buttonStack.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -26),
            buttonStack.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 10)
        ])
    }
}

extension CheckListDetailViewController: UITableViewDelegate {
    
}

extension CheckListDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checkListDetailViewModel.todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueCell(withType: CheckListDetailCell.self, for: indexPath) as? CheckListDetailCell else {
            return UITableViewCell()
        }
        
        return cell
    }
}

struct CheckListDetailViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = CheckListDetailViewController

    func makeUIViewController(context: Context) -> CheckListDetailViewController {
        return CheckListDetailViewController()
    }

    func updateUIViewController(_ uiViewController: CheckListDetailViewController, context: Context) {}
}

@available(iOS 13.0.0, *)
struct CheckListDetailViewControllerPreview: PreviewProvider {
    static var previews: some View {
        CheckListDetailViewControllerRepresentable()
            .ignoresSafeArea()
    }
}
