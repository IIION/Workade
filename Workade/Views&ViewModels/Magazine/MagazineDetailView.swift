//
//  MagazineDetailView.swift
//  Workade
//
//  Created by Hong jeongmin on 2022/10/25.
//

import UIKit

class MagazineDetailView: UIView {
    var magazine: Magazine
    
    let magazineViewModel = MagazineDetailViewModel()
    var introduceURL: URL?
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    init(magazine: Magazine) {
        self.magazine = magazine
        super.init(frame: .zero)
        
        setupMagazineDetailData()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupMagazineDetailData() {
        introduceURL = magazineViewModel.fetchURL(urlString: magazine.introduceURL)
        Task {
            await magazineViewModel.fetchMagazine(url: introduceURL)
        }
        
        // 메모리누수2: weak self
        magazineViewModel.data.bind { [weak self] content in
            guard let self = self else { return }
            for data in content {
                switch data.type {
                case "Text":
                    self.appendTextToStackView(data.context, data.font, data.color)
                    
                case "Image":
                    self.appendImageToStackView(data.context)
                    
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
    }
}
