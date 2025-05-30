//
//  JCAPPBaseTabBarController.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/19.
//

import UIKit

class JCAPPBaseTabBarController: UITabBarController {

    private var jcTabBar: JCAPPCustomBar?
    private var JCAPPvcArray: [UIViewController.Type] = [JCAPPMainViewController.self, JCAPPCommodityOrderViewController.self, JCAPPMinePageViewController.self]
    private var JCAPPtab_img_array: [String] = ["tab_main_nor", "tab_order_nor", "tab_mine_nor"]
    private var JCAPPtab_sel_img_array: [String] = ["tab_main_sel", "tab_order_sel", "tab_mine_sel"]
    
    override var selectedIndex: Int {
        didSet {
            self.jcTabBar?.JCAPPselectedTabbarItem(selectedIndex)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.JCAPPsetupTabbarUI()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let _k_p = keyPath, let _new_value = change?[.newKey] as? Bool {
            if _k_p == LOGIN_OBERVER_KEY && !_new_value {
                self.selectedIndex = .zero
            }
        }
    }
    
    deinit {
        deallocPrint()
    }
}

private extension JCAPPBaseTabBarController {
    func JCAPPsetupTabbarUI() {
        // 保存标识-- 第一次安装
        APPInfomationCache.saveApplicationInstallMark()
        let tabbar: JCAPPCustomBar = JCAPPCustomBar(frame: CGRect(origin: CGPointZero, size: CGSize(width: ScreenWidth, height: UIDevice.app_tabbarAndSafeAreaHeight())))
        self.setValue(tabbar, forKey: "tabBar")
        tabbar.JCAPPsetTabbarTitles(barItemImages: JCAPPtab_img_array, barItemSelectedImages: JCAPPtab_sel_img_array)
        tabbar.barDelegate = self
        var listVC: [UIViewController] = []
        JCAPPvcArray.forEach { (item: UIViewController.Type) in
            listVC.append(JCAPPBaseNavigationController(rootViewController: item.init()))
        }
        self.viewControllers = listVC
        
        self.jcTabBar = tabbar
        self.selectedIndex = .zero
        
        JCAPPPublic.shared.addObserver(self, forKeyPath: LOGIN_OBERVER_KEY, options: [.new], context: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(JCAPPneedUserRelogin), name: NSNotification.Name(APP_LOGIN_EXPIRED_NOTIFICATION), object: nil)
    }
}

extension JCAPPBaseTabBarController: VCCustomTabbarProtocol {
    func JCAPPjc_canSelected(shouldSelectedIndex index: Int) -> Bool {
        guard let _vc_array = self.viewControllers, index < _vc_array.count else {
            return false
        }
        
        guard let _nav = _vc_array[index] as? JCAPPBaseNavigationController else {
            return false
        }
        
        let _top_vc = _nav.topViewController
        if (_top_vc is JCAPPCommodityOrderViewController || _top_vc is JCAPPMinePageViewController) && JCAPPPublic.shared.appLoginInfo?.any == nil {
            self.JCAPPneedUserRelogin()
            return false
        }
        
        return true
    }
    
    func JCAPPjc_didSelctedItem(_ tabbar: JCAPPCustomBar, item: UIButton, index: Int) {
        self.selectedIndex = index
    }
}

@objc private extension JCAPPBaseTabBarController {
    func JCAPPneedUserRelogin() {
        let loginNav: JCAPPBaseNavigationController = JCAPPBaseNavigationController(rootViewController: JCAPPUserLoginViewController())
        loginNav.modalPresentationStyle = .fullScreen
        self.present(loginNav, animated: true)
    }
}
