//
//  EditProfileViewController.swift
//  Workade
//
//  Created by Hong jeongmin on 2022/11/18.
//

import UIKit

final class EditProfileViewController: UIViewController {
    private var pickerCheck = false
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "이름/닉네임"
        label.font = .customFont(for: .subHeadline)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.font = .customFont(for: .footnote2)
        textField.textColor = .theme.tertiary
        textField.backgroundColor = .theme.groupedBackground
        textField.layer.cornerRadius = 15
        textField.addLeftPadding()
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private let nowJobLabel: UILabel = {
        let label = UILabel()
        label.text = "현재 하는일"
        label.font = .customFont(for: .subHeadline)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var jobPickerButton: UIButton = {
        let action = UIAction { [weak self] _ in
            self?.presentPickerView()
        }
        let button = UIButton(primaryAction: action)
        button.backgroundColor = .theme.groupedBackground
        button.layer.cornerRadius = 15
        button.sizeToFit()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let pickerImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage.fromSystemImage(name: "chevron.down", font: .systemFont(ofSize: 13, weight: .heavy), color: .theme.primary) ?? UIImage(systemName: "chevron.down")
        image.tintColor = .theme.primary
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    private lazy var pickerTableView: UITableView = {
        let pickerTableView = UITableView()
        pickerTableView.backgroundColor = .theme.groupedBackground
        pickerTableView.separatorStyle = .none
        pickerTableView.showsVerticalScrollIndicator = false
        
        pickerTableView.layer.cornerRadius = 15
        pickerTableView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        pickerTableView.translatesAutoresizingMaskIntoConstraints = false
        
        return pickerTableView
    }()
    
    private let pickerLabel: UILabel = {
        let pickerLabel = UILabel()
        pickerLabel.font = .customFont(for: .footnote2)
        pickerLabel.textColor = .theme.tertiary
        pickerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return pickerLabel
    }()
    
    private lazy var editCompletionButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .theme.workadeBlue
        button.setTitle("프로필 수정", for: .normal)
        button.setTitleColor(.theme.background, for: .normal)
        button.layer.cornerRadius = 15
        button.titleLabel?.font = .customFont(for: .subHeadline)
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.updateUser()
        }), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .theme.background
        
        pickerTableView.delegate = self
        pickerTableView.dataSource = self
        self.pickerTableView.register(PickerTableViewCell.self, forCellReuseIdentifier: PickerTableViewCell.cellId)
        
        setupNavigationBar()
        setupLayout()
        
        setData()
    }
    
    private func setupLayout() {
        view.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18)
        ])
        
        view.addSubview(nameTextField)
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12),
            nameTextField.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
            nameTextField.heightAnchor.constraint(equalToConstant: 54)
        ])
        
        view.addSubview(nowJobLabel)
        NSLayoutConstraint.activate([
            nowJobLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 30),
            nowJobLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor)
        ])
        
        view.addSubview(jobPickerButton)
        NSLayoutConstraint.activate([
            jobPickerButton.topAnchor.constraint(equalTo: nowJobLabel.bottomAnchor, constant: 12),
            jobPickerButton.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            jobPickerButton.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            jobPickerButton.heightAnchor.constraint(equalTo: nameTextField.heightAnchor)
        ])
        
        jobPickerButton.addSubview(pickerImage)
        NSLayoutConstraint.activate([
            pickerImage.centerYAnchor.constraint(equalTo: jobPickerButton.centerYAnchor),
            pickerImage.trailingAnchor.constraint(equalTo: jobPickerButton.trailingAnchor, constant: -20)
        ])
        
        jobPickerButton.addSubview(pickerLabel)
        NSLayoutConstraint.activate([
            pickerLabel.centerYAnchor.constraint(equalTo: jobPickerButton.centerYAnchor),
            pickerLabel.leadingAnchor.constraint(equalTo: jobPickerButton.leadingAnchor, constant: 20)
        ])
        
        view.addSubview(editCompletionButton)
        NSLayoutConstraint.activate([
            editCompletionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -54),
            editCompletionButton.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            editCompletionButton.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            editCompletionButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    // 화면 터치시 Keyboard 내리기 & picker 접기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let frames = self.jobPickerButton.frame
        self.view.endEditing(true)
        
        if pickerCheck {
            pickerImage.transform = pickerImage.transform.rotated(by: -.pi)
        }
        pickerCheck = false
        presentPickerAnimation(frames: frames, height: 0)
    }
    
    func setData() {
        pickerLabel.text = UserManager.shared.user.value?.job.rawValue
        nameTextField.attributedPlaceholder = NSAttributedString(
            string: UserManager.shared.user.value?.name ?? "",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.theme.tertiary]
        )
    }
    
    func updateUser() {
        Task {
            guard let loginInfo = FirebaseManager.shared.getUser() else { return }
            if self.nameTextField.text == "" {
                self.nameTextField.text = UserManager.shared.user.value?.name
            }
            guard let job = Job(rawValue: self.pickerLabel.text ?? "") else { return }
            let user = User(id: loginInfo.uid, name: self.nameTextField.text, email: loginInfo.email, job: job)
            try await FirestoreDAO.shared.createUser(user: user)
            
            navigationController?.popViewController(animated: true)
        }
    }
}

private extension EditProfileViewController {
    private func setupNavigationBar() {
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: SFSymbol.chevronLeft.image,
            primaryAction: UIAction(handler: { [weak self] _ in
                guard let self = self else { return }
                self.navigationController?.popViewController(animated: true)
            })
        )
        self.title = "프로필 수정"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.customFont(for: .subHeadline)]
    }
    
    private func presentPickerView() {
        // tableView의 Frame을 현재 버튼에 맞춰 설정하고 View에 포함되지 않을경우 추가해 준다 ( 초기화 )
        let frames = self.jobPickerButton.frame
        if !view.contains(pickerTableView) {
            self.pickerTableView.frame = CGRect(x: frames.origin.x,
                                                y: frames.origin.y + frames.height,
                                                width: frames.width,
                                                height: 0)
            view.addSubview(pickerTableView)
        }
        
        // 버튼을 누를때 picker를 표현하기 위해 Bool값을 체크하여 테이블뷰를 애니메이션으로 표시 ( picker처럼 보이도록 )
        pickerCheck.toggle()
        if pickerCheck {
            presentPickerAnimation(frames: frames, height: 300)
            pickerImage.transform = pickerImage.transform.rotated(by: .pi)
            jobPickerButton.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        } else {
            presentPickerAnimation(frames: frames, height: 0)
            pickerImage.transform = pickerImage.transform.rotated(by: -.pi)
        }
    }
    
    // tableView를 애니메이션을 통해 Picker처럼 표현
    private func presentPickerAnimation(frames: CGRect, height: CGFloat) {
        //        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .curveEaseInOut) { [weak self]  in
        UIView.animate(withDuration: 0.3) { [weak self]  in
            guard let self = self else { return }
            self.pickerTableView.frame = CGRect(x: frames.origin.x,
                                                y: frames.origin.y + frames.height,
                                                width: frames.width,
                                                height: height)
        } completion: { [weak self] _ in
            guard let self = self else { return }
            if !self.pickerCheck {
                self.jobPickerButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            }
        }
    }
}

// TableView Delegate
extension EditProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectionStyle = .none
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pickerLabel.text = Job.allCases[indexPath.row].rawValue
        presentPickerView()
    }
}

// TableView DataSource
extension EditProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Job.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PickerTableViewCell.cellId, for: indexPath) as? PickerTableViewCell
        guard let cell = cell else { return UITableViewCell() }
        cell.pickerLabel.text = Job.allCases[indexPath.row].rawValue
        
        return cell
    }
}

// TextField Delegate
extension EditProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
