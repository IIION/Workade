//
//  CheckListDetailViewController.swift
//  Workade
//
//  Created by Wonhyuk Choi on 2022/10/21.
//

import UIKit
import SwiftUI

class CheckListDetailViewController: UIViewController {
    var emoji: String = "⚽️"
    var checklistTitle: String = "제목없음"
    var date: Date = Date()
    
    private let deleteButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "trash.fill"),
            style: .plain,
            target: nil,
            action: nil
        )
        barButtonItem.tintColor = .theme.primary
        
        return barButtonItem
    }()
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.text = emoji
        label.font = .systemFont(ofSize: 34)
        label.tintColor = .theme.primary
        
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = checklistTitle
        label.font = .customFont(for: .title2)
        label.tintColor = .theme.primary
        
        return label
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
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.addSubview(titleStack)
        scrollView.addSubview(dateStack)
        scrollView.addSubview(dashedLine)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .theme.background
        
        self.setupNavigationBar()
        self.setupLayout()
    }
}

extension CheckListDetailViewController {
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = deleteButton
    }
    
    private func setupLayout() {
        view.addSubview(scrollView)
        
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 20),
            scrollView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -20),
            scrollView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -20)
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
            dashedLine.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor)
        ])
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
