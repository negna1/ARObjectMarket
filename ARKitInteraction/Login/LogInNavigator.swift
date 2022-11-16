//
//  LogInNavigator.swift
//  ARKitInteraction
//
//  Created by Nato Egnatashvili on 04.11.22.
//  Copyright © 2022 Apple. All rights reserved.
//

import Foundation
import UIKit

protocol LogInNavigatorType {
    func move2CompanyAR(title: String)
}

final class LogInNavigator: LogInNavigatorType {
    private weak var controller: LoginViewController?
    public init(controller: LoginViewController?) {
        self.controller = controller
    }
    
    func move2CompanyAR(title: String) {
        
    }
}
