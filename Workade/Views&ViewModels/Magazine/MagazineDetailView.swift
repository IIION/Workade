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
    var magazineDetailContext: [MagazineDetailModel] = []
    
    private let testLabel: UILabel = {
        let label = UILabel()
        label.text = "Magazine 내용 뷰"
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let testLabel2: UILabel = {
        let label = UILabel()
        label.text = "Magazine 내용 뷰"
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let testLabel3: UILabel = {
        let label = UILabel()
        label.text = "Magazine 내용 뷰"
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    init(magazine: Magazine, magazineDetailContext: [MagazineDetailModel]) {
        super.init(frame: .zero)
        
//        stackView.addArrangedSubview(testLabel)
        self.magazineDetailContext = magazineDetailContext
        setupLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }
    
    func setupMagazineDetailData(magazine: Magazine) {
        self.magazine = magazine
        introduceURL = magazineViewModel.fetchURL(urlString: magazine.introduceURL)
        Task {
            await magazineDetailContext = magazineViewModel.fetchMagazine(url: introduceURL)
        }
    }

    func setupLayout() {
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
