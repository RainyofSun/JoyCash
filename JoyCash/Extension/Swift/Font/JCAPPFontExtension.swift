//
//  JCAPPFontExtension.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/20.
//

import UIKit

extension UIFont {
    class func JCAPPgilroyFont(_ size: CGFloat) -> UIFont {
        // HelveticaNeue-BoldItalic
        return UIFont(name: "Gilroy", size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }
    
    class func JCAPPDDINRegularFont(_ size: CGFloat) -> UIFont {
        // HelveticaNeue-BoldItalic
        return UIFont(name: "D-DIN", size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }
    
    class func JCAPPDDINBoldFont(_ size: CGFloat) -> UIFont {
        // HelveticaNeue-BoldItalic
        return UIFont(name: "D-DIN-Bold", size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }
    
    class func JCAPPDDINItalicFont(_ size: CGFloat) -> UIFont {
        // HelveticaNeue-BoldItalic
        return UIFont(name: "D-DIN-Italic", size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }
}
