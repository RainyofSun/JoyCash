//
//  JCAPPBeginnerGuideViewController.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/20.
//

import UIKit
import FBSDKCoreKit

protocol APPBeginnerGuideProtocol: AnyObject {
    func beginnerGuideDidDismiss()
}

class JCAPPBeginnerGuideViewController: JCAPPBaseViewController {
    
    weak open var beginerDelegate: APPBeginnerGuideProtocol?
    private lazy var firstImgView: UIImageView = UIImageView(image: UIImage(named: "guide_1"))
    private lazy var secondImgView: UIImageView = UIImageView(image: UIImage(named: "guide_2"))
    private lazy var thirdImgView: UIImageView = UIImageView(image: UIImage(named: "guide_3"))
    private lazy var tryButton: JCAPPActivityButton = JCAPPActivityButton.buildJoyCashGradientLoadingButton("Try again", titleFont: UIFont.gilroyFont(14), cornerRadius: 23)
    
    override func buildViewUI() {
        super.buildViewUI()
        self.tryButton.isHidden = true
        self.gradientView.isHidden = true
        self.contentView.isHidden = true
        self.contentView.isScrollEnabled = false
        self.contentView.contentSize = CGSize(width: ScreenWidth * 3, height: .zero)
        self.view.layer.contents = UIImage(named: "app_launch")?.cgImage
        
        self.contentView.showsHorizontalScrollIndicator = false
        self.contentView.isPagingEnabled = true
        self.tryButton.addTarget(self, action: #selector(clickTryButton(sender: )), for: UIControl.Event.touchUpInside)
        
        self.contentView.addSubview(self.firstImgView)
        self.contentView.addSubview(self.secondImgView)
        self.contentView.addSubview(self.thirdImgView)
        
        self.view.addSubview(self.tryButton)
        
        NotificationCenter.default.addObserver(self, selector: #selector(deviceNetworkChange(sender: )), name: NSNotification.Name(APPLICATION_NET_CHANGE), object: nil)
#if DEBUG
        self.pageNetowrkRequest()
#else
        if !JCAPPInfomationCache.applicationFirstInstall() {
            self.pageNetowrkRequest()
        }
#endif
    }
    
    override func layoutControlViews() {
        super.layoutControlViews()
        
        self.contentView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.firstImgView.snp.makeConstraints { make in
            make.left.top.size.equalToSuperview()
        }
        
        self.secondImgView.snp.makeConstraints { make in
            make.left.equalTo(self.firstImgView.snp.right)
            make.top.size.equalTo(self.firstImgView)
        }
        
        self.thirdImgView.snp.makeConstraints { make in
            make.left.equalTo(self.secondImgView.snp.right)
            make.size.top.equalTo(self.secondImgView)
        }
        
        self.tryButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(APP_PADDING_UNIT * 17)
            make.bottom.equalToSuperview().offset(-UIDevice.xp_tabBarFullHeight() - APP_PADDING_UNIT * 10)
            make.height.equalTo(46)
        }
    }
    
    override func pageNetowrkRequest() {
        super.pageNetowrkRequest()
        var language_code: String = "en"
        if #available(iOS 16, *) {
            language_code = Locale.current.language.languageCode?.identifier ?? language_code
        } else {
            language_code = Locale.current.languageCode ?? language_code
        }
        
        JCAPPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("said/concerning", requestParams: ["concerning": language_code, "discoveries": "0", "physiology": "0"])) { [weak self] (res: URLSessionDataTask, res1: JCAPPSuccessResponse) in
            guard let _dict = res1.jsonDict, let _model = JCAPPBeginnerModel.model(withJSON: _dict) else {
                return
            }
            
            JCAPPPublic.shared.isAppInitializationSuccess = true
            JCAPPPublic.shared.privacyURL = _model.computational
            if let _code = _model.awarded?.chip {
                JCAPPPublic.shared.countryCode = _code
            }
            
            if _model.power == 1 && JCAPPDeviceAuthorizationTool.authorization().locationAuthorization() != Authorized && JCAPPDeviceAuthorizationTool.authorization().locationAuthorization() != Limited && JCAPPInfomationCache.todayShouldShowLocationAlert() {
                // 弹出定位授权弹窗
                self?.showSystemStyleSettingAlert("La aplicación actual recopila su información de ubicación, la utiliza para la evaluación de riesgos de préstamos y le recomienda productos personalizados. Puede abrir Settings-Privacy System y desactivarlo en cualquier momento.", okTitle: nil, cancelTitle: nil)
            }
#if DEBUG
#else
//            if let _face_model = _model.practical {
//                self?.FacebookSDKinitialization(_face_model)
//            }
#endif
            if JCAPPInfomationCache.applicationFirstInstall() {
                self?.tryButton.isHidden = false
                self?.contentView.isHidden = false
                self?.tryButton.setTitle("Next", for: UIControl.State.normal)
            } else {
                self?.beginerDelegate?.beginnerGuideDidDismiss()
            }
        } failure: {[weak self] _, _ in
            self?.tryButton.isHidden = false
            self?.switchRequestAddress()
        }
    }
}

extension JCAPPBeginnerGuideViewController {
    func FacebookSDKinitialization(_ facebookModel: JCBeginnerFacebookModel) {
        Settings.shared.appID = facebookModel.semiconductor
        Settings.shared.displayName = facebookModel.advances
        Settings.shared.clientToken = facebookModel.built
        Settings.shared.appURLSchemeSuffix = facebookModel.crucial
        Settings.shared.isAutoLogAppEventsEnabled = true
        ApplicationDelegate.shared.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)
    }
    
    func switchRequestAddress() {
        let config: NetworkRequestConfig = NetworkRequestConfig.defaultRequestConfig(Dynamic_Domain_Name_URL + Dynamic_Domain_Name_Path, requestParams: nil)
        config.requestType = .download
        JCAPPNetRequestManager.afnReqeustType(config) { [weak self] (task: URLSessionDataTask, res: JCAPPSuccessResponse) in
            guard let _str = res.responseMsg, let _domain_models = NSArray.modelArray(with: JCAPPNetworkDomainModel.self, json: _str) as? [JCAPPNetworkDomainModel] else {
                return
            }
            
            for item in _domain_models {
                if let _url = item.vch, JCAPPNetRequestURLConfig.reloadNetworkRequestDomainURL(_url) {
                    JCAPPNetRequestConfig.reloadNetworkRequestURL()
                    self?.pageNetowrkRequest()
                    break
                }
            }
        }
    }
}

@objc private extension JCAPPBeginnerGuideViewController {
    func clickTryButton(sender: JCAPPActivityButton) {
        if self.contentView.isHidden {
            self.pageNetowrkRequest()
        } else {
            if self.contentView.contentOffset == .zero {
                self.contentView.setContentOffset(CGPoint(x: ScreenWidth, y: .zero), animated: true)
            } else if self.contentView.contentOffset.x == ScreenWidth {
                self.contentView.setContentOffset(CGPoint(x: ScreenWidth * 2, y: .zero), animated: true)
            } else {
                self.beginerDelegate?.beginnerGuideDidDismiss()
            }
        }
    }
    
    func deviceNetworkChange(sender: Notification) {
        if let _net_state = sender.object as? JCAPPDeviceNetObserver.NetworkStatus, _net_state != .NetworkStatus_NoNet, JCAPPInfomationCache.applicationFirstInstall() {
            // 第一次安装时，等到网络授权之后，再重新请求初始化
            self.pageNetowrkRequest()
            // 关闭网络探测
            JCAPPDeviceNetObserver.shared.StopNetworkObserverListener()
            NotificationCenter.default.removeObserver(self)
        }
    }
}
