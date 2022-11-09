//
//  File.swift
//  Workade
//
//  Created by 김예훈 on 2022/10/24.
//

import Foundation
import UIKit

class EmojiPickerViewController: UIViewController {

    static let sectionHeaderElementKind = "section-header-element-kind"
    
    enum Section: Int {
        case smilely
        case place
        case natureFood
        case animal
        case object
        
        var description: String {
            switch self {
            case .smilely:
                return "스마일리 및 사람"
            case .place:
                return "여행 및 장소"
            case .natureFood:
                return "자연 및 음식"
            case .animal:
                return "동물"
            case .object:
                return "물체"
            }
        }
    }

    var dataSource: UICollectionViewDiffableDataSource<Section, String>?
    
    var emojiTapped: ((_: String) -> Void)?
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setNavbar()
        configureDataSource()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.tintColor = .theme.primary
    }
    
    @objc func onClose() {
        presentingViewController?.dismiss(animated: true)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, _: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard Section(rawValue: sectionIndex) != nil else { fatalError() }
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.125),
                                                 heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalWidth(0.125))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                             subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20)
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .estimated(40))
            
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: EmojiPickerViewController.sectionHeaderElementKind,
                alignment: .top)
            
            section.boundarySupplementaryItems = [sectionHeader]
            section.decorationItems = [NSCollectionLayoutDecorationItem.background(elementKind: BackgroundSupplementaryView.reuseIdentifier)]
            
            return section
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 30
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: config)
        layout.register(BackgroundSupplementaryView.self, forDecorationViewOfKind: BackgroundSupplementaryView.reuseIdentifier)
        
        return layout
    }
    
    private func setupLayout() {
        view.backgroundColor = .theme.groupedBackground
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setNavbar() {
        self.navigationItem.title = "이모지 선택"
        self.navigationItem.largeTitleDisplayMode = .never
        
        let appearance = UINavigationBarAppearance()
        
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .theme.background
        
        self.navigationController?.navigationBar.tintColor = .theme.quaternary
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        let config = UIImage.SymbolConfiguration(pointSize: 17, weight: .bold)
        let image = UIImage(systemName: "xmark.circle.fill", withConfiguration: config)
        let item = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(onClose))
        self.navigationItem.setRightBarButtonItems([item], animated: true)
    }
}

// MARK: DiffableDataSource
extension EmojiPickerViewController {
    private func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<EmojiCollectionViewCell, String> { (cell, _, identifier) in
            cell.label.text = "\(identifier)"
            cell.label.sizeToFit()
            cell.label.textAlignment = .center
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, identifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration
        <TitleHeaderSupplementaryView>(elementKind: EmojiPickerViewController.sectionHeaderElementKind) { (supplementaryView, _, indexPath) in
            supplementaryView.label.text = Section(rawValue: indexPath.section)?.description
        }
        
        dataSource?.supplementaryViewProvider = { (_, _, index) in
            return self.collectionView.dequeueConfiguredReusableSupplementary(
                using: headerRegistration, for: index)
        }

        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        
        snapshot.appendSections([.smilely])
        snapshot.appendItems(makeEmojis(128512...128591))
        snapshot.appendItems(makeEmojis(129296...129311))
        snapshot.appendSections([.animal])
        snapshot.appendItems(makeEmojis(128640...128696))
        snapshot.appendSections([.natureFood])
        snapshot.appendItems(makeEmojis(127757...127875))
        snapshot.appendSections([.place])
        snapshot.appendItems(makeEmojis(128002...128063))
        snapshot.appendSections([.object])
        snapshot.appendItems(makeEmojis(128176...128301))
        
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    private func makeEmojis(_ range: ClosedRange<Int>) -> [String] {
        var emojiArray: [String] = []
        for item in range {
            let emoji = String(UnicodeScalar(item)!)
            emojiArray.append(emoji)
        }

        return emojiArray
    }
}

extension EmojiPickerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let emoji = self.dataSource?.itemIdentifier(for: indexPath) else {
            collectionView.deselectItem(at: indexPath, animated: true)
            return
        }
        
        if let tapAction = self.emojiTapped {
            tapAction(emoji)
        }
        presentingViewController?.dismiss(animated: true)
    }
}

class EmojiCollectionViewCell: UICollectionViewCell {
    lazy var label: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .white
        label.font = .customFont(for: .title1)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.layer.cornerRadius = 8
        self.contentView.layer.cornerCurve = .continuous
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemnted")
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                self.contentView.backgroundColor = .theme.labelBackground
            } else {
                self.contentView.backgroundColor = .theme.background
            }
        }
    }

    private func setupLayout() {
        contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
        ])
    }
}
