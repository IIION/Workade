//
//  MagazineDetailView.swift
//  Workade
//
//  Created by Hong jeongmin on 2022/10/25.
//

import UIKit

class MagazineDetailView: UIView {
    var magazine: Magazine = Magazine(title: "", imageURL: "", introduceURL: "")
    
    let magazineViewModel = MagazineDetailViewModel()
    var introduceURL: URL?
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
    // TODO: true / false 에 따라 Event View 여부
    var eventCheck = false
        
        return stackView
    }()
    
    init(magazine: Magazine) {
        super.init(frame: .zero)
        
        setupLayout()
    }
    
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
    
    func setupMagazineDetailData(magazine: Magazine) {
        self.magazine = magazine
        introduceURL = magazineViewModel.fetchURL(urlString: magazine.introduceURL)
        Task {
            await magazineViewModel.fetchMagazine(url: introduceURL)
        }
        
        magazineViewModel.data.bind { [self] content in
            for data in content {
                switch data.type {
                case "Text":
                    appendTextToStackView(data.context, data.font, data.color)
                    
                case "Image":
                    appendImageToStackView(data.context)
                    
                default:
                    return
                }
            }
        }
    }
    
    func setImageURL(url: String) async -> UIImage {
        guard let url = URL(string: url) else { return UIImage() }
        guard let data = await NetworkManager.shared.request(url: url) else { return UIImage() }
        if let image = UIImage(data: data) {
            return image
        }
        return UIImage()
    }
    
    private func appendImageToStackView(_ url: String) {
        let imageView = UIImageView()
        Task {
            let image = await setImageURL(url: url)
            let width = image.size.width
            let height = image.size.height
            imageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: height/width).isActive = true
            imageView.contentMode = .scaleToFill
            imageView.layer.cornerRadius = 20
            imageView.clipsToBounds = true
            imageView.image = image
        }
        stackView.addArrangedSubview(imageView)
    }
    
    private func getImage(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    private func appendTextToStackView(_ content: String, _ font: String?, _ color: String?) {
        let label = UILabel()
        label.text = content
        
        if let font = font {
            label.font = .customFont(for: CustomTextStyle(rawValue: font) ?? .articleBody)
        }
        
        if let color = color {
            label.textColor = UIColor(named: color) ?? UIColor(.black)
        }
        
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        
        label.setLineHeight(lineHeight: 12.0)
        
        stackView.addArrangedSubview(label)
    }
    
    func setupLayout() {
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
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
