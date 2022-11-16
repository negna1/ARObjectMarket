//
//  LoginViewController.swift
//  ARKitInteraction
//
//  Created by Nato Egnatashvili on 04.11.22.
//  Copyright © 2022 Apple. All rights reserved.
//


import Combine
import UIKit
import Components
import Foundation

class LoginViewController: UIViewController {
    
    private var cancellables: [AnyCancellable] = []
    private var viewModel: LoginViewModelType!
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private lazy var dataSource = makeDataSource()
    private let selection = PassthroughSubject<CellModelType, Never>()
    private let appear = PassthroughSubject<Void, Never>()
    
    public func bind(with viewModel: LoginViewModelType) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        configureUI()
        bind(to: viewModel)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.appear.send()
        }
    }
    
    private func configureUI() {
        constrain()
        registerCells()
        tableView.dataSource = dataSource
        tableView.delegate = self
        
    }
    
    private func constrain() {
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.trailing.leading.top.bottom.equalToSuperview()
        }
    }
    
    private func registerCells() {
        tableView.register(ObjectTableCell.self,
                           forCellReuseIdentifier: "ObjectTableCell")
        tableView.register(CenterTitleTableCell.self,
                           forCellReuseIdentifier: "CenterTitleTableCell")
        tableView.register(TextFieldTableCell.self,
                           forCellReuseIdentifier: "TextFieldTableCell")
        
        
    }
    
    private func bind(to viewModel: LoginViewModelType) {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        let input = LoginViewModelInput(appear: appear.eraseToAnyPublisher(),
                                               selection: selection.eraseToAnyPublisher())

        let output = viewModel.transform(input: input)

        output.sink(receiveValue: {[unowned self] state in
            self.render(state)
        }).store(in: &cancellables)
    }
    
    private func render(_ state: LoginViewModelState) {
        switch state {
        case .list(let cells):
            update(with: cells, animate: true)
        case .idle(let cells):
            update(with: cells, animate: true)
        }
    }
}
 
//MARK: - Data source and reload 
 extension LoginViewController {
    func makeDataSource() -> UITableViewDiffableDataSource<Section,  CellModelType> {
        return UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: {  tableView, indexPath, type in
                let cell = tableView.dequeueReusableCell(withIdentifier: type.tableCellModel.nibIdentifier) as? ConfigurableTableCell
                cell?.configure(with: type.tableCellModel)
                return cell ?? UITableViewCell()
            }
        )
    }

    func update(with models: [CellModelType], animate: Bool = true) {
        DispatchQueue.main.async {
            var snapshot = NSDiffableDataSourceSnapshot<Section,  CellModelType>()
            snapshot.appendSections(Section.allCases)
            snapshot.appendItems(models, toSection: .companys)
            self.dataSource.apply(snapshot, animatingDifferences: animate)
        }
    }
}

//MARK: - Cell Tap
extension LoginViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snapshot = dataSource.snapshot()
        selection.send(snapshot.itemIdentifiers[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

