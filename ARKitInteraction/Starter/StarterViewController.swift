//
//  StarterViewController.swift
//  ARKitInteraction
//
//  Created by Nato Egnatashvili on 21.10.22.
//  Copyright © 2022 Apple. All rights reserved.
//

import Combine
import UIKit
import Components


class StarterViewController: UIViewController {
    
    private var cancellables: [AnyCancellable] = []
    private var viewModel: StarterViewModelType = StarterViewModel(navigator:
                                                                    StarterNavigator(controller: nil))
    @IBOutlet weak var tableView: UITableView!
    private lazy var dataSource = makeDataSource()
    private let selection = PassthroughSubject<CellModelType, Never>()
    private let appear = PassthroughSubject<Void, Never>()
    
    override func viewDidLoad() {
        
        viewModel = StarterViewModel(navigator:
                                        StarterNavigator(controller: self))
        configureUI()
        bind(to: viewModel)
    }
    
    private func move2ARController() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ViewControllerI")
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    private func configureUI() {
        
        tableView.register(ObjectTableCell.self,
                           forCellReuseIdentifier: "ObjectTableCell")
        tableView.dataSource = dataSource
        tableView.delegate = self
    }
    
    private func bind(to viewModel: StarterViewModelType) {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        let input = StarterViewModelInput(appear: appear.eraseToAnyPublisher(),
                                               selection: selection.eraseToAnyPublisher())

        let output = viewModel.transform(input: input)

        output.sink(receiveValue: {[unowned self] state in
            self.render(state)
        }).store(in: &cancellables)
    }
    
    private func render(_ state: StarterState) {
        switch state {
        case .list(let companies):
            update(with: companies, animate: true)
        }
    }
}

 extension StarterViewController {
    enum Section: CaseIterable {
        case companys
    }
    
    enum CellModelType: Hashable {
        case companyModell(CompaniesModel)
    }

    func makeDataSource() -> UITableViewDiffableDataSource<Section,  CellModelType> {
        return UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: {  tableView, indexPath, type in
                switch type {
                case .companyModell(let model):
                    let cell = tableView.dequeueReusableCell(withIdentifier: model.tableCellModel.nibIdentifier) as? ConfigurableTableCell
                    cell?.configure(with: model.tableCellModel)
                    return cell ?? UITableViewCell()
                }
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

extension StarterViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snapshot = dataSource.snapshot()
        
        selection.send(snapshot.itemIdentifiers[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
