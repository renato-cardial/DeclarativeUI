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
    
    static func makeTextView() -> UITextView {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .clear
        textView.contentInset = .zero
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }
    
    static func makeStack(
        axis: NSLayoutConstraint.Axis = .vertical,
        distribution: UIStackView.Distribution = .fill,
        alignment: UIStackView.Alignment = .fill
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
        scrollView.showsHorizontalScrollIndicator = DeclarativeUISettings.Scroll.showsHorizontalScrollIndicator
        scrollView.showsVerticalScrollIndicator = DeclarativeUISettings.Scroll.showsVerticalScrollIndicator
        scrollView.bounces = DeclarativeUISettings.Scroll.bounce
        
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
        tableView.showsHorizontalScrollIndicator = DeclarativeUISettings.Scroll.showsHorizontalScrollIndicator
        tableView.showsVerticalScrollIndicator = DeclarativeUISettings.Scroll.showsVerticalScrollIndicator
        tableView.bounces = DeclarativeUISettings.Scroll.bounce
        return tableView
    }
 
    static func makeImageView() -> UIImageView {
        let imageView: UIImageView = .init()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
}
