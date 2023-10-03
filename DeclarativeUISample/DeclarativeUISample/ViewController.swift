//
//  ViewController.swift
//  DeclarativeUISample
//
//  Created by Renato Cardial on 10/2/23.
//

import UIKit
import DeclarativeUI

class ViewController: Layout, RenderLayout {
    var teste: Bool = false
    
    var body: LayoutBody {
        List {
            ForEach(0..<100) { number in
                self.create(number)
            }
        }        
        .background(.red)
        .selectedRow { id, element in
            print("ID = \(id)")
        }
    }

    func create(_ number: Int) -> ElementView {
        if number % 2 == 0 {
            return Text("Element \(number)", id: "\(number)")
                .padding(20)
                .background(.yellow)
                .frame(maxWidth: .infinity)
        } else {
            return VStack(id: "\(number)", margin: 0, padding: 0) {
                Text("Element \(number)")
                Text("Descripton of Element")
            }
            .background(.blue)
            .margin(20)
            .padding(20)
        }
    }
    
}



extension ElementView {
    
    static func forEach(_ data: Range<Int>, _ element: @escaping (Int) -> ElementView) -> [ElementView] {
        var elements: [ElementView] = []
        data.forEach { number in
            let item = element(number)
            elements.append(item)
        }
        return elements
    }
}

/*
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = "Testando"
        return cell
    }
    
    
    static func makeTableView(
        delegate: UITableViewDelegate?,
        dataSource: UITableViewDataSource?
    ) -> UITableView {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = delegate
        tableView.dataSource = dataSource
        //tableView.separatorStyle = .none
        return tableView
    }
    
    private lazy var tableView: UITableView = ViewController.makeTableView(
        delegate: self,
        dataSource: self
    )
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        
    }
    
}
*/
