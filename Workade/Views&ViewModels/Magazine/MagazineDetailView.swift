//
//  MagazineDetailView.swift
//  Workade
//
//  Created by Hong jeongmin on 2022/10/25.
//

import UIKit

class MagazineDetailView: UIView {
    // TODO: true / false 에 따라 Event View 여부
    var eventCheck = true
    
    private let testLabel: UILabel = {
        let label = UILabel()
        label.text = "Magazine Detail View"
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let eventView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let moreEventLabel: UILabel = {
        let label = UILabel()
        label.text = "더 알아보고 싶다면"
        label.textColor = .theme.primary
        label.font = .customFont(for: .subHeadline)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let ticketView: UIView = {
        let view = UIView()
        view.backgroundColor = .theme.groupedBackground
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let eventTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .theme.primary
        label.font = .customFont(for: .headline)
        
        // TODO: 데이터 받아서 동적으로 처리할 부분
        label.text = "바다공룡-워케이션"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let eventSubTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .theme.tertiary
        label.font = .customFont(for: .caption)
        
        // TODO: 데이터 받아서 동적으로 처리할 부분
        label.text = "바닷가에서 일하면서 여행하고 싶다면"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var eventButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .theme.primary
        button.setTitle("구경하러 가기", for: .normal)
        button.titleLabel?.font = .customFont(for: .footnote)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(clickedEventButton(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        eventView.isHidden = !eventCheck
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupLayout() {
        addSubview(testLabel)
        NSLayoutConstraint.activate([
            testLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            testLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            testLabel.topAnchor.constraint(equalTo: topAnchor),
            testLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        addSubview(eventView)
        NSLayoutConstraint.activate([
            eventView.topAnchor.constraint(equalTo: testLabel.bottomAnchor, constant: 30),
            eventView.leadingAnchor.constraint(equalTo: leadingAnchor),
            eventView.trailingAnchor.constraint(equalTo: trailingAnchor),
            eventView.heightAnchor.constraint(equalToConstant: 110)
        ])

        eventView.addSubview(moreEventLabel)
        NSLayoutConstraint.activate([
            moreEventLabel.topAnchor.constraint(equalTo: eventView.topAnchor),
            moreEventLabel.leadingAnchor.constraint(equalTo: eventView.leadingAnchor)
        ])

        eventView.addSubview(ticketView)
        NSLayoutConstraint.activate([
            ticketView.topAnchor.constraint(equalTo: moreEventLabel.bottomAnchor, constant: 10),
            ticketView.leadingAnchor.constraint(equalTo: eventView.leadingAnchor),
            ticketView.trailingAnchor.constraint(equalTo: eventView.trailingAnchor),
            ticketView.bottomAnchor.constraint(equalTo: eventView.bottomAnchor)
        ])

        ticketView.addSubview(eventTitleLabel)
        NSLayoutConstraint.activate([
            eventTitleLabel.topAnchor.constraint(equalTo: ticketView.topAnchor, constant: 20),
            eventTitleLabel.leadingAnchor.constraint(equalTo: ticketView.leadingAnchor, constant: 20)
        ])

        ticketView.addSubview(eventSubTitleLabel)
        NSLayoutConstraint.activate([
            eventSubTitleLabel.topAnchor.constraint(equalTo: eventTitleLabel.bottomAnchor, constant: 4),
            eventSubTitleLabel.leadingAnchor.constraint(equalTo: eventTitleLabel.leadingAnchor)
        ])

        ticketView.addSubview(eventButton)
        NSLayoutConstraint.activate([
            eventButton.centerYAnchor.constraint(equalTo: ticketView.centerYAnchor),
            eventButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            eventButton.widthAnchor.constraint(equalToConstant: 90),
            eventButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc
    func clickedEventButton(sender: UIButton) {
        print("Event Button Clicked Not Working")
    }
}
