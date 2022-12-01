//
//  WorkerStatusSheetViewController.swift
//  Workade
//
//  Created by Wonhyuk Choi on 2022/11/21.
//

import Combine
import UIKit

class WorkerStatusSheetViewController: UIViewController {
    var viewDidDissmiss: (() -> Void)?
    
    private let workerStatusSheetViewModel = WorkerStatusSheetViewModel()
    
    private lazy var backgroundView = UIView(frame: view.frame)
    
    private lazy var containerView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .theme.background
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = 30
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton(type: .custom)
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        let image = UIImage(systemName: "xmark.circle.fill", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .theme.tertiary
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.presentingViewController?.dismiss(animated: true)
            self?.viewDidDissmiss?()
        }), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let dividerView: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor.theme.labelBackground.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let wholeWorkerLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(for: .captionHeadlineNew)
        label.textColor = .theme.secondary
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.2
        label.attributedText = NSMutableAttributedString(
            string: "제주도에\n52명이 일하고 있어요",
            attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private func jobLabel(job: String, number: CurrentValueSubject<Int, Never>, isMyJob: Bool) -> UILabel {
        let label = UILabel()
        var cancellable = Set<AnyCancellable>()
        label.font = .customFont(for: .footnote)
        label.textColor = isMyJob ? .theme.workadeBlue : .theme.secondary
        
        number
            .sink { value in
                let fullText = "\(job) \(number.value)명"
                let attributedString = NSMutableAttributedString(string: fullText)
                let range = (fullText as NSString).range(of: "\(number.value)명")
                attributedString.addAttribute(.font, value: UIFont.customFont(for: .footnote2), range: range)
                label.attributedText = attributedString
            }
            .store(in: &cancellable)
        
        return label
    }
    
    private lazy var numberOfWorkersStack: UIStackView = {
        let firstStack = UIStackView(arrangedSubviews: [
            jobLabel(job: Job.designer.rawValue, number: workerStatusSheetViewModel.numberOfDesigner, isMyJob: true),
            jobLabel(job: Job.developer.rawValue, number: workerStatusSheetViewModel.numberOfDeveloper, isMyJob: false)
        ])
        firstStack.axis = .horizontal
        firstStack.distribution = .fillEqually
        firstStack.spacing = 30
        
        let secondStack = UIStackView(arrangedSubviews: [
            jobLabel(job: Job.writer.rawValue, number: workerStatusSheetViewModel.numberOfWriter, isMyJob: false),
            jobLabel(job: Job.PM.rawValue, number: workerStatusSheetViewModel.numberOfPM, isMyJob: false)
        ])
        secondStack.axis = .horizontal
        secondStack.distribution = .fillEqually
        secondStack.spacing = 30
        
        let thirdStack = UIStackView(arrangedSubviews: [
            jobLabel(job: Job.creater.rawValue, number: workerStatusSheetViewModel.numberOfCreator, isMyJob: false),
            jobLabel(job: Job.marketer.rawValue, number: workerStatusSheetViewModel.numberOfMarketer, isMyJob: false)
        ])
        thirdStack.axis = .horizontal
        thirdStack.distribution = .fillEqually
        thirdStack.spacing = 30
        
        let fourthStack = UIStackView(arrangedSubviews: [
            jobLabel(job: Job.artist.rawValue, number: workerStatusSheetViewModel.numberOfArtist, isMyJob: false),
            jobLabel(job: Job.freelancer.rawValue, number: workerStatusSheetViewModel.numberOfFreelancer, isMyJob: false)
        ])
        fourthStack.axis = .horizontal
        fourthStack.distribution = .fillEqually
        fourthStack.spacing = 30
        
        let fifthStack = UIStackView(arrangedSubviews: [
            jobLabel(job: Job.etc.rawValue, number: workerStatusSheetViewModel.numberOfEtc, isMyJob: false),
            UIView()
        ])
        fifthStack.axis = .horizontal
        fifthStack.distribution = .fillEqually
        fourthStack.spacing = 30
        
        let stackView = UIStackView(arrangedSubviews: [firstStack, secondStack, thirdStack, fourthStack, fifthStack])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    @objc private func backgroundViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        presentingViewController?.dismiss(animated: true)
        self.viewDidDissmiss?()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundViewTap = UITapGestureRecognizer(target: self, action: #selector(backgroundViewTapped(_:)))
        backgroundView.addGestureRecognizer(backgroundViewTap)
        backgroundView.isUserInteractionEnabled = true
        
        setupLayout()
    }
}

extension WorkerStatusSheetViewController {
    private func setupLayout() {
        view.addSubview(backgroundView)
        
        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            containerView.heightAnchor.constraint(equalToConstant: 400)
        ])
        
        containerView.addSubview(dismissButton)
        NSLayoutConstraint.activate([
            dismissButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            dismissButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16)
        ])
        
        containerView.addSubview(wholeWorkerLabel)
        NSLayoutConstraint.activate([
            wholeWorkerLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 50),
            wholeWorkerLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
        
        containerView.addSubview(dividerView)
        NSLayoutConstraint.activate([
            dividerView.topAnchor.constraint(equalTo: wholeWorkerLabel.bottomAnchor, constant: 30),
            dividerView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            dividerView.widthAnchor.constraint(equalToConstant: 250),
            dividerView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        containerView.addSubview(numberOfWorkersStack)
        NSLayoutConstraint.activate([
            numberOfWorkersStack.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 30),
            numberOfWorkersStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            numberOfWorkersStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30),
            numberOfWorkersStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -40)
        ])
    }
}
