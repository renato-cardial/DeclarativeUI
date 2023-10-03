//
//  List.swift
//  DeclarativeUI
//
//  Created by Renato Cardial on 10/2/23.
//

import UIKit

public class List: ElementView {
    
    public override var elementView: UIView { return tableView }
    
    private var elements: [ElementView] = []
    private var blockElements: (() -> [ElementView])
    private var blockSelectedRow: ((_ id: String, _ element: ElementView) -> Void)?
    var listTableViewObject: ListTableViewObject = .init()
    
    private lazy var tableView: UITableView = FactoryView.makeTableView(
        delegate: listTableViewObject,
        dataSource: listTableViewObject
    )
    
    public init(
        id: String = UUID().uuidString,
        @LayoutBuilder _ elements: @escaping () -> [ElementView]
    ) {
        self.blockElements = elements
        super.init()
        self.identifier = id
        prepareTable()
        afterEmbeded.append { [weak self] in
            self?.loadData()
        }
    }
    
    func loadData() {
        elements = blockElements()
        listTableViewObject.items = elements.get()
        tableView.reloadData()
    }
    
    public func selectedRow(_ completion: ((_ id: String, _ element: ElementView) -> Void)?) -> Self {
        blockSelectedRow = completion
        return self
    }
    
    private func prepareTable() {
        tableView.register(ListCell.self, forCellReuseIdentifier: ListCell.identifier)
        prepareTableEvents()
        references.append(listTableViewObject)
    }
    
    private func prepareTableEvents(){
        listTableViewObject.selectRow = { (tableView, indexPath) in
            let item = self.listTableViewObject.items[indexPath.row]
            self.blockSelectedRow?(item.identifier, item)
        }
    }
        
}
