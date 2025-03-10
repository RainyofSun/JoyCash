//
//  JCAPPWeakScriptHandler.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/19.
//

import UIKit
import WebKit

class JCAPPWeakScriptHandler: NSObject {
    //MARK:- 属性设置 之前这个属性没有用weak修饰,所以一直持有,无法释放
    private weak var scriptHandler: WKScriptMessageHandler!
    
    //MARK:- 初始化
    convenience init(weakScriptHandler handler: WKScriptMessageHandler) {
        self.init()
        self.scriptHandler = handler
    }
    
    deinit {
        deallocPrint()
    }
}

extension JCAPPWeakScriptHandler: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        scriptHandler.userContentController(userContentController, didReceive: message)
    }
}
