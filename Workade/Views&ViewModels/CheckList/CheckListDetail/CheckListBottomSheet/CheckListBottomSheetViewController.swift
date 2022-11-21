//
//  CheckListBottomSheetViewController.swift
//  Workade
//
//  Created by Wonhyuk Choi on 2022/10/25.
//

import UIKit

class CheckListBottomSheetViewController: UIViewController {
    var defaultHeight: CGFloat = 250
    
    private let checkListBottomSheetViewModel = CheckListBottomSheetViewModel()
    
    private let dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let radiusView: UIView = {
        let view = UIView()
        view.backgroundColor = .theme.background
        view.layer.cornerRadius = 30
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var bottomSheetView: UIView = {
        let view = UIView()
        view.backgroundColor = .theme.labelBackground
        view.addSubview(radiusView)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var templateCollectionView: UICollectionView = {
        let collectionView = UICollectionView(itemSize: CGSize(width: 240, height: 144), direction: .horizontal)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CheckListTemplateCell.self, forCellWithReuseIdentifier: CheckListTemplateCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        var config = UIButton.Configuration.plain()
        config.imagePadding = 6
        config.cornerStyle = .capsule
        config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
        
        var attributedText = AttributedString.init("돌아가기")
        attributedText.font = .customFont(for: .caption)
        config.attributedTitle = attributedText
        config.image = UIImage.fromSystemImage(name: "xmark", font: .systemFont(ofSize: 15, weight: .semibold), color: .theme.background)
        
        button.configuration = config
        button.tintColor = .theme.background
        button.backgroundColor = .theme.primary
        button.layer.cornerRadius = 20
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.hideBottomSheetAndGoBack()
        }), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private var bottomSheetViewTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dimmedTap = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped(_:)))
        dimmedView.addGestureRecognizer(dimmedTap)
        dimmedView.isUserInteractionEnabled = true
        
        setupLayout()
        
        observingFetchComplete()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showBottomSheet()
    }

    private func setupLayout() {
        view.addSubview(bottomSheetView)
        view.addSubview(dimmedView)
        view.addSubview(templateCollectionView)
        view.addSubview(backButton)
        
        let guide = view.safeAreaLayoutGuide
        let topConstant: CGFloat = view.safeAreaInsets.bottom + guide.layoutFrame.height
        bottomSheetViewTopConstraint = bottomSheetView.topAnchor.constraint(equalTo: view.topAnchor, constant: topConstant)
        
        NSLayoutConstraint.activate([
            dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: bottomSheetView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            bottomSheetViewTopConstraint,
            bottomSheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomSheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomSheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            radiusView.topAnchor.constraint(equalTo: bottomSheetView.topAnchor),
            radiusView.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor),
            radiusView.trailingAnchor.constraint(equalTo: bottomSheetView.trailingAnchor),
            radiusView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            templateCollectionView.topAnchor.constraint(equalTo: radiusView.bottomAnchor, constant: 22.25),
            templateCollectionView.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor, constant: 20),
            templateCollectionView.widthAnchor.constraint(equalTo: guide.widthAnchor, constant: -20),
            templateCollectionView.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        NSLayoutConstraint.activate([
            backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backButton.topAnchor.constraint(equalTo: templateCollectionView.bottomAnchor, constant: 20)
        ])
    }
    
    private func showBottomSheet() {
        let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding = view.safeAreaInsets.bottom
        
        bottomSheetViewTopConstraint.constant = (safeAreaHeight + bottomPadding) - defaultHeight
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func hideBottomSheetAndGoBack() {
        let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding = view.safeAreaInsets.bottom
        bottomSheetViewTopConstraint.constant = safeAreaHeight + bottomPadding
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.dimmedView.alpha = 0.0
            self.view.layoutIfNeeded()
        }, completion: { _ in
            if self.presentingViewController != nil {
                self.dismiss(animated: false, completion: nil)
            }
        })
    }
    
    @objc private func dimmedViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        hideBottomSheetAndGoBack()
    }
    
    private func observingFetchComplete() {
        checkListBottomSheetViewModel.isCompleteFetch.bindAndFire { [weak self] _ in
            guard let self = self else { return }
            self.templateCollectionView.reloadData()
        }
    }
}

extension CheckListBottomSheetViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return checkListBottomSheetViewModel.checkListTemplateResource.content.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CheckListTemplateCell.identifier, for: indexPath)
                as? CheckListTemplateCell else {
            return UICollectionViewCell()
        }
        
        let template = checkListBottomSheetViewModel.checkListTemplateResource.content[indexPath.row]
        
        cell.setupCell(checkListTemplate: template)
        cell.addTemplate = { [weak self] in
            self?.checkListBottomSheetViewModel.addTemplateTodo(template.list)
        }
        
        return cell
    }
}

extension CheckListBottomSheetViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let checkListTemplateViewController = CheckListTemplateViewController()
        checkListTemplateViewController.modalPresentationStyle = .overFullScreen
        
        let template = checkListBottomSheetViewModel.checkListTemplateResource.content[indexPath.row]
        
        checkListTemplateViewController.setupData(checkListTemplate: template)
        
        let dimView = UIView(frame: UIScreen.main.bounds)
        dimView.backgroundColor = .black.withAlphaComponent(0.7)
        self.view.addSubview(dimView)
        self.view.bringSubviewToFront(dimView)
        checkListTemplateViewController.viewDidDissmiss = {
            dimView.removeFromSuperview()
        }
        
        self.present(checkListTemplateViewController, animated: true)
    }
}
