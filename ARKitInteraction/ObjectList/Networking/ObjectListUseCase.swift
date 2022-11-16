//
//  ObjectListUseCase.swift
//  ARKitInteraction
//
//  Created by Nato Egnatashvili on 24.10.22.
//  Copyright © 2022 Apple. All rights reserved.
//

import Foundation
import Combine


protocol ObjectListUseCaseType {

    // Runs movies search with a query string
    func searchMovies(with name: String) -> AnyPublisher<Result<[String], Error>, Never>?

    // Fetches details for movie with specified id
    func movieDetails(with name: String) -> AnyPublisher<Result<[String], Error>, Never>?

}


final class ObjectListUseCase: ObjectListUseCaseType {
    func movieDetails(with name: String) -> AnyPublisher<Result<[String], Error>, Never>? {
        return nil
    }
    
    func searchMovies(with name: String) -> AnyPublisher<Result<[String], Error>, Never>? {
        return nil
    }
}
