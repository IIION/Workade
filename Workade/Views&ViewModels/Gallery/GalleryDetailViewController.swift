//
//  GalleryDetailViewController.swift
//  Workade
//
//  Created by 김예훈 on 2022/10/21.
//

import UIKit

class GalleryDetailViewController: UIViewController {
    
    var image: UIImage?
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    lazy var dismissButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 17, weight: .bold)
        let xmarkImage = UIImage(systemName: "xmark", withConfiguration: imageConfig)
        
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialLight))
        blur.isUserInteractionEnabled = false
        blur.clipsToBounds = true
        blur.layer.cornerRadius = 22
        
        button.setImage(xmarkImage, for: .normal)
        button.tintColor = .theme.background
        button.layer.cornerRadius = 22
        button.insertSubview(blur, at: 0)
        button.addTarget(self, action: #selector(close), for: .touchUpInside)
        
        blur.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        blur.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        if let imageView = button.imageView {
            button.bringSubviewToFront(imageView)
        }
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        self.view.backgroundColor = .clear
    }
    
    func setupLayout() {

        view.addSubview(imageView)
        view.addSubview(dismissButton)
        
        let aspectR = (image?.size.width ?? 0) / (image?.size.height ?? 0)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1/aspectR),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            dismissButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -20),
            dismissButton.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 20),
            dismissButton.widthAnchor.constraint(equalToConstant: 44),
            dismissButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
}
