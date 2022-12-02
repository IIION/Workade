//
//  LoginJobViewController.swift
//  Workade
//
//  Created by Inho Choi on 2022/11/22.
//

import UIKit

class LoginJobViewController: UIViewController {
    private var viewModel = LoginJobViewModel()
    private var nextButtonWidth: NSLayoutConstraint!
    private var jobPickerHeight: NSLayoutConstraint!
    
    private lazy var guideLabel: UILabel = {
        let guideLable = UILabel()
        guideLable.translatesAutoresizingMaskIntoConstraints = false
        guideLable.numberOfLines = 0
        if let name = viewModel.name {
            guideLable.text = "\(name)님은 현재\n무슨 일을 하고 계신가요?"
        } else {
            guideLable.text = "XXX님의 현재\n무슨 일을 하고 계신가요?"
        }
        guideLable.textColor = .black
        guideLable.font = .customFont(for: .captionHeadlineNew)
        guideLable.setLineHeight(lineHeight: 10)
        guideLable.textAlignment = .center
        
        return guideLable
    }()
    
    private lazy var defaultPickerImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = DefaultPickerImage.chevronDown.image
        imageView.isUserInteractionEnabled = false
        imageView.tintColor = .black
        
        return imageView
    }()
    
    private lazy var defaultPickerLabel: UILabel = {
        let jobLabel = UILabel()
        jobLabel.translatesAutoresizingMaskIntoConstraints = false
        jobLabel.isUserInteractionEnabled = false
        jobLabel.text = "선택하기"
        jobLabel.textColor = .theme.tertiary
        
        return jobLabel
    }()
    
    private lazy var defaultPickerButton: UIButton = { [weak self] in
        guard let self = self else { return UIButton() }
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        button.backgroundColor = .theme.groupedBackground
        
        button.addSubview(self.defaultPickerLabel)
        NSLayoutConstraint.activate([
            self.defaultPickerLabel.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            self.defaultPickerLabel.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 20)
        ])
        
        button.addSubview(self.defaultPickerImage)
        NSLayoutConstraint.activate([
            self.defaultPickerImage.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            self.defaultPickerImage.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -20)
        ])
        
        return button
    }()
    
    private lazy var jobPickerScrollView: JobPickerScrollView = { [weak self] in
        guard let self = self else { return JobPickerScrollView(handleJobButton: { _ in }) }
        let choiceView = JobPickerScrollView(handleJobButton: handlePicker)
        choiceView.translatesAutoresizingMaskIntoConstraints = false
        choiceView.backgroundColor = .theme.groupedBackground
        choiceView.layer.cornerRadius = 15
        choiceView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        choiceView.isScrollEnabled = true
        
        return choiceView
    }()
    
    private lazy var nextButton: LoginNextButtonView = {
        let nextView = LoginNextButtonView(tapGesture: { [weak self] in
            guard let self = self else { return }
            Task { [weak self] in
                guard let loginInfo = FirebaseManager.shared.getUser(), let job = self?.viewModel.selectedJob else { return }
                let user = User(id: loginInfo.uid, name: self?.viewModel.name, email: loginInfo.email, job: job)
                try await FirestoreDAO.shared.createUser(user: user)
                
                guard let region = self?.region else { return }
                try await FirestoreDAO.shared.createActiveUser(user: ActiveUser(id: user.id, job: job, region: region, startDate: .now))
            }
            self.navigationController?.dismiss(animated: true)
            
        })
        nextView.translatesAutoresizingMaskIntoConstraints = false
        nextView.backgroundColor = .gray
        nextView.isUserInteractionEnabled = false
        
        return nextView
    }()
    
    private let region: Region?
    
    init(name: String?, region: Region?) {
        self.region = region
        viewModel.name = name
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .white
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        setupLayout()
        setupAction()
    }
    
    private func setupNavigation() {
//        navigationItem.title = "회원가입"
    }
    
    private func setupLayout() {
        view.addSubview(guideLabel)
        NSLayoutConstraint.activate([
            guideLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 48),
            guideLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(nextButton)
        nextButtonWidth = nextButton.widthAnchor.constraint(equalToConstant: 48)
        NSLayoutConstraint.activate([
            nextButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -20),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nextButton.heightAnchor.constraint(equalToConstant: 48),
            nextButtonWidth
        ])
    
        view.addSubview(defaultPickerButton)
        NSLayoutConstraint.activate([
            defaultPickerButton.topAnchor.constraint(equalTo: guideLabel.bottomAnchor, constant: 40),
            defaultPickerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            defaultPickerButton.widthAnchor.constraint(equalToConstant: 180),
            defaultPickerButton.heightAnchor.constraint(equalToConstant: 54)
        ])
        
        view.addSubview(jobPickerScrollView)
        jobPickerHeight = jobPickerScrollView.heightAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            jobPickerScrollView.topAnchor.constraint(equalTo: defaultPickerButton.bottomAnchor),
            jobPickerScrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            jobPickerScrollView.widthAnchor.constraint(equalToConstant: 180),
            jobPickerHeight
        ])
    }
    
    private func setDefaultTitle(_ job: Job?) {
        defaultPickerLabel.text = job?.rawValue ?? "선택하기"
        viewModel.selectedJob = job
    }
        
    private func handlePicker(_ title: String? = nil) {
        UIButton.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut) { [weak self]  in
            guard let self = self else { return }
            if self.viewModel.isPickerOpened {
                self.toggleJobPicker(shouldOpen: false)
            } else {
                self.toggleJobPicker(shouldOpen: true)
            }
            if let title = title {
                self.setDefaultTitle(Job(rawValue: title))
            }
            if self.viewModel.selectedJob != nil {
                self.toggleNextButton()
            }
            self.view.layoutIfNeeded()
            self.viewModel.isPickerOpened.toggle()
        }
    }
    
    private func toggleNextButton() {
        if viewModel.selectedJob != nil {
            nextButtonWidth.constant = 116
            nextButton.readyToSignup(isReady: true)
        } else {
            nextButtonWidth.constant = 48
            nextButton.readyToSignup(isReady: false)
        }
    }
    
    private func toggleJobPicker(shouldOpen: Bool) {
        if shouldOpen {
            jobPickerHeight.constant = CGFloat(297) // 54 * 5.5개
            defaultPickerImage.image = DefaultPickerImage.chevronUp.image
            defaultPickerButton.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        } else {
            jobPickerHeight.constant = .zero
            defaultPickerImage.image = DefaultPickerImage.chevronDown.image
            defaultPickerButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        }
    }

    private func setupAction() {
        defaultPickerButton.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            self.handlePicker(self.viewModel.selectedJob?.rawValue ?? "선택하기")
        }, for: .touchUpInside)
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
    }
    
    @objc private func endEditing() {
        if viewModel.isPickerOpened {
            handlePicker()
        }
    }
}
