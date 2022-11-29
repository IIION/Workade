//
//  JobPickerScrollView.swift
//  Workade
//
//  Created by Inho Choi on 2022/11/23.
//

import UIKit

final class JobPickerScrollView: UIScrollView {
    private var handelJobButton: (String) -> Void
    
    lazy var jobListCell: [(String, UIButton)] = {
        var cells = [(String, UIButton)]()
        for job in Job.allCases {
            let cell = getCell(jobName: job.rawValue)
            cell.translatesAutoresizingMaskIntoConstraints = false
            cells.append((job.rawValue, cell))
        }
        
        return cells
    }()
    
    init(handleJobButton: @escaping (String) -> Void) {
        self.handelJobButton = handleJobButton
        super.init(frame: .zero)
        backgroundColor = .clear
        isScrollEnabled = true
        contentSize = CGSize(width: 180, height: CGFloat(Job.allCases.count * 54))
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        for (index, (jobTitle, cell)) in jobListCell.enumerated() {
            cell.addAction(UIAction { [weak self] _ in
                self?.handelJobButton(jobTitle)
            }, for: .touchUpInside)
            addSubview(cell)
            if index == 0 {
                NSLayoutConstraint.activate([
                    cell.topAnchor.constraint(equalTo: self.topAnchor),
                    cell.heightAnchor.constraint(equalToConstant: 54),
                    cell.widthAnchor.constraint(equalToConstant: 180)
                ])
            } else {
                NSLayoutConstraint.activate([
                    cell.topAnchor.constraint(equalTo: jobListCell[index - 1].1.bottomAnchor),
                    cell.heightAnchor.constraint(equalToConstant: 54),
                    cell.widthAnchor.constraint(equalToConstant: 180)
                ])
            }
        }
    }
    
    private func getCell(jobName: String) -> UIButton {
        let button = UIButton()
        let jobLabel = UILabel()
        jobLabel.translatesAutoresizingMaskIntoConstraints = false
        jobLabel.isUserInteractionEnabled = false
        jobLabel.text = jobName
        jobLabel.textColor = .theme.tertiary
        
        button.addSubview(jobLabel)
        NSLayoutConstraint.activate([
            jobLabel.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            jobLabel.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 20)
        ])
        
        return button
    }
}
