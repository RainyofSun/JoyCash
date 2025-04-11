//
//  JCAPPTextFiledExtension.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/19.
//

import UIKit

extension UITextField {
    class func buildJoyCashNormalTextFiled(placeHolder: NSAttributedString, textFont: UIFont = UIFont.systemFont(ofSize: 15), textColor: UIColor = BLACK_COLOR_2F3127) -> ForbidActionTextFiled {
        let view = ForbidActionTextFiled(frame: CGRectZero)
        view.borderStyle = .none
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.backgroundColor = UIColor.init(hexString: "#F9F9F9")!
        view.attributedPlaceholder = placeHolder
        view.keyboardType = .numberPad
        return view
    }
    
    class func buildJoyCashLoginTextFiled(placeHolder: NSAttributedString, textFont: UIFont = UIFont.systemFont(ofSize: 15), textColor: UIColor = BLACK_COLOR_2F3127) -> ForbidActionTextFiled {
        let view = ForbidActionTextFiled(frame: CGRectZero)
        view.borderStyle = .none
        view.layer.cornerRadius = 27
        view.clipsToBounds = true
        view.backgroundColor = .white
        view.attributedPlaceholder = placeHolder
        view.keyboardType = .numberPad
        return view
    }
}
