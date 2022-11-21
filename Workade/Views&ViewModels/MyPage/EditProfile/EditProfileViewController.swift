//
//  EditProfileViewController.swift
//  Workade
//
//  Created by Hong jeongmin on 2022/11/18.
//

import UIKit

class EditProfileViewController: UIViewController {
    private var pickerCheck = false
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "이름/닉네임"
        label.font = .customFont(for: .subHeadline)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let nameTextField: UITextField = {
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
        pickerTableView.backgroundColor = .red
        pickerTableView.translatesAutoresizingMaskIntoConstraints = false
        
        return pickerTableView
    }()
    
    private let pickerLabel: UILabel = {
        let pickerLabel = UILabel()
        // TODO: 현재 사용자의 직업으로 설정
        pickerLabel.text = "선택하세요"
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
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .theme.background
        
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
        } else {
            presentPickerAnimation(frames: frames, height: 0)
        }
        
        pickerImage.transform = pickerImage.transform.rotated(by: .pi)
    }
    
    // tableView를 애니메이션을 통해 Picker처럼 표현
    private func presentPickerAnimation(frames: CGRect, height: CGFloat) {
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut) {
            self.pickerTableView.frame = CGRect(x: frames.origin.x,
                                                y: frames.origin.y + frames.height,
                                                width: frames.width,
                                                height: height)
        }
    }
}
