//
//  CodeTextField.swift
//  Appedir_Customer
//
//  Created by Appsinvo: Deepak on 06/02/20.
//  Copyright © 2020 Appsinvo. All rights reserved.
//

import UIKit

protocol CodeTextFieldDelegate {
    func didPressBackspace(textField: CodeTextField)
}

class CodeTextField: UITextField {
    
    var codeDelegate: CodeTextFieldDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.keyboardType = .numberPad
    }
    
    override func deleteBackward() {
        super.deleteBackward()
        codeDelegate?.didPressBackspace(textField: self)
        
    }
    
}

