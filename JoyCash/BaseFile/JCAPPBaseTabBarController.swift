//
//  JCAPPBaseTabBarController.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/19.
//

import UIKit

class JCAPPBaseTabBarController: UITabBarController {

    private var jcTabBar: JCAPPCustomBar?
    private var vcArray: [UIViewController.Type] = [JCAPPMainViewController.self, JCAPPCommodityOrderViewController.self, JCAPPMinePageViewController.self]
    private var tab_img_array: [String] = ["tab_main_nor", "tab_order_nor", "tab_mine_nor"]
    private var tab_sel_img_array: [String] = ["tab_main_sel", "tab_order_sel", "tab_mine_sel"]
    
    override var selectedIndex: Int {
        didSet {
            self.jcTabBar?.selectedTabbarItem(selectedIndex)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTabbarUI()
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
    func setupTabbarUI() {
        // 保存标识-- 第一次安装
        JCAPPInfomationCache.saveApplicationInstallMark()
        let tabbar: JCAPPCustomBar = JCAPPCustomBar(frame: CGRect(origin: CGPointZero, size: CGSize(width: ScreenWidth, height: UIDevice.xp_tabBarFullHeight())))
        self.setValue(tabbar, forKey: "tabBar")
        tabbar.setTabbarTitles(barItemImages: tab_img_array, barItemSelectedImages: tab_sel_img_array)
        tabbar.barDelegate = self
        var listVC: [UIViewController] = []
        vcArray.forEach { (item: UIViewController.Type) in
            listVC.append(JCAPPBaseNavigationController(rootViewController: item.init()))
        }
        self.viewControllers = listVC
        
        self.jcTabBar = tabbar
        self.selectedIndex = .zero
        
        JCAPPPublic.shared.addObserver(self, forKeyPath: LOGIN_OBERVER_KEY, options: [.new], context: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(needUserRelogin), name: NSNotification.Name(APP_LOGIN_EXPIRED_NOTIFICATION), object: nil)
    }
}

extension JCAPPBaseTabBarController: VCCustomTabbarProtocol {
    func jc_canSelected(shouldSelectedIndex index: Int) -> Bool {
        guard let _vc_array = self.viewControllers, index < _vc_array.count else {
            return false
        }
        
        guard let _nav = _vc_array[index] as? JCAPPBaseNavigationController else {
            return false
        }
        
        let _top_vc = _nav.topViewController
        if (_top_vc is JCAPPCommodityOrderViewController || _top_vc is JCAPPMinePageViewController) && JCAPPPublic.shared.appLoginInfo?.any == nil {
            self.needUserRelogin()
            return false
        }
        
        return true
    }
    
    func jc_didSelctedItem(_ tabbar: JCAPPCustomBar, item: UIButton, index: Int) {
        self.selectedIndex = index
    }
}

@objc private extension JCAPPBaseTabBarController {
    func needUserRelogin() {
        let loginNav: JCAPPBaseNavigationController = JCAPPBaseNavigationController(rootViewController: JCAPPUserLoginViewController())
        loginNav.modalPresentationStyle = .fullScreen
        self.present(loginNav, animated: true)
    }
}
