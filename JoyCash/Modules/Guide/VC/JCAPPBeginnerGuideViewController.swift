//
//  JCAPPBeginnerGuideViewController.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/20.
//

import UIKit
import FBSDKCoreKit
import CYSwiftExtension

protocol APPBeginnerGuideProtocol: AnyObject {
    func beginnerGuideDidDismiss()
}

class JCAPPBeginnerGuideViewController: JCAPPBaseViewController {
    
    weak open var beginerDelegate: APPBeginnerGuideProtocol?
    private lazy var JCAPPtryButton: APPActivityButton = APPActivityButton.JCAPPbuildJoyCashGradientLoadingButton(String.JCAPP_woskhaksjdString(), titleFont: UIFont.JCAPPgilroyFont(14), cornerRadius: 23)
    
    override func JCAPPbuildViewUI() {
        super.JCAPPbuildViewUI()
        self.JCAPPtryButton.isHidden = true
        self.JCAPPgradientView.isHidden = true
        self.JCAPPcontentView.isHidden = true
        self.view.layer.contents = UIImage(named: "app_launch")?.cgImage
        
        self.JCAPPtryButton.addTarget(self, action: #selector(JCAPPclickTryButton(sender: )), for: UIControl.Event.touchUpInside)
        
        self.view.addSubview(self.JCAPPtryButton)
        
        NotificationCenter.default.addObserver(self, selector: #selector(JCAPPdeviceNetworkChange(sender: )), name: NSNotification.Name(APPLICATION_NET_CHANGE), object: nil)
        self.JCAPPpageNetowrkRequest()
    }
    
    override func JCAPPlayoutControlViews() {
        super.JCAPPlayoutControlViews()
        
        self.JCAPPcontentView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.JCAPPtryButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(APP_PADDING_UNIT * 17)
            make.bottom.equalToSuperview().offset(-UIDevice.app_tabbarAndSafeAreaHeight() - APP_PADDING_UNIT * 10)
            make.height.equalTo(46)
        }
    }
    
    override func JCAPPpageNetowrkRequest() {
        super.JCAPPpageNetowrkRequest()
        var language_code: String = "en"
        if #available(iOS 16, *) {
            language_code = Locale.current.language.languageCode?.identifier ?? language_code
        } else {
            language_code = Locale.current.languageCode ?? language_code
        }
        
        // 是否开启了 VPN
        let isOpenVPN: Bool = UIDevice.isVPNEnabled();
        // 是否开启了代理
        let isOpenProxy: Bool = UIDevice.getProxyStatus("https://www.baidu.com")
        
        APPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("said/concerning", requestParams: ["concerning": language_code, "discoveries": isOpenProxy ? "1" : "0", "physiology": isOpenVPN ? "1" : "0"])) { [weak self] (res: URLSessionDataTask, res1: APPSuccessResponse) in
            guard let _dict = res1.jsonDict, let _model = JCAPPBeginnerModel.model(withJSON: _dict) else {
                return
            }
            
            JCAPPPublic.shared.isAppInitializationSuccess = true
            JCAPPPublic.shared.privacyURL = _model.computational
            if _model.chip != .zero {
                JCAPPPublic.shared.countryCode = _model.chip
                APPPublicParams.request().appUpdateLoginToken(nil, withContryCode: "\(_model.chip)")
            }
            
            if _model.power == 1 && DeviceAuthorizationTool.authorization().locationAuthorization() != Authorized && DeviceAuthorizationTool.authorization().locationAuthorization() != Limited {
                JCAPPPublic.shared.showPositionAlert = true
            }
#if DEBUG
#else
            if let _face_model = _model.practical {
                self?.JCAPPFacebookSDKinitialization(_face_model)
            }
#endif
            if APPInfomationCache.applicationFirstInstall() {
                self?.JCAPPtryButton.isHidden = false
                self?.JCAPPcontentView.isHidden = false
                self?.JCAPPtryButton.setTitle("Next", for: UIControl.State.normal)
            } else {
                self?.beginerDelegate?.beginnerGuideDidDismiss()
            }
        } failure: {[weak self] _, _ in
            self?.JCAPPtryButton.isHidden = false
            self?.JCAPPswitchRequestAddress()
        }
    }
}

extension JCAPPBeginnerGuideViewController {
    func JCAPPFacebookSDKinitialization(_ facebookModel: JCBeginnerFacebookModel) {
        Settings.shared.appID = facebookModel.semiconductor
        Settings.shared.displayName = facebookModel.advances
        Settings.shared.clientToken = facebookModel.built
        Settings.shared.appURLSchemeSuffix = facebookModel.crucial
        Settings.shared.isAutoLogAppEventsEnabled = true
        ApplicationDelegate.shared.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)
    }
    
    func JCAPPswitchRequestAddress() {
        let config: NetworkRequestConfig = NetworkRequestConfig.defaultRequestConfig(Dynamic_Domain_Name_URL + Dynamic_Domain_Name_Path, requestParams: nil)
        config.requestType = .download
        APPNetRequestManager.afnReqeustType(config) { [weak self] (task: URLSessionDataTask, res: APPSuccessResponse) in
            guard let _str = res.responseMsg, let _domain_models = NSArray.modelArray(with: JCAPPNetworkDomainModel.self, json: _str) as? [JCAPPNetworkDomainModel] else {
                return
            }
            
            for item in _domain_models {
                if let _url = item.cp, APPNetRequestURLConfig.reloadNetworkRequestDomainURL(_url) {
                    APPNetRequestConfig.reloadNetworkRequestURL()
                    self?.JCAPPpageNetowrkRequest()
                    break
                }
            }
        }
    }
}

@objc private extension JCAPPBeginnerGuideViewController {
    func JCAPPclickTryButton(sender: APPActivityButton) {
        if self.JCAPPcontentView.isHidden {
            APPNetRequestURLConfig.clearDomainURLCache()
            self.JCAPPpageNetowrkRequest()
        } else {
            self.beginerDelegate?.beginnerGuideDidDismiss()
        }
    }
    
    func JCAPPdeviceNetworkChange(sender: Notification) {
        if let _net_state = sender.object as? DeviceNetObserver.NetworkStatus, _net_state != .NetworkStatus_NoNet, APPInfomationCache.applicationFirstInstall() {
            // 第一次安装时，等到网络授权之后，再重新请求初始化
            self.JCAPPpageNetowrkRequest()
            // 关闭网络探测
            DeviceNetObserver.shared.StopNetworkObserverListener()
            NotificationCenter.default.removeObserver(self)
        }
    }
}
