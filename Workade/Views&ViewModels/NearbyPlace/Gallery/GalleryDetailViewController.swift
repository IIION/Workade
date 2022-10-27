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
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = false
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
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(self.pinch(sender:)))
        self.imageView.addGestureRecognizer(pinch)
    }
    
    func setupLayout() {
        
        view.addSubview(imageView)
        view.addSubview(dismissButton)
        
        var aspectR: CGFloat = 1
        if let image = image {
            aspectR = image.size.width / image.size.height
        }
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1/aspectR),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            dismissButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -20),
            dismissButton.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 20),
            dismissButton.widthAnchor.constraint(equalToConstant: 44),
            dismissButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func pinch(sender: UIPinchGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            guard let view = sender.view else {return}
            let pinchCenter = CGPoint(x: sender.location(in: view).x - view.bounds.midX, y: sender.location(in: view).y - view.bounds.midY)
            
            let transform = view.transform.translatedBy(x: pinchCenter.x, y: pinchCenter.y)
                .scaledBy(x: sender.scale, y: sender.scale)
                .translatedBy(x: -pinchCenter.x, y: -pinchCenter.y)
            
            let currentScale = self.imageView.frame.size.width / self.imageView.bounds.size.width
            var newScale = currentScale * sender.scale
            if newScale < 1 {
                newScale = 1
                let transform = CGAffineTransform(scaleX: newScale, y: newScale)
                self.imageView.transform = transform
                sender.scale = 1
            } else {
                self.imageView.transform = transform
                sender.scale = 1
            }
            self.dismissButton.isHidden = true
        } else if sender.state == .ended {
            let springTimingParameter = UISpringTimingParameters(dampingRatio: 0.8, initialVelocity: .init(dx: 0, dy: 4))
            let animator = UIViewPropertyAnimator(duration: 0.4, timingParameters: springTimingParameter)
            
            animator.addAnimations {
                self.imageView.transform = CGAffineTransform.identity
                self.dismissButton.transform = CGAffineTransform.identity
            }
            self.dismissButton.isHidden = false
            animator.startAnimation()
        }
    }
}
