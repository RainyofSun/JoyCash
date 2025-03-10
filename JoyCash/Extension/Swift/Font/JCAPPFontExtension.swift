//
//  JCAPPFontExtension.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/20.
//

import UIKit

extension UIFont {
    class func gilroyFont(_ size: CGFloat) -> UIFont {
        // HelveticaNeue-BoldItalic
        return UIFont(name: "Gilroy", size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }
}
