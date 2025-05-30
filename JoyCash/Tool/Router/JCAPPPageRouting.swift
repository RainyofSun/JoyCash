//
//  JCAPPPageRouting.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/19.
//

import UIKit

class JCAPPPageRouting: NSObject {
    
    public static let shared = JCAPPPageRouting()
    
    private var webFuncHandlers:[String] = [JC_CloseWebPage, JC_PageTransitionNoParams, JC_PageTransitionWithParams, JC_CloseAndGotoHome,
                                            JC_CloseAndGotoLoginPage, JC_CloseAndGotoMineCenter, JC_GotoAppStore, JC_ConfirmApplyBury,
                                            JC_StartBindingBankCard, JC_EndBindingBankCard]
    
    /// 跳转原生页面
    public func JCAPPJoyCashPageRouter(routeUrl url: String, backToRoot root: Bool = false, targetVC: UIViewController? = nil) {
        guard let _rootController = UIDevice.current.keyWindow().rootViewController as? JCAPPBaseTabBarController else {
            return
        }
        let _topVC = _rootController.jk.topViewController()
        
        if url.hasPrefix("http") {
            _topVC?.navigationController?.pushViewController(JCAPPWebPageViewController(withWebLinkURL: APPPublicParams.request().splicingPublicParams(url), backToRoot: root, webFuncScriptHandler: self.webFuncHandlers), animated: true)
        } else {
            if url.contains(APP_SETTING_PAGE) {
                _topVC?.navigationController?.pushViewController(JCAPPUserSettingViewController(), animated: true)
            } else if url.contains(APP_HOME_PAGE) {
                _topVC?.navigationController?.popToRootViewController(animated: false)
                _rootController.selectedIndex = 0
            } else if url.contains(APP_LOGIN_PAGE) {
                let loginNav: JCAPPBaseNavigationController = JCAPPBaseNavigationController(rootViewController:     JCAPPUserLoginViewController())
                loginNav.modalPresentationStyle = .fullScreen
                _rootController.present(loginNav, animated: true)
                _topVC?.navigationController?.popToRootViewController(animated: false)
            } else if url.contains(APP_ORDER_PAGE) {
                _topVC?.navigationController?.popToRootViewController(animated: false)
                _rootController.selectedIndex = 1
            } else if url.contains(APP_PRODUCT_DETAIL) {
                _topVC?.navigationController?.pushViewController(JCAPPCommodityViewController(withCommodityIDNumber:    self.JCAPPseparationURLParameter(url: url)), animated: true)
            } else {
                if let _t = targetVC {
                    _topVC?.navigationController?.pushViewController(_t, animated: true)
                }
            }
        }
    }
}

private extension JCAPPPageRouting {
    func JCAPPseparationURLParameter(url: String) -> String {
        let paraStr = url.components(separatedBy: "?").last
        let paraStr1 = paraStr?.components(separatedBy: "=").last
        return paraStr1 ?? ""
    }
}
