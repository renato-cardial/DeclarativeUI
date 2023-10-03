//
//  ListTableViewObject.swift
//  
//
//  Created by Renato Cardial on 10/3/23.
//

import UIKit

class ListTableViewObject: NSObject {
    var items: [ElementView] = []
    var selectRow: ((_ tableView: UITableView, _ indexPath: IndexPath) -> Void)?
}

// MARK: - UITableViewDelegate
extension ListTableViewObject: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectRow?(tableView, indexPath)
    }
    
}

// MARK: - UITableViewDataSource
extension ListTableViewObject: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListCell.identifier, for: indexPath) as? ListCell else {
            return .init()
        }
        let element = items[indexPath.row]
        cell.setContentView(element)
        return cell
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
