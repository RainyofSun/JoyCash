//
//  JCAPPWebPageViewController.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/19.
//

import UIKit
import WebKit
import StoreKit

class JCAPPWebPageViewController: JCAPPBaseViewController {

    private var linkURL: String?
    private var gotoRoot: Bool = true
    
    private lazy var webView: WKWebView = {
        let view = WKWebView(frame: CGRect.zero, configuration: self.setWebViewConfig())
        view.navigationDelegate = self // 导航代理
        view.allowsBackForwardNavigationGestures = true // 允许左滑返回
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var processBarView: UIProgressView = {
        let view = UIProgressView(progressViewStyle: .default)
        view.trackTintColor = BLUE_COLOR_515FF8
        view.tintColor = CYAN_COLOR_56E1FE
        view.isHidden = true
        return view
    }()
    
    init(withWebLinkURL url: String, backToRoot root: Bool = true) {
        super.init(nibName: nil, bundle: nil)
        self.linkURL = url
        self.gotoRoot = root
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func buildViewUI() {
        self.reloadDeviceLocation()
        
        self.view.backgroundColor = UIColor.init(hexString: "#E2EFFB")!
        
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        self.webView.addObserver(self, forKeyPath: "title", options: .new, context: nil)
        
        self.view.addSubview(self.webView)
        self.view.addSubview(self.processBarView)
        
        if let _url = self.linkURL, let _webURL = URL.init(string: _url) {
            self.webView.load(URLRequest.init(url: _webURL))
        }
    }
    
    override func layoutControlViews() {
        
        self.processBarView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(UIDevice.app_navigationBarAndStatusBarHeight())
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(2)
        }
        
        self.webView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(self.processBarView.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
    
    override func shouldPop() -> Bool {
        if self.webView.canGoBack {
            self.webView.goBack()
        } else {
            self.removeWebFuncObserver()
            if let _nav = self.navigationController {
                if _nav.children.count > 1 {
                    if self.gotoRoot {
                        _nav.popToRootViewController(animated: true)
                    } else {
                        _nav.popViewController(animated: true)
                    }
                } else {
                    if self.presentingViewController != nil {
                        self.navigationController?.dismiss(animated: true)
                    }
                }
            } else {
                self.dismiss(animated: true)
            }
        }
        
        return false
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        JCAPPProductLog.debug("网页加载进度---\(webView.estimatedProgress)")
        if keyPath == "estimatedProgress" {
            DispatchQueue.main.async {
                let viewProgress = Float(self.webView.estimatedProgress)
                self.processBarView.setProgress(viewProgress, animated: true)
                if viewProgress >= 1.0 {
                    self.processBarView.progress = 0
                }
            }
        } else if keyPath == "title" {
            self.title = self.webView.title
        }
    }
}

extension JCAPPWebPageViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.processBarView.isHidden = false
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.processBarView.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.processBarView.isHidden = true
    }
}

// MARK: WKScriptMessageHandler
extension JCAPPWebPageViewController: WKScriptMessageHandler {
    // 处理js传递的消息
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        JCAPPProductLog.debug("接受到JS传递的消息：\(message.name) body = \(message.body)")

        if message.name == JC_CloseWebPage {
            let _ = self.shouldPop()
        }
        
        if message.name == JC_PageTransitionNoParams || message.name == JC_PageTransitionWithParams ||
            message.name == JC_CloseAndGotoMineCenter {
            if let _paramArray = message.body as? NSArray, let _url = _paramArray.firstObject as? String {
                JCAPPPageRouting.shared.JoyCashPageRouter(routeUrl: _url, backToRoot: true)
            }
        }
        
        if message.name == JC_CloseAndGotoHome {
            JCAPPPageRouting.shared.JoyCashPageRouter(routeUrl: APP_HOME_PAGE)
        }
        
        if message.name == JC_CloseAndGotoLoginPage {
            JCAPPPageRouting.shared.JoyCashPageRouter(routeUrl: APP_LOGIN_PAGE)
        }
        
        if message.name == JC_GotoAppStore {
            if #available(iOS 14.0, *) {
                if let scene = UIApplication.shared.currentScene {
                    SKStoreReviewController.requestReview(in: scene)
                }
            } else {
                SKStoreReviewController.requestReview()
            }
        }
        
        if message.name == JC_ConfirmApplyBury {
            // 刷新定位信息
            self.reloadDeviceLocation()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3, execute: {
                self.buryBeginTime = Date().jk.dateToTimeStamp()
                // 埋点
                JCAPPBuriedPointReport.JCAPPRiskControlInfoBuryReport(riskType: JCRiskControlPointsType.JC_APP_EndLoanApply, beginTime: self.buryBeginTime, endTime: Date().jk.dateToTimeStamp(), orderNum: JCAPPPublic.shared.productOrderNum)
            })
        }
        
        if message.name == JC_StartBindingBankCard {
            self.buryBeginTime = Date().jk.dateToTimeStamp()
        }
        
        if message.name == JC_EndBindingBankCard {
            // 刷新定位信息
            self.reloadDeviceLocation()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3, execute: {
                JCAPPBuriedPointReport.JCAPPRiskControlInfoBuryReport(riskType: JCRiskControlPointsType.JC_APP_BindingBankCard, beginTime: self.buryBeginTime, endTime: Date().jk.dateToTimeStamp())
            })
        }
    }
}

private extension JCAPPWebPageViewController {
    func setWebViewConfig() -> WKWebViewConfiguration {
        let preferences: WKPreferences = WKPreferences()
        preferences.minimumFontSize = 15
        preferences.javaScriptEnabled = true
        preferences.javaScriptCanOpenWindowsAutomatically = true

        let webConfig: WKWebViewConfiguration = WKWebViewConfiguration()
        webConfig.preferences = preferences
        webConfig.allowsInlineMediaPlayback = true
        webConfig.allowsPictureInPictureMediaPlayback = true
        webConfig.userContentController = self.buildUserContentController()
        
        return webConfig
    }
    
    func buildUserContentController() -> WKUserContentController {
        let _scriptHandler: JCAPPWeakScriptHandler = JCAPPWeakScriptHandler.init(weakScriptHandler: self)
        let _user_content: WKUserContentController = WKUserContentController()
        _user_content.add(_scriptHandler, name: JC_CloseWebPage)
        _user_content.add(_scriptHandler, name: JC_PageTransitionNoParams)
        _user_content.add(_scriptHandler, name: JC_PageTransitionWithParams)
        _user_content.add(_scriptHandler, name: JC_CloseAndGotoHome)
        _user_content.add(_scriptHandler, name: JC_CloseAndGotoLoginPage)
        _user_content.add(_scriptHandler, name: JC_CloseAndGotoMineCenter)
        _user_content.add(_scriptHandler, name: JC_GotoAppStore)
        _user_content.add(_scriptHandler, name: JC_ConfirmApplyBury)
        _user_content.add(_scriptHandler, name: JC_StartBindingBankCard)
        _user_content.add(_scriptHandler, name: JC_EndBindingBankCard)
        return _user_content
    }
    
    func removeWebFuncObserver() {
        self.webView.configuration.userContentController.removeAllUserScripts()
        self.webView.configuration.userContentController.removeAllScriptMessageHandlers()
        self.webView.removeObserver(self, forKeyPath: "estimatedProgress")
        self.webView.removeObserver(self, forKeyPath: "title")
    }
}

extension UIApplication {
    var currentScene: UIWindowScene? {
        connectedScenes.first { $0.activationState == .foregroundActive } as? UIWindowScene
    }
}
