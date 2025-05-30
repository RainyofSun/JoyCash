//
//  JCAPPButtonExtension.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/19.
//

import UIKit

extension UIButton {
    class func JCAPPbuildJoyCashGradientButton(_ title: String, cornerRadius radius: CGFloat) -> APPGradientColorButton {
        let view = APPGradientColorButton(type: UIButton.ButtonType.custom)
        view.setTitle(title, for: UIControl.State.normal)
        view.setTitleColor(UIColor.white, for: UIControl.State.normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)
        view.layer.cornerRadius = radius
        view.clipsToBounds = true
        return view
    }
    
    class func JCAPPbuildJoyCashGradientLoadingButton(_ title: String, titleFont: UIFont? = UIFont.boldSystemFont(ofSize: 15), cornerRadius radius: CGFloat) -> APPActivityButton {
        let view = APPActivityButton(type: UIButton.ButtonType.custom)
        view.setTitle(title, for: UIControl.State.normal)
        view.setTitleColor(UIColor.white, for: UIControl.State.normal)
        view.titleLabel?.font = titleFont
        view.layer.cornerRadius = radius
        view.clipsToBounds = true
        view.setGradientColors([JCAPP_ORANGE_COLOR_F89151, JCAPP_ORANGE_COLOR_F44F33], style: .topToBottom)
        return view
    }
    
    class func JCAPPbuildJoyCashImageButton(_ image: String, selectedImg: String? = nil, disableImg: String? = nil) -> UIButton {
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
    
    class func JCAPPbuildJoyCashNormalButton(_ title: String? = nil, titleFont font: UIFont = UIFont.systemFont(ofSize: 14), titleColor color: UIColor) -> UIButton {
        let view = UIButton(type: UIButton.ButtonType.custom)
        view.setTitle(title, for: UIControl.State.normal)
        view.setTitleColor(color, for: UIControl.State.normal)
        view.titleLabel?.font = font
        return view
    }
}
