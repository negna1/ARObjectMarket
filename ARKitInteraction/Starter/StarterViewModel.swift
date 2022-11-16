//
//  ARKitInteraction
//
//  Created by Nato Egnatashvili on 21.10.22.
//  Copyright © 2022 Apple. All rights reserved.
//

import Combine
import UIKit

protocol StarterViewModelType {
    func transform(input: StarterViewModelInput) -> StarterViewModelOutput
}

struct StarterViewModelInput {
    let appear: AnyPublisher<Void, Never>
    let selection: AnyPublisher<StarterViewController.CellModelType, Never>
}

typealias StarterViewModelOutput = AnyPublisher<StarterState, Never>

enum StarterState: Equatable {
    case list([StarterViewController.CellModelType])
}

class StarterViewModel: StarterViewModelType {
    private var cancellables: [AnyCancellable] = []
    private var navigator: StarterNavigatorType?
    
    public init(navigator: StarterNavigatorType) {
        self.navigator = navigator
    }
    
    func transform(input: StarterViewModelInput) -> StarterViewModelOutput {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        input.selection
            .sink(receiveValue: { [unowned self] type in
                switch type {
                    
                case .companyModell(let model):
                    self.navigator?.move2CompanyAR(title: model.title)
                    print(model)
                }
                
            })
            .store(in: &cancellables)
        
        let companiesModel = CompaniesModel.init(icon: UIImage(named: "gorgia"), title: "Gorgia")
        let vase = CompaniesModel.init(icon: UIImage(named: "jsyk"), title: "Jysk")
        let f = StarterViewController.CellModelType.companyModell(companiesModel)
        let s = StarterViewController.CellModelType.companyModell(vase)
        let companies: StarterViewModelOutput = Just(.list([f,s]))
            .setFailureType(to: Never.self)
            .eraseToAnyPublisher()
        
        return companies
    }
}
