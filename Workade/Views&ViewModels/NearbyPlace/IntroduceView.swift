//
//  IntroduceViewController.swift
//  Workade
//
//  Created by ryu hyunsun on 2022/10/20.
//

import UIKit

class IntroduceView: UIView {
    let bottomSafeArea = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 44
    
    var stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private func appendImageToStackView(_ url: URL?) {
        let imageView = UIImageView()
        guard let url = url else { return }
        
        // TODO: 머지 이후, 매니져 로직으로 변경 예정입니다.
        getImage(from: url) { data, _, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                imageView.image = image
                let width = image?.size.width
                let height = image?.size.height
                if let width = width, let height = height {
                    imageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: height/width).isActive = true
                }
            }
        }
        
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        
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
    
    // 이건 URL로 불러 올 경우
    private func pullInformation() {
        guard let path = Bundle.main.path(forResource: "NearbyPlaceViewDetailData", ofType: "json") else { return }

        // 나중에 웹 url로부터 받아온다면? String(contentsOfFile:) 대신 String(contentsOf:) 사용하기
        guard let jsonString = try? String(contentsOfFile: path) else { return }
        
        let decorder = JSONDecoder()
        let data = jsonString.data(using: .utf8)
        
        if let data = data, let detailDatas = try? decorder.decode(DetailDataModel.self, from: data) {
            // 이미지인지, 텍스트인지에 따라서 구분해 줘야함.
            for detailData in detailDatas.content {
                switch detailData.type {
                // 이미지 타입일 경우
                case "image":
                    let url = URL(string: detailData.context)
                    appendImageToStackView(url)
                // 텍스트 타입일 경우
                case "text":
                    appendTextToStackView(detailData.context, detailData.font, detailData.color)
                    
                default:
                    print(1)
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        pullInformation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottomSafeArea - 20)
        ])
    }

}

extension UILabel {
    func setLineHeight(lineHeight: CGFloat) {
        guard let text = self.text else { return }
        
        let attributeString = NSMutableAttributedString(string: text)
        let style = NSMutableParagraphStyle()
        
        style.lineSpacing = lineHeight
        attributeString.addAttribute(
            NSAttributedString.Key.paragraphStyle,
            value: style,
            range: NSRange(location: 0, length: attributeString.length))
        
        self.attributedText = attributeString
    }
}
