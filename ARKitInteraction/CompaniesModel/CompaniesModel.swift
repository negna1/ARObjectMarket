//
//  CompaniesModel.swift
//  ARKitInteraction
//
//  Created by Nato Egnatashvili on 28.10.22.
//  Copyright © 2022 Apple. All rights reserved.
//

import UIKit
import SwiftUI
import Components

struct CompaniesModel: Hashable {
    static func == (lhs: CompaniesModel, rhs: CompaniesModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: UUID = UUID()
    let tableCellModel: ObjectTableCell.CellModel
    let icon: UIImage?
    let title: String
    
    init( icon: UIImage?, title: String) {
        self.tableCellModel = ObjectTableCell.CellModel(title: title, icon: icon)
        self.icon = icon
        self.title = title
    }
}
