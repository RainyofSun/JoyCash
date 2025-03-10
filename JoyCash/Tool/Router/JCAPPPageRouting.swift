//
//  JCAPPPageRouting.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/19.
//

import UIKit

class JCAPPPageRouting: NSObject {
    
    public static let shared = JCAPPPageRouting()

    /// 跳转原生页面
    public func JoyCashPageRouter(routeUrl url: String, backToRoot root: Bool = false, targetVC: UIViewController? = nil) {
        guard let _rootController = UIDevice.current.keyWindow().rootViewController as? JCAPPBaseTabBarController else {
            return
        }
        let _topVC = _rootController.top()
        
        if url.hasPrefix("http") {
            _topVC.navigationController?.pushViewController(JCAPPWebPageViewController(withWebLinkURL:  JCAPPPublicParams.splicingPublicParams(url), backToRoot: root), animated: true)
        } else {
            if url.contains(APP_SETTING_PAGE) {
                _topVC.navigationController?.pushViewController(JCAPPUserSettingViewController(), animated: true)
            } else if url.contains(APP_HOME_PAGE) {
                _topVC.navigationController?.popToRootViewController(animated: false)
                _rootController.selectedIndex = 0
            } else if url.contains(APP_LOGIN_PAGE) {
                let loginNav: JCAPPBaseNavigationController = JCAPPBaseNavigationController(rootViewController:     JCAPPUserLoginViewController())
                loginNav.modalPresentationStyle = .fullScreen
                _rootController.present(loginNav, animated: true)
                _topVC.navigationController?.popToRootViewController(animated: false)
            } else if url.contains(APP_ORDER_PAGE) {
                _topVC.navigationController?.popToRootViewController(animated: false)
                _rootController.selectedIndex = 1
            } else if url.contains(APP_PRODUCT_DETAIL) {
                _topVC.navigationController?.pushViewController(JCAPPCommodityViewController(withCommodityIDNumber:    self.separationURLParameter(url: url)), animated: true)
            } else {
                if let _t = targetVC {
                    _topVC.navigationController?.pushViewController(_t, animated: true)
                }
            }
        }
    }
}

private extension JCAPPPageRouting {
    func separationURLParameter(url: String) -> String {
        let paraStr = url.components(separatedBy: "?").last
        let paraStr1 = paraStr?.components(separatedBy: "=").last
        return paraStr1 ?? ""
    }
}
