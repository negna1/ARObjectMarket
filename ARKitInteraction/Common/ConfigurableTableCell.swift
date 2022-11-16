//
//  ConfigurableTableCell.swift
//  ARKitInteraction
//
//  Created by Nato Egnatashvili on 28.10.22.
//  Copyright © 2022 Apple. All rights reserved.
//

//import UIKit
//
//public struct TableSection {
//    var header: TableHeaderFooterModel?
//    var cells: [ TableCellModel]
//    var footer: TableHeaderFooterModel?
//    
//    init(header: TableHeaderFooterModel? = nil,
//         cells: [ TableCellModel],
//         footer: TableHeaderFooterModel? = nil) {
//        self.header = header
//        self.cells = cells
//        self.footer = footer
//    }
//}
//
//
//public protocol TableHeaderFooterModel {
//    var nibIdentifier: String { get }
//    var height: Double { get }
//}
//
//
//public protocol TableCellModel {
//    var nibIdentifier: String { get }
//    var height: Double { get }
//}
//
//
//public protocol ConfigurableTableHeaderFooter {
//    func configure(with model: TableHeaderFooterModel)
//}
//
//
//public protocol ConfigurableTableCell: UITableViewCell {
//    func configure(with model: TableCellModel)
//}
