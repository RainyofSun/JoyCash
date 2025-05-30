//
//  JCAPPWebPageViewController.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/19.
//

import UIKit
import CYSwiftExtension
import StoreKit

class JCAPPWebPageViewController: APPWebController {

    private var buryBeginTime: String = ""
    
    override func hookMethodUI() {
        super.hookMethodUI()
        // 重新获取定位
        DeviceAuthorizationTool.authorization().requestDeviceLocation()
        
        self.view.backgroundColor = UIColor.init(hexString: "#E2EFFB")!
        self.setProcessBarTrackColor(BLUE_COLOR_515FF8, tintColor: CYAN_COLOR_56E1FE)
    }
    
    override func shouldPop() -> Bool {
        return self.webControllerCanPop()
    }
    
    override func hookMethodWebFuncCallback(_ funcName: String, funcParams: [String]) {
        super.hookMethodWebFuncCallback(funcName, funcParams: funcParams)
        
        APPCocoaLog.debug("接受到JS传递的消息：\(funcName) body = \(funcParams)")

        if funcName == JC_CloseWebPage {
            let _ = self.shouldPop()
        }
        
        if funcName == JC_PageTransitionNoParams || funcName == JC_PageTransitionWithParams ||
            funcName == JC_CloseAndGotoMineCenter {
            JCAPPPageRouting.shared.JCAPPJoyCashPageRouter(routeUrl: funcParams.first ?? "", backToRoot: true)
        }
        
        if funcName == JC_CloseAndGotoHome {
            JCAPPPageRouting.shared.JCAPPJoyCashPageRouter(routeUrl: APP_HOME_PAGE)
        }
        
        if funcName == JC_CloseAndGotoLoginPage {
            JCAPPPageRouting.shared.JCAPPJoyCashPageRouter(routeUrl: APP_LOGIN_PAGE)
        }
        
        if funcName == JC_GotoAppStore {
            if #available(iOS 14.0, *) {
                if let scene = UIApplication.shared.currentScene {
                    SKStoreReviewController.requestReview(in: scene)
                }
            } else {
                SKStoreReviewController.requestReview()
            }
        }
        
        if funcName == JC_ConfirmApplyBury {
            // 刷新定位信息
            DeviceAuthorizationTool.authorization().requestDeviceLocation()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3, execute: {
                self.buryBeginTime = Date().jk.dateToTimeStamp()
                // 埋点
                JCAPPBuriedPointReport.JCAPPRiskControlInfoBuryReport(riskType: JCAPPRiskControlPointsType.JC_APP_EndLoanApply, beginTime: self.buryBeginTime, endTime: Date().jk.dateToTimeStamp(), orderNum: JCAPPPublic.shared.productOrderNum)
            })
        }
        
        if funcName == JC_StartBindingBankCard {
            self.buryBeginTime = Date().jk.dateToTimeStamp()
        }
        
        if funcName == JC_EndBindingBankCard {
            // 刷新定位信息
            DeviceAuthorizationTool.authorization().requestDeviceLocation()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3, execute: {
                JCAPPBuriedPointReport.JCAPPRiskControlInfoBuryReport(riskType: JCAPPRiskControlPointsType.JC_APP_BindingBankCard, beginTime: self.buryBeginTime, endTime: Date().jk.dateToTimeStamp())
            })
        }
    }
}

extension UIApplication {
    var currentScene: UIWindowScene? {
        connectedScenes.first { $0.activationState == .foregroundActive } as? UIWindowScene
    }
}
