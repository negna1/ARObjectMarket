//
//  StarterNavigator.swift
//  ARKitInteraction
//
//  Created by Nato Egnatashvili on 28.10.22.
//  Copyright © 2022 Apple. All rights reserved.
//

import Foundation
import UIKit

protocol StarterNavigatorType {
    func move2CompanyAR(title: String)
}

final class StarterNavigator: StarterNavigatorType {
    private weak var controller: StarterViewController?
    public init(controller: StarterViewController?) {
        self.controller = controller
    }
    
    func move2CompanyAR(title: String) {
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ViewControllerI")
//        self.controller?.navigationController?.pushViewController(nextViewController, animated: true)
//
        let v = LoginViewController.init()
        let navigator = LogInNavigator(controller: v)
        let mod = LoginViewModel.init(navigator: navigator)
        v.bind(with: mod)
        self.controller?.navigationController?.pushViewController(v, animated: true)
    }
}

