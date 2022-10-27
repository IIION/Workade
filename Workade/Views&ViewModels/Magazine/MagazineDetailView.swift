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
        
        return stackView
    }()
    
    init(magazine: Magazine) {
        super.init(frame: .zero)
        
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
    }
}
