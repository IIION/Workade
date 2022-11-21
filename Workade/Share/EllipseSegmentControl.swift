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
    
    /// 현재 눌린 버튼을 확인하고, select. 나머지 버튼 unselect. +) 인덱스 쏴주기 & 위치 체크
    private func changeCurrentSegmentIndex(new index: Int) {
        guard buttons.count > index else { return }
        buttons.forEach { $0.isSelected = false }
        buttons[index].isSelected = true
        delegate?.ellipseSegment(didSelectItemAt: index)
        checkPostion(index)
    }
    
    /// 눌린 버튼의 위치를 체크하고, 필요 시 적절히 잘 보이도록 스크롤하는 메서드.
    private func checkPostion(_ index: Int) {
        let buttonMinX = buttons[index].frame.minX
        let buttonMaxX = buttons[index].frame.maxX
        let contentOffset = scrollView.contentOffset.x
        let scrollViewWidth = scrollView.frame.width
        
        if buttonMinX - contentOffset < 20 {
            scrollView.setContentOffset(.init(x: buttonMinX - 20, y: 0), animated: true)
        } else if (contentOffset + scrollViewWidth) - buttonMaxX < 20 {
            scrollView.setContentOffset(.init(x: buttonMaxX - scrollViewWidth + 20, y: 0), animated: true)
        }
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
