//
//  JCAPPBaseNavigationController.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/19.
//

import UIKit
@_exported import SnapKit

class JCAPPBaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.setNavigationAppearance()
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if !self.children.isEmpty {
            viewController.hidesBottomBarWhenPushed = true
        }
        
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        super.pushViewController(viewController, animated: animated)
    }
    
    deinit {
        deallocPrint()
    }
}

/// 遵循这个协议，可以隐藏导航栏
protocol HideNavigationBarProtocol where Self: UIViewController {}

extension JCAPPBaseNavigationController: UINavigationControllerDelegate {
    //导航控制器将要显示控制器时调用
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if (viewController is HideNavigationBarProtocol){
            self.setNavigationBarHidden(true, animated: true)
        }else {
            self.setNavigationBarHidden(false, animated: true)
        }
    }
}

extension JCAPPBaseNavigationController: UINavigationBarDelegate {
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        if self.viewControllers.count < navigationBar.items?.count ?? 1 {
            return true
        }
        var shouldPop = true
        // 看一下当前控制器有没有实现代理方法 currentViewControllerShouldPop
        // 如果实现了，根据当前控制器的代理方法的返回值决定
        // 没过没有实现 shouldPop = YES
        
        if let currentVC = self.topViewController, currentVC.conforms(to: CurrentControllerShouldPopProtocol.self) {
            shouldPop = currentVC.shouldPop()
        }
        
        if (shouldPop == true) {
            DispatchQueue.main.async {
                self.popViewController(animated: true)
            }
        } else {
            // 让系统backIndicator 按钮透明度恢复为1
            for subview in navigationBar.subviews
            {
                if (0.0 < subview.alpha && subview.alpha < 1.0) {
                    UIView.animate(withDuration: 0.25, animations: {
                        subview.alpha = 1.0
                    })
                }
            }
        }
        return false
    }
}

// MARK: Private Methods
private extension JCAPPBaseNavigationController {
    func setNavigationAppearance() {
        
        let attrs = [NSAttributedString.Key.foregroundColor: UIColor.hexStringColor(hexString: "#27272E"),
                     NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)]
        UINavigationBar.appearance().titleTextAttributes = attrs as [NSAttributedString.Key : Any]
        let originalImage = UIImage(systemName: "chevron.backward")
        let tintedImage = originalImage?.withTintColor(UIColor.hexStringColor(hexString: "#27272E"), renderingMode: .alwaysOriginal)
        UINavigationBar.appearance().backIndicatorImage = tintedImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = tintedImage
        UINavigationBar.appearance().shadowImage = barShadowImage()
    }
    
    func barShadowImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: ScreenWidth, height: 0.5), false, 0)
        let path = UIBezierPath.init(rect: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 0.5))
        UIColor.clear.setFill()// 自定义NavigationBar分割线颜色
        path.fill()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
