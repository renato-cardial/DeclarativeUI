//
//  FactoryView.swift
//  DeclarativeUI
//
//  Created by Renato Cardial on 10/2/23.
//

import UIKit

class FactoryView {
    
    static func makeView() -> UIView {
        let view: UIView = .init()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    static func makeLabel() -> PaddingLabel {
        let label: PaddingLabel = .init()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    static func makeStack(
        axis: NSLayoutConstraint.Axis = .vertical,
        distribution: UIStackView.Distribution = .fill,
        alignment: UIStackView.Alignment = .center
    ) -> UIStackView {
        let stackView: UIStackView = .init()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = axis
        stackView.distribution = distribution
        stackView.alignment = alignment
        return stackView
    }
    
    static func makeScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }
    
    static func makeTableView(
        delegate: UITableViewDelegate?,
        dataSource: UITableViewDataSource?
    ) -> UITableView {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = delegate
        tableView.dataSource = dataSource
        //tableView.estimatedRowHeight = 100
        return tableView
    }
    
    
}
