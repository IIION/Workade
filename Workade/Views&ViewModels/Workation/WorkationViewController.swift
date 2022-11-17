//
//  WorkationViewController.swift
//  Workade
//
//  Created by Wonhyuk Choi on 2022/11/17.
//

import UIKit

final class WorkationViewController: UIViewController {
    private let workationViewModel = WorkationViewModel()
    
    var dismissAction: (() -> Void)?
    
    private let titleView = TitleView(title: "제주도")
    
    private lazy var guideButton: UIButton = {
        let button = UIButton(type: .custom)
        var config = UIButton.Configuration.plain()
        config.imagePadding = 4
        config.cornerStyle = .capsule
        config.contentInsets = NSDirectionalEdgeInsets.init(top: 10, leading: 14, bottom: 10, trailing: 14)
        
        button.setTitle("가이드 보러 가기", for: .normal)
        button.setImage(UIImage(systemName: "text.book.closed.fill"), for: .normal)
        button.setTitleColor(.theme.primary, for: .normal)
        button.configuration = config
        button.tintColor = .theme.primary
        button.backgroundColor = .theme.tertiary
        button.layer.cornerRadius = 20
        
        button.titleLabel?.font = .customFont(for: .caption)
        
        return button
    }()
    
    private let numberOfPeopleView: UIView = {
        let view = UIView()
        view.backgroundColor = .theme.subGroupedBackground
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let wholePeopleStackView: UIStackView = {
        let personImage = UIImage.fromSystemImage(name: "person.fill", font: .systemFont(ofSize: 15, weight: .bold), color: .black)
        let imageView = UIImageView(image: personImage)
        imageView.contentMode = .scaleAspectFit
        let label = UILabel()
        label.text = "52명"
        label.font = .customFont(for: .subHeadline)
        label.textColor = .black
        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private func numberOfJobStack(job: String, num: Int) -> UIStackView {
        let jobLabel = UILabel()
        jobLabel.text = job
        jobLabel.font = .customFont(for: .caption)
        jobLabel.textColor = .black
        
        let numberLabel = UILabel()
        numberLabel.text = "\(num)명"
        numberLabel.font = .customFont(for: .caption)
        numberLabel.textColor = .black
        
        let stackView = UIStackView(arrangedSubviews: [jobLabel, numberLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 4
        
        return stackView
    }
    
    private lazy var jobStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            numberOfJobStack(job: "디자이너", num: 40000),
            numberOfJobStack(job: "작가", num: 70000),
            numberOfJobStack(job: "컨텐츠 제작", num: 1200000),
            numberOfJobStack(job: "개발자", num: 20000)
        ])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var jobScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .theme.background
        
        setupLayout()
        setupNavigationBar()
    }
}

private extension WorkationViewController {
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: SFSymbol.xmarkInNavigation.image,
            style: .done,
            target: self,
            action: #selector(clickedCloseButton(_:))
        )
        
        let rightBarButton = UIBarButtonItem(customView: guideButton)
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    private func setupLayout() {
        let guide = view.safeAreaLayoutGuide
        
        view.addSubview(titleView)
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 20),
            titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        view.addSubview(numberOfPeopleView)
        NSLayoutConstraint.activate([
            numberOfPeopleView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 10),
            numberOfPeopleView.heightAnchor.constraint(equalToConstant: 76),
            numberOfPeopleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            numberOfPeopleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        numberOfPeopleView.addSubview(wholePeopleStackView)
        NSLayoutConstraint.activate([
            wholePeopleStackView.topAnchor.constraint(equalTo: numberOfPeopleView.topAnchor, constant: 16),
            wholePeopleStackView.leadingAnchor.constraint(equalTo: numberOfPeopleView.leadingAnchor, constant: 20)
        ])
        
        numberOfPeopleView.addSubview(jobScrollView)
        NSLayoutConstraint.activate([
            jobScrollView.topAnchor.constraint(equalTo: wholePeopleStackView.bottomAnchor, constant: 6),
            jobScrollView.leadingAnchor.constraint(equalTo: numberOfPeopleView.leadingAnchor, constant: 20),
            jobScrollView.trailingAnchor.constraint(equalTo: numberOfPeopleView.trailingAnchor),
            jobScrollView.bottomAnchor.constraint(equalTo: numberOfPeopleView.bottomAnchor, constant: -16)
        ])
        
        jobScrollView.addSubview(jobStackView)
        NSLayoutConstraint.activate([
            jobStackView.topAnchor.constraint(equalTo: jobScrollView.topAnchor),
            jobStackView.bottomAnchor.constraint(equalTo: jobScrollView.bottomAnchor),
            jobStackView.leadingAnchor.constraint(equalTo: jobScrollView.leadingAnchor),
            jobStackView.trailingAnchor.constraint(equalTo: jobScrollView.trailingAnchor)
        ])
    }
    
    @objc
    func clickedCloseButton(_ sender: UIButton) {
        dismissAction?()
        self.dismiss(animated: true)
    }
}
