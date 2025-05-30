//
//  SceneDelegate.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/19.
//

import UIKit
import Toast
@_exported import CYSwiftExtension

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        // 设置公共参数
        self.JCAPPSetAppPblicParams()
        // 设置请求地址
        APPNetRequestURLConfig.setNetworkDebugRequestURL("https://ka.acreditar-lending.com/quen", releaseUrl: "https://ka.acreditar-lending.com/quen")
        // 初始化log 日志
        APPCocoaLog.shared.registe(with: EnvType.other)
        // 开启网络监测
        DeviceNetObserver.shared.StartNetworkStatusListener()
        // 设备认证
        DeviceAuthorizationTool.authorization()
        // 读取本地化登录信息
        JCAPPPublic.shared.JCAPPdecoderUserLogin()
        // 设置根控制器
        self.setApplicationRootWindow()
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3, execute: {
            self.deviceAuthorization()
        })
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

private extension SceneDelegate {
    func JCAPPSetAppPblicParams() {
        let public_params: APPPublicParamsKey = APPPublicParamsKey()
        public_params.appVersionKey = "carbon"
        public_params.deviceNameKey = "lithium"
        public_params.countryCodeKey = "chip"
        public_params.idfaKey = "ratio"
        public_params.idfvKey = "potentially"
        public_params.loginTokenKey = "any"
        APPPublicParams.request().appCommonParamsKeyModel(public_params)
    }
    
    func setApplicationRootWindow() {
        CSToastManager.setDefaultPosition(CSToastPositionCenter)
        
        self.window?.backgroundColor = .white
        let guideVC = JCAPPBeginnerGuideViewController()
        guideVC.beginerDelegate = self
        self.window?.rootViewController = guideVC
        self.window?.makeKeyAndVisible()
    }
    
    func deviceAuthorization() {
        DeviceAuthorizationTool.authorization().requestDeviceIDFAAuthrization { (auth: Bool) in
            
        }
        
        DeviceAuthorizationTool.authorization().requestDeviceLocationAuthrization(WhenInUse)
        
        if DeviceAuthorizationTool.authorization().locationAuthorization() == Authorized || DeviceAuthorizationTool.authorization().locationAuthorization() == Limited {
            DeviceAuthorizationTool.authorization().startDeviceLocation()
            // 埋点上报
            if JCAPPPublic.shared.isAppInitializationSuccess {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                    JCAPPBuriedPointReport.JCAPPLocationBuryReport()
                })
            } else {
                APPCocoaLog.debug("-------- APP 初始化接口未完成 ----------")
            }
        }
        
        if DeviceAuthorizationTool.authorization().attTrackingStatus() == .authorized {
            // 埋点上报
            if JCAPPPublic.shared.isAppInitializationSuccess {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    JCAPPBuriedPointReport.JCAPPIDFAAndIDFVBuryReport()
                })
            } else {
                APPCocoaLog.debug("-------- APP 初始化接口未完成 ----------")
            }
        }
        
        if JCAPPPublic.shared.isAppInitializationSuccess {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                JCAPPBuriedPointReport.JCAPPDeviceInfoBuryReport()
            })
        } else {
            APPCocoaLog.debug("-------- APP 初始化接口未完成 ----------")
        }
    }
}

extension SceneDelegate: APPBeginnerGuideProtocol {
    func beginnerGuideDidDismiss() {
        let transtition = CATransition()
        transtition.duration = 0.5
        transtition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        transtition.type = .fade
        self.window?.layer.add(transtition, forKey: nil)
        self.window?.rootViewController = JCAPPBaseTabBarController()
    }
}

