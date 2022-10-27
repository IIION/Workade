//
//  CheckListBottomSheetViewController.swift
//  Workade
//
//  Created by Wonhyuk Choi on 2022/10/25.
//

import UIKit

class CheckListBottomSheetViewController: UIViewController {
    var defaultHeight: CGFloat = 200
    
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
    
    private lazy var templateCollectionView: HorizontalCollectionView = {
        let collectionView = HorizontalCollectionView(itemSize: CGSize(width: 240, height: 144))
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CheckListTemplateCell.self, forCellWithReuseIdentifier: CheckListTemplateCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
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
        return checkListBottomSheetViewModel.checkListTemplateResource.context.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CheckListTemplateCell.identifier, for: indexPath)
                as? CheckListTemplateCell else {
            return UICollectionViewCell()
        }
        
        let title = checkListBottomSheetViewModel.checkListTemplateResource.context[indexPath.row].title
        let partialText = checkListBottomSheetViewModel.checkListTemplateResource.context[indexPath.row].tintString
        let hexString = checkListBottomSheetViewModel.checkListTemplateResource.context[indexPath.row].tintColor
        let attributedStr = NSMutableAttributedString(string: title)
        attributedStr.addAttribute(.foregroundColor, value: hexStringToUIColor(hex: hexString), range: (title as NSString).range(of: partialText))
        cell.titleLabel.attributedText = attributedStr
        
        return cell
    }
    
    func hexStringToUIColor (hex: String) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        if (cString.count) != 6 {
            return UIColor.gray
        }

        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

extension CheckListBottomSheetViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let checkListTemplateViewController = CheckListTemplateViewController()
        checkListTemplateViewController.modalPresentationStyle = .overFullScreen
        
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
