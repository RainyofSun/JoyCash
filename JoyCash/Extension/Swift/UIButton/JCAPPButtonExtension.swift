//
//  JCAPPButtonExtension.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/19.
//

import UIKit

extension UIButton {
    class func buildJoyCashGradientButton(_ title: String, cornerRadius radius: CGFloat) -> JCAPPGradientColorButton {
        let view = JCAPPGradientColorButton(type: UIButton.ButtonType.custom)
        view.setTitle(title, for: UIControl.State.normal)
        view.setTitleColor(UIColor.white, for: UIControl.State.normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)
        view.layer.cornerRadius = radius
        view.clipsToBounds = true
        return view
    }
    
    class func buildJoyCashGradientLoadingButton(_ title: String, titleFont: UIFont? = UIFont.boldSystemFont(ofSize: 15), cornerRadius radius: CGFloat) -> JCAPPActivityButton {
        let view = JCAPPActivityButton(type: UIButton.ButtonType.custom)
        view.setTitle(title, for: UIControl.State.normal)
        view.setTitleColor(UIColor.white, for: UIControl.State.normal)
        view.titleLabel?.font = titleFont
        view.layer.cornerRadius = radius
        view.clipsToBounds = true
        return view
    }
    
    class func buildJoyCashImageButton(_ image: String, selectedImg: String? = nil, disableImg: String? = nil) -> UIButton {
        let view = UIButton(type: UIButton.ButtonType.custom)
        view.setImage(UIImage(named: image), for: UIControl.State.normal)
        if let _se = selectedImg {
            view.setImage(UIImage(named: _se), for: UIControl.State.selected)
        }
        
        if let _dis = disableImg {
            view.setImage(UIImage(named: _dis), for: UIControl.State.disabled)
        }
        
        return view
    }
    
    class func buildJoyCashNormalButton(_ title: String? = nil, titleFont font: UIFont = UIFont.systemFont(ofSize: 14), titleColor color: UIColor) -> UIButton {
        let view = UIButton(type: UIButton.ButtonType.custom)
        view.setTitle(title, for: UIControl.State.normal)
        view.setTitleColor(color, for: UIControl.State.normal)
        view.titleLabel?.font = font
        return view
    }
}
