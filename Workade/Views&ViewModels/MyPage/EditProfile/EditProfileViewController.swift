//
//  EditProfileViewController.swift
//  Workade
//
//  Created by Hong jeongmin on 2022/11/18.
//

import UIKit

final class EditProfileViewController: UIViewController {
    private var pickerCheck = false
    private let pickerList = ["개발", "디자인", "기획", "마케팅", "콘텐츠 제작", "작가(글,웹툰)", "예술가", "프리랜서", "기타"]
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "이름/닉네임"
        label.font = .customFont(for: .subHeadline)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        // TODO: Placeholder를 현재 사용자의 이름으로 설정
        textField.attributedPlaceholder = NSAttributedString(
            string: "이름 입력하기",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.theme.tertiary]
        )
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
        pickerTableView.layer.cornerRadius = 15
        pickerTableView.backgroundColor = .theme.background
        pickerTableView.separatorStyle = .none
        pickerTableView.showsVerticalScrollIndicator = false
        
        pickerTableView.layer.borderWidth = 0.2
        pickerTableView.layer.borderColor = UIColor.theme.tertiary.cgColor
        
        pickerTableView.translatesAutoresizingMaskIntoConstraints = false
        
        return pickerTableView
    }()
    
    private let pickerLabel: UILabel = {
        let pickerLabel = UILabel()
        // TODO: 현재 사용자의 직업으로 설정
        pickerLabel.text = "선택하기"
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
        button.addAction(UIAction(handler: { _ in
            // TODO: UserInfo와 연결하여 유저정보 업데이트
            print("설정된 이름 : \(self.nameTextField.text ?? "")\n설정된 직업: \(self.pickerLabel.text ?? "")")
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
        } else {
            presentPickerAnimation(frames: frames, height: 0)
            pickerImage.transform = pickerImage.transform.rotated(by: -.pi)
        }
    }
    
    // tableView를 애니메이션을 통해 Picker처럼 표현
    private func presentPickerAnimation(frames: CGRect, height: CGFloat) {
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut) { [weak self]  in
            guard let self = self else { return }
            self.pickerTableView.frame = CGRect(x: frames.origin.x,
                                                y: frames.origin.y + frames.height,
                                                width: frames.width,
                                                height: height)
        }
    }
}

// TableView Delegate
extension EditProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectionStyle = .none
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let frames = self.jobPickerButton.frame
        
        pickerLabel.text = pickerList[indexPath.row]
        presentPickerView()
    }
}

// TableView DataSource
extension EditProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.pickerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PickerTableViewCell.cellId, for: indexPath) as? PickerTableViewCell
        guard let cell = cell else { return UITableViewCell() }
        cell.pickerLabel.text = pickerList[indexPath.row]
        
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
