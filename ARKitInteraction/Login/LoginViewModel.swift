//
//  LoginViewModel.swift
//  ARKitInteraction
//
//  Created by Nato Egnatashvili on 04.11.22.
//  Copyright © 2022 Apple. All rights reserved.
//

import Combine
import UIKit
import Components

protocol LoginViewModelType {
    func transform(input: LoginViewModelInput) -> LoginViewModelOutput
}

struct LoginViewModelInput {
    let appear: AnyPublisher<Void, Never>
    let selection: AnyPublisher<LoginViewController.CellModelType, Never>
}

typealias LoginViewModelOutput = AnyPublisher<LoginViewModelState, Never>

enum LoginViewModelState: Equatable {
    case idle([LoginViewController.CellModelType])
    case list([LoginViewController.CellModelType])
}

class LoginViewModel: LoginViewModelType {
    private var cancellables: [AnyCancellable] = []
    private var navigator: LogInNavigatorType?
    
    public init(navigator: LogInNavigatorType) {
        self.navigator = navigator
    }
    
    func transform(input: LoginViewModelInput) -> LoginViewModelOutput {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        
        input.selection
            .sink(receiveValue: { [unowned self] type in
                self.handleSelection(type: type)
            }).store(in: &cancellables)
        
        let loaded: LoginViewModelOutput  = input.appear
            .map { LoginViewModelState.list(self.loadedListModels) }
            .eraseToAnyPublisher()
        
        let idle: LoginViewModelOutput = Just(.idle(idleModels))
            .setFailureType(to: Never.self)
            .eraseToAnyPublisher()
        
        return Publishers.Merge(idle, loaded).removeDuplicates().eraseToAnyPublisher()
    }
}


extension LoginViewModel {
    private var nameTextFIeldModel: BorderedTextField.Model {
        BorderedTextField.Model(textType: .name) { type, text in
            print(text)
        }
    }
    private var loadedListModels: [LoginViewController.CellModelType] {
        let f = LoginViewController.CellModelType.title("sheicvala ge")
        let s = LoginViewController.CellModelType.textField(nameTextFIeldModel)
        return [f,s]
    }
    
    private var idleModels: [LoginViewController.CellModelType] {
        let f = LoginViewController.CellModelType.title("ho ho")
        let s = LoginViewController.CellModelType.textField(nameTextFIeldModel)
        return [f,s]
    }
    
    private func handleSelection(type: LoginViewController.CellModelType) {
        switch type {
        case .title(let model):
            self.navigator?.move2CompanyAR(title: model)
        case .row(let k):
            print(k)
        case .textField:
            print("model")
        }
    }
}
