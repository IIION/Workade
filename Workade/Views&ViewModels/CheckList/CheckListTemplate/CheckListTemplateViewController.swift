//
//  CheckListTemplateViewController.swift
//  Workade
//
//  Created by 김예훈 on 2022/10/26.
//

import UIKit

class CheckListTemplateViewController: UIViewController {
    private var task: Task<Void, Error>?
    private let viewModel = CheckListTemplateViewModel()
    
    var viewDidDissmiss: (() -> Void)?
    
    lazy var containerView: UIView = {
        let containerView = UIView(frame: .zero)
        containerView.backgroundColor = .theme.background
        containerView.layer.cornerCurve = .continuous
        containerView.layer.cornerRadius = 30
        containerView.clipsToBounds = true
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        return containerView
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage())
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .customFont(for: .subHeadline)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(for: .caption)
        label.textColor = .theme.primary
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var checkListTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.rowHeight = 40
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .theme.labelBackground
        tableView.registerCell(type: CheckListTemplateDetailCell.self, identifier: CheckListTemplateDetailCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton(type: .custom)
        let config = UIImage.SymbolConfiguration(pointSize: 13, weight: .bold)
        let image = UIImage(systemName: "plus", withConfiguration: config)

        button.setTitle("추가하기", for: .normal)
        button.setTitleColor(.theme.primary, for: .normal)
        button.titleLabel?.font = .customFont(for: .footnote)
        button.setImage(image, for: .normal)
        button.backgroundColor = .theme.groupedBackground
        button.layer.cornerCurve = .continuous
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        button.tintColor = .theme.primary
        button.addTarget(self, action: #selector(add), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var dismissButton: UIButton = {
        let button = UIButton(type: .custom)
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        let image = UIImage(systemName: "xmark.circle.fill", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .theme.tertiary
        button.addTarget(self, action: #selector(close), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    @objc
    private func close() {
        presentingViewController?.dismiss(animated: true)
        self.viewDidDissmiss?()
    }
    
    @objc
    private func add() {
        presentingViewController?.dismiss(animated: true)
        viewModel.addTemplateTodo()
        self.viewDidDissmiss?()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundView = UIView(frame: view.frame)
        view.addSubview(backgroundView)
        let backgroundViewTap = UITapGestureRecognizer(target: self, action: #selector(backgroundViewTapped(_:)))
        backgroundView.addGestureRecognizer(backgroundViewTap)
        backgroundView.isUserInteractionEnabled = true
        
        setupLayout()
    }
    
    @objc private func backgroundViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        presentingViewController?.dismiss(animated: true)
        self.viewDidDissmiss?()
    }
    
    func setupData(checkListTemplate: CheckListTemplateModel) {
        let title = checkListTemplate.title
        let partialText = checkListTemplate.tintString
        let hexString = checkListTemplate.tintColor
        let imageUrl = checkListTemplate.imageURL
        let attributedStr = NSMutableAttributedString(string: title)
        attributedStr.addAttribute(.foregroundColor,
                                   value: UIColor.hexStringToUIColor(hex: hexString),
                                   range: (title as NSString).range(of: partialText)
        )
        
        let text = "\(checkListTemplate.list.count)개의 체크리스트"
        viewModel.todos = checkListTemplate.list
        checkListTableView.reloadData()
        
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttribute(.foregroundColor, value: UIColor.theme.quaternary, range: (text as NSString).range(of: "개의 체크리스트"))
        
        self.titleLabel.attributedText = attributedStr
        self.countLabel.attributedText = attributedText
        self.imageView.image = nil
        task = Task {
            await self.imageView.setImageURL(title: title, url: imageUrl)
        }
    }
    
    func setupLayout() {
        let views = [
            containerView, imageView, titleLabel, countLabel,
            checkListTableView,
            addButton, dismissButton
        ]
        
        views.forEach {
            self.view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            containerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            containerView.topAnchor.constraint(equalTo: imageView.topAnchor, constant: -30),
            containerView.bottomAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 30)
        ])
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 32),
            imageView.heightAnchor.constraint(equalToConstant: 32),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 2)
        ])
        
        NSLayoutConstraint.activate([
            countLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            countLabel.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            checkListTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            checkListTableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            checkListTableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            checkListTableView.heightAnchor.constraint(equalToConstant: 200),
            checkListTableView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            addButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            addButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            addButton.heightAnchor.constraint(equalToConstant: 45)
        ])
        
        NSLayoutConstraint.activate([
            dismissButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            dismissButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16)
        ])
    }
}

extension CheckListTemplateViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueCell(withType: CheckListTemplateDetailCell.self, for: indexPath) as? CheckListTemplateDetailCell else {
            return UITableViewCell()
        }
        
        cell.label.text = viewModel.todos[indexPath.row]
        
        return cell
    }
}

class CheckListTemplateDetailCell: UITableViewCell {
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .theme.primary
        label.font = .customFont(for: .footnote)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupLayout() {
        self.contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
