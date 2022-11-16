//
//  ObjectListViewModel.swift
//  ARKitInteraction
//
//  Created by Nato Egnatashvili on 24.10.22.
//  Copyright © 2022 Apple. All rights reserved.
//

import Foundation
import Combine


protocol ObjectListViewModelType {
    func transform(input: ObjectListViewModelInput) -> ObjectListViewModelOutput
}

struct ObjectListViewModelInput {
    // called when a screen becomes visible
    let appear: AnyPublisher<Void, Never>
    // triggered when a search query is updated
    let search: AnyPublisher<String, Never>
    // called when a user selected an item from the list
    let selection: AnyPublisher<Int, Never>
}

typealias ObjectListViewModelOutput = AnyPublisher<ObjectListState, Never>

enum ObjectListState: Equatable {
    case idle
    case loading
    case success([ObjectModel])
}


final class ObjectListViewModel: ObjectListViewModelType {

    private var navigator: ObjectListNavigatorType?
   // private let useCase: ObjectListUseCaseType
    private var cancellables: [AnyCancellable] = []
    private let objects: [ObjectModel]
    init(
         navigator: ObjectListNavigatorType,
         objects: [ObjectModel]) {
       // self.useCase = useCase
        self.navigator = navigator
        self.objects = objects
    }
    
    func transform(input: ObjectListViewModelInput) -> ObjectListViewModelOutput {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        
        input.selection
            .sink(receiveValue: { [unowned self] movieId
                in self.navigator?.showDetails() })
            .store(in: &cancellables)
        
        let movies: ObjectListViewModelOutput = Just(.success(self.objects))
            .setFailureType(to: Never.self)
            .eraseToAnyPublisher()
        
        let initialState: ObjectListViewModelOutput = Just(ObjectListState.idle)
            .setFailureType(to: Never.self)
            .eraseToAnyPublisher()
        
        return Publishers.Merge(initialState, movies).removeDuplicates().eraseToAnyPublisher()
    }
}
