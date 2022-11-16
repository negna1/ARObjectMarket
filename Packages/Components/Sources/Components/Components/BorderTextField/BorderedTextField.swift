//
//  File.swift
//  
//
//  Created by Nato Egnatashvili on 11.11.22.
//

import UIKit
import SnapKit

public class BorderedTextField: UIView {
    
    private lazy var textField: UITextField = {
        let txt = UITextField()
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()
    
    private  var view: UIView = {
        let txt = UIView()
        txt.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()
    
    private  var lbl: UILabel = {
        let txt = UILabel()
        txt.backgroundColor = .white
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()
    
    private var didChangeText: ((BorderedTextField.TextType, String) -> ())?
    private var textType: BorderedTextField.TextType = .name
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        constrain()
        styleUI()
    }
    
    public init(with model: Model? = nil) {
        super.init(frame: .zero)
        guard let model = model else {
            constrain()
            styleUI()
            return
        }
        configure(with: model)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: Model) {
        didChangeText = model.didChangeText
        textType = model.textType
        textField.placeholder = textType.rawValue
    }
    
    private func constrain() {
        self.addSubview(view)
        self.addSubview(lbl)
        view.addSubview(textField)
        
        view.snp.makeConstraints { make in
            make.top.right.bottom.left.equalToSuperview().inset(10)
        }
        
        textField.snp.makeConstraints { make in
            make.top.right.bottom.left.equalToSuperview().inset(8)
        }
        
        lbl.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().inset(40)
        }
    }
    
    private func styleUI() {
        styleView()
        styleTextField()
    }
    
    private func styleTextField() {
        textField.addTarget(self, action: #selector(valueChanged), for: .editingChanged)
    }
    
    private func styleView() {
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.cornerRadius = 10
    }
}


extension BorderedTextField: UITextFieldDelegate {
    @objc func valueChanged(_ textField: UITextField){
        self.lbl.text = (textField.text?.isEmpty ?? true) ? nil : textType.rawValue
        self.didChangeText?(self.textType, textField.text ?? "")
    }
}
