//
//  File.swift
//  
//
//  Created by Nato Egnatashvili on 11.11.22.
//

import Foundation

extension BorderedTextField {
    public struct Model:  Hashable {
        public static func == (lhs: BorderedTextField.Model, rhs: BorderedTextField.Model) -> Bool {
            lhs.textType == rhs.textType
        }
        
        public func hash(into hasher: inout Hasher) {
           hasher.combine(textType)
         }
        
        public var textType: BorderedTextField.TextType = .name
        public var placeHolder: String?
        public var didChangeText: ((BorderedTextField.TextType, String) -> ())?
        
        public init(textType: BorderedTextField.TextType = .name,
                    placeHolder: String? = nil,
         didChangeText: ((BorderedTextField.TextType, String) -> ())?) {
            self.placeHolder =  placeHolder ?? textType.rawValue
            self.textType = textType
            self.didChangeText = didChangeText
        }
    }
}

extension BorderedTextField {
    public enum TextType: String {
        case name
        case lastName
        case username
        case mobile
        case password
    }
}
