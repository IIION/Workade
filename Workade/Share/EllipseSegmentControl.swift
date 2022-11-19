//
//  EllipseSegmentControl.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/11/19.
//

import UIKit

protocol EllipseSegmentControlDelegate: AnyObject {
    func ellipseSegment(didSelectItemAt index: Int)
}

/// 오피스, 매거진 뷰컨트롤러 등에서 사용되는 커스텀 타원형 세그먼트 컨트롤
final class EllipseSegmentControl: UIView {
    private var buttons = [UIButton]()
    var currentSegmentIndex: Int = 0 { // Single Source
        didSet {
            changeCurrentSegmentIndex(new: currentSegmentIndex)
        }
    }
    
    weak var delegate: EllipseSegmentControlDelegate?
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentInset = .init(top: 0, left: 20, bottom: 0, right: 20)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    init(items: [String]) {
        super.init(frame: .zero)
        setupLayout()
        configureSegment(items: items)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func changeCurrentSegmentIndex(new index: Int) {
        guard buttons.count > index else { return }
        buttons.forEach { $0.isSelected = false }
        buttons[index].isSelected = true
        delegate?.ellipseSegment(didSelectItemAt: index)
    }
}

// MARK: UI Setup Related Methods
private extension EllipseSegmentControl {
    func configureSegment(items: [String]) {
        items.enumerated().forEach { index, title in
            let button = EllipseButton(title: title)
            button.addAction(UIAction(handler: { [weak self] _ in
                self?.currentSegmentIndex = index
            }), for: .touchUpInside)
            buttons.append(button)
            stackView.addArrangedSubview(button)
        }
    }
    
    func setupLayout() {
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        let contentGuide = scrollView.contentLayoutGuide
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentGuide.bottomAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
    }
}

/// 타원 모양의 버튼. EllipseSegmentControl에서 쓸 수 있도록 만들어졌습니다.
///
/// 원하면 그 외에서도 사용이 가능하지만, 현재 강조 색상 및 평소 색상은 고정되어있습니다.
final class EllipseButton: UIButton {
    init(title: String) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        setTitleColor(.theme.tertiary, for: .normal)
        titleLabel?.font = .customFont(for: .footnote)
        backgroundColor = .theme.groupedBackground
        layer.cornerRadius = intrinsicContentSize.height/2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: super.intrinsicContentSize.width + 20, height: 34)
    }
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? UIColor.blue : UIColor.lightGray
            setTitleColor(isSelected ? .theme.workadeBlue : .theme.tertiary, for: .normal)
        }
    }
}
