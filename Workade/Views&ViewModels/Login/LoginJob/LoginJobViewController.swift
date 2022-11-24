//
//  LoginJobViewController.swift
//  Workade
//
//  Created by Inho Choi on 2022/11/22.
//

import UIKit

class LoginJobViewController: UIViewController {
    private var name: String?
    private var selectedJob: Job? = nil
    private var isPickerOpened = false
    private var nextButtonWidth: NSLayoutConstraint!
    private var jobPickerHeight: NSLayoutConstraint!
    let imageConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .bold, scale: .default)
    
    lazy private var guideLabel: UILabel = {
        let guideLable = UILabel()
        guideLable.translatesAutoresizingMaskIntoConstraints = false
        guideLable.numberOfLines = 0
        if let name = name {
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
    
    lazy private var defaultPickerImage: UIImageView = { [weak self] in
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "chevron.down", withConfiguration: self?.imageConfig)
        imageView.isUserInteractionEnabled = false
        imageView.tintColor = .black
        
        return imageView
    }()
    
    lazy private var defaultPickerLabel: UILabel = {
        let jobLabel = UILabel()
        jobLabel.translatesAutoresizingMaskIntoConstraints = false
        jobLabel.isUserInteractionEnabled = false
        jobLabel.text = "선택하기"
        jobLabel.textColor = .theme.tertiary
        
        return jobLabel
    }()
    
    lazy private var defaultPickerButton: UIButton = { [weak self] in
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
    
    lazy private var jobPickerScrollView: JobPickerScrollView = { [weak self] in
        guard let self = self else { return JobPickerScrollView(handleJobButton: { _ in }) }
        let choiceView = JobPickerScrollView(handleJobButton: handlePicker)
        choiceView.translatesAutoresizingMaskIntoConstraints = false
        choiceView.backgroundColor = .theme.groupedBackground
        choiceView.layer.cornerRadius = 15
        choiceView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        return choiceView
    }()
    
    lazy private var nextButton: LoginNextButtonView = {
        let nextView = LoginNextButtonView(tapGesture: { [weak self] in
            guard let self = self else { return }
            print(self.name, self.selectedJob?.rawValue)
        }) // TODO: 다음 페이지 연결하기
        nextView.translatesAutoresizingMaskIntoConstraints = false
        nextView.backgroundColor = .gray
        nextView.isUserInteractionEnabled = false
        
        return nextView
    }()
    
    init(name: String?) {
        self.name = name
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        setupLayout()
    }
    
    private func setupNavigation() {
        navigationItem.title = "회원가입"
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
        defaultPickerButton.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            self.handlePicker(self.selectedJob?.rawValue ?? "선택하기")
        }, for: .touchUpInside)
        
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
        selectedJob = job
    }
        
    private func handlePicker(_ title: String) {
        self.isPickerOpened.toggle()
        UIButton.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut) { [weak self]  in
            guard let self = self else { return }
            if self.isPickerOpened {
                self.jobPickerScrollView.isScrollEnabled = true
                self.toggleJobPicker(self.isPickerOpened)
            } else {
                self.toggleJobPicker(self.isPickerOpened)
            }
            self.setDefaultTitle(Job(rawValue: title))
            if self.selectedJob != nil {
                self.toggleNextButton()
            }
            self.view.layoutIfNeeded()
        }
    }
    
    private func toggleNextButton() {
        if selectedJob != nil {
            nextButton.backgroundColor = .blue
            nextButton.isUserInteractionEnabled = true
            nextButtonWidth.constant = 116
            nextButton.appearGuidLabel()
        } else {
            nextButton.backgroundColor = .gray
            nextButton.isUserInteractionEnabled = false
            nextButtonWidth.constant = 48
            nextButton.disappearGuidLabel()
        }
    }
    
    private func toggleJobPicker(_ isOpend: Bool) {
        if isOpend {
            jobPickerHeight.constant = CGFloat(297) // 54 * 5.5개
            defaultPickerImage.image =  UIImage(systemName: "chevron.up", withConfiguration: imageConfig)
            defaultPickerButton.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        } else {
            jobPickerHeight.constant = .zero
            defaultPickerImage.image =  UIImage(systemName: "chevron.down", withConfiguration: imageConfig)
            defaultPickerButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        }
    }
}
    
