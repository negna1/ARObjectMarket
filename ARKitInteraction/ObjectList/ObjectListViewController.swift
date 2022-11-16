//
//  ObjectListViewController.swift
//  ARKitInteraction
//
//  Created by Nato Egnatashvili on 24.10.22.
//  Copyright © 2022 Apple. All rights reserved.
//

import UIKit
import Combine
import Components

class ObjectListViewController : UIViewController {

    private var cancellables: [AnyCancellable] = []
    private let viewModel: ObjectListViewModelType
    private let selection = PassthroughSubject<Int, Never>()
    private let search = PassthroughSubject<String, Never>()
    private let appear = PassthroughSubject<Void, Never>()
    private var tableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        return table
    }()
    
    private lazy var dataSource = makeDataSource()

    init(viewModel: ObjectListViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("Not supported!")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind(to: viewModel)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        appear.send(())
    }

    private func configureUI() {
        view.addSubview(tableView)
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        tableView.register(ObjectTableCell.self,
                           forCellReuseIdentifier: "ObjectTableCell")
        tableView.dataSource = dataSource

    }

    private func bind(to viewModel: ObjectListViewModelType) {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        let input = ObjectListViewModelInput(appear: appear.eraseToAnyPublisher(),
                                               search: search.eraseToAnyPublisher(),
                                               selection: selection.eraseToAnyPublisher())

        let output = viewModel.transform(input: input)

        output.sink(receiveValue: {[unowned self] state in
            self.render(state)
        }).store(in: &cancellables)
    }

    private func render(_ state: ObjectListState) {
        switch state {
        case .idle:
            print("idle")
        case .loading:
            print("loading")
            update(with: [], animate: true)
        case .success(let movies):
            update(with: movies, animate: true)
        }
    }
}

fileprivate extension ObjectListViewController {
    enum Section: CaseIterable {
        case movies
    }

    func makeDataSource() -> UITableViewDiffableDataSource<Section, ObjectModel> {
        return UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: {  tableView, indexPath, movieViewModel in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "ObjectTableCell") as? ObjectTableCell else {
                    assertionFailure("Failed to dequeue \(ObjectTableCell.self)!")
                    return UITableViewCell()
                }
                cell.configure(with: ObjectTableCell
                    .CellModel(title: movieViewModel.title) )
                return cell
            }
        )
    }

    func update(with movies: [ObjectModel], animate: Bool = true) {
        DispatchQueue.main.async {
            var snapshot = NSDiffableDataSourceSnapshot<Section, ObjectModel>()
            snapshot.appendSections(Section.allCases)
            snapshot.appendItems(movies, toSection: .movies)
            self.dataSource.apply(snapshot, animatingDifferences: animate)
        }
    }
}

extension ObjectListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snapshot = dataSource.snapshot()
        selection.send(snapshot.itemIdentifiers[indexPath.row].id)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
