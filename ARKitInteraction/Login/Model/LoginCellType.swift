//
//  LoginCellType.swift
//  ARKitInteraction
//
//  Created by Nato Egnatashvili on 04.11.22.
//  Copyright © 2022 Apple. All rights reserved.
//

import Components

extension LoginViewController.CellModelType {
    var tableCellModel: TableCellModel {
        switch self {
        case .title(let title):
            return ObjectTableCell.CellModel.init(title: title)
        case .row(let second):
            return CenterTitleTableCell.CellModel.init(title: second)
        case .textField(let model):
            return TextFieldTableCell.CellModel(borderModel: model)
        }
    }
}
 
extension LoginViewController {
    enum Section: CaseIterable {
        case companys
    }
    
    enum CellModelType: Hashable {
        case title(String)
        case row(String)
        case textField(BorderedTextField.Model)
    }
}
