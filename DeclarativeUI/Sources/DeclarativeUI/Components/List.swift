//
//  List.swift
//  DeclarativeUI
//
//  Created by Renato Cardial on 10/2/23.
//

import UIKit

/**
All content inside this component will be presented in a list, your content is reusable, so is indicate for large number of elements

Example of use:
 ```
List {
     ForEach(0..<100) { number in
         Text("Row \(number)")
             .padding(20)
             .background(.cyan)
     }
}
```
*/
public class List: ElementView {
    
    public override var elementView: UIView { return tableView }
    
    private var elements: [ElementView] = []
    private var blockElements: (() -> [ElementView])
    private var blockSelectedRow: ((_ id: String, _ element: ElementView) -> Void)?
    
    var listTableViewObject: ListTableViewObject? = .init()
    private var skeletonActive: Bool = false
    
    private lazy var tableView: UITableView = FactoryView.makeTableView(
        delegate: listTableViewObject,
        dataSource: listTableViewObject
    )
    
    public init(
        id: String = UUID().uuidString,
        @LayoutBuilder _ elements: @escaping () -> [ElementView]
    ) {
        self.blockElements = elements
        super.init(identifier: id)
        prepareTable()
        afterEmbeded.append { [weak self] in
            self?.loadData()
        }
    }
    
    func loadData() {
        elements = blockElements()
        let items = elements.get()
        
        removeAllChildren()
        items.forEach { item in
            addChild(item)
            if skeletonActive {
                item.skeleton()
            }
        }
        
        listTableViewObject?.items = items
        tableView.reloadData()
    }
    
    public func selectedRow(_ completion: ((_ id: String, _ element: ElementView) -> Void)?) -> Self {
        blockSelectedRow = completion
        return self
    }
    
    private func prepareTable() {
        tableView.register(ListCell.self, forCellReuseIdentifier: ListCell.identifier)
        tableView.separatorStyle = .none
        prepareTableEvents()
        if let listTableViewObject = listTableViewObject {
            references.append(listTableViewObject)
        }
        
    }
    
    private func prepareTableEvents(){
        listTableViewObject?.selectRow = { [weak self] (tableView, indexPath) in
            guard let listTableViewObject = self?.listTableViewObject else { return }
            let item = listTableViewObject.items[indexPath.row]
            self?.blockSelectedRow?(item.identifier, item)
        }
    }
    
    @discardableResult
    override public func skeleton(_ active: Bool = true) -> Self {
        skeletonActive = active
        return self
    }
        
}
